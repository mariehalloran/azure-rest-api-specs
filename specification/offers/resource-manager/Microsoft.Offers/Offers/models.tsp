import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Offers;

// =============================================================================
// Curated property bag used inside Product, Sku, and Availability.
// The RP backend translates the upstream BigCat PCD PascalCase keys into the
// camelCase ARM surface; the bag itself remains an unbounded record because
// the curated allowlist is enforced server-side, not in the API surface.
// =============================================================================

/** A curated property bag projected from the upstream catalog. Unbounded key set. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Curated property bag with an unbounded key set sourced from the upstream BigCat catalog feed; cannot be modeled as an explicit type."
model PcdPropertyBag is Record<unknown>;

// =============================================================================
// Product
// =============================================================================

/** Denormalized product summary for a value exchange. */
model Product {
  /** The stable product identifier. */
  @maxLength(64)
  productId: string;

  /** Product family (for example, "Azure"). */
  @maxLength(64)
  productFamily?: string;

  /** Product type (for example, "Azure"). */
  @maxLength(64)
  productType?: string;

  /** Product kind (for example, "Azure"). */
  @maxLength(64)
  productKind?: string;

  /** Last modified date for the product record. */
  lastModifiedDate?: utcDateTime;

  /** Lifted single-language publisher name from the upstream catalog feed. */
  @maxLength(256)
  publisherName?: string;

  /** Curated product property subset projected from the upstream catalog. */
  properties?: PcdPropertyBag;
}

// =============================================================================
// Sku
// =============================================================================

/** Denormalized SKU summary for a value exchange. */
model Sku {
  /** The stable SKU identifier. */
  @maxLength(64)
  skuId: string;

  /** SKU type (for example, "enterpriseonline"). */
  @maxLength(64)
  skuType?: string;

  /** The product identifier this SKU belongs to. */
  @maxLength(64)
  productId?: string;

  /** Last modified date for the SKU record. */
  lastModifiedDate?: utcDateTime;

  /** Curated SKU property subset projected from the upstream catalog. Includes partner channel and deactivated lifecycle state. */
  properties?: PcdPropertyBag;
}

// =============================================================================
// Availability + sub-models
// =============================================================================

/** Conditions under which the availability applies. */
model AvailabilityConditions {
  /** Start date of the availability window. */
  startDate?: utcDateTime;

  /** End date of the availability window. The upstream `9999-...` sentinel is scrubbed to null. */
  endDate?: utcDateTime;

  /** Whether the availability is permanent. */
  isPermanent?: boolean;

  /** Supported catalog version. */
  supportedCatalogVersion?: int32;

  /** Resource set identifiers. */
  resourceSetIds?: string[];

  /** Eligibility predicate identifiers. */
  eligibilityPredicateIds?: string[];

  /** Client-side conditions. */
  clientConditions?: ClientConditions;
}

/** Client-side conditions for an availability. */
model ClientConditions {
  /** Allowed client platforms; empty list means no platform restriction. */
  allowedPlatforms?: string[];
}

/** A purchase term offered by an availability. */
model AvailabilityTerm {
  /** The stable term identifier. */
  @maxLength(64)
  termId?: string;

  /** ISO-8601 duration for the term (for example, "P1Y"). */
  termUnits?: duration;

  /** Human-readable term description. */
  @maxLength(256)
  termDescription?: string;
}

/** A meter bound to this value exchange (synthesized from the upstream meter data, filtered by meter type). */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Synthesized meter shape projects an unbounded set of keys from the upstream catalog meter data; cannot be modeled as an explicit type."
model AvailabilityMeter is Record<unknown>;

/** Availability information for a value exchange. */
model Availability {
  /** The stable availability identifier (typically equal to the value-exchange id). */
  @maxLength(64)
  availabilityId: string;

  /** Markets in which this availability is offered (ISO 3166 country codes). */
  markets?: string[];

  /** Consumption unit type (for example, "DAY"). */
  @maxLength(64)
  consumptionUnitType?: string;

  /** Display rank for ordering. */
  displayRank?: int32;

  /** Alternate identifiers. */
  alternateIds?: string[];

  /** Last modified date for the availability record. */
  lastModifiedDate?: utcDateTime;

  /** Conditions under which the availability applies. */
  conditions?: AvailabilityConditions;

  /** Purchase terms offered by this availability. */
  @identifiers(#["termId"])
  terms?: AvailabilityTerm[];

  /** Synthesized intersection of the SKU's market properties and the availability's markets. */
  supportedLanguages?: string[];

  /** Synthesized subset of the SKU's meter data filtered by the availability's meter type. */
  @identifiers(#[])
  meters?: AvailabilityMeter[];

  /** Curated availability property subset projected from the upstream catalog. */
  properties?: PcdPropertyBag;
}

// =============================================================================
// ValueExchange (UPN) properties
// =============================================================================

/**
 * Properties of a value exchange (UPN). Wraps the denormalized trio of
 * Product, Sku, and Availability. Slim shape: large blobs (raw meter data,
 * order management data, passthrough sub-objects, co-sell, attributes) are
 * dropped here and live on the rich hydrate response.
 */
model ValueExchangeProperties {
  /** Denormalized product summary. */
  product: Product;

  /** Denormalized SKU summary. */
  sku: Sku;

  /** Availability information for this value exchange. */
  availability: Availability;
}
