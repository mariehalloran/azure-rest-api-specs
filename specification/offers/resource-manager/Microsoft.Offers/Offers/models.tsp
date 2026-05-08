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
// PCD-faithful: PascalCase keys are passed through verbatim from the upstream
// BigCat catalog feed and the key set is unbounded by design (curated allowlist
// is enforced server-side, not in the API surface).
// =============================================================================

/** A curated PCD-faithful property bag. PascalCase keys; unbounded set. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Curated PCD property bag with an unbounded, PascalCase key set sourced verbatim from the upstream BigCat catalog feed; cannot be modeled as an explicit type."
model PcdPropertyBag is Record<unknown>;

// =============================================================================
// Product
// =============================================================================

/** Denormalized product summary for a value exchange. PCD-faithful PascalCase. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "PCD-faithful PascalCase trim per schema design; property names mirror the upstream BigCat catalog feed verbatim."
model Product {
  /** The stable product identifier. */
  ProductId: string;

  /** Product family (for example, "Azure"). */
  ProductFamily?: string;

  /** Product type (for example, "Azure"). */
  ProductType?: string;

  /** Product kind (for example, "Azure"). */
  ProductKind?: string;

  /** Last modified date for the product record. */
  LastModifiedDate?: utcDateTime;

  /** Lifted single-language publisher name from PCD `LocalizedProperties[*].PublisherName`. */
  PublisherName?: string;

  /** Curated PCD `Product.Properties` subset (PascalCase keys verbatim). */
  Properties?: PcdPropertyBag;
}

// =============================================================================
// Sku
// =============================================================================

/** Denormalized SKU summary for a value exchange. PCD-faithful PascalCase. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "PCD-faithful PascalCase trim per schema design; property names mirror the upstream BigCat catalog feed verbatim."
model Sku {
  /** The stable SKU identifier. */
  SkuId: string;

  /** SKU type (for example, "enterpriseonline"). */
  SkuType?: string;

  /** The product identifier this SKU belongs to. */
  ProductId?: string;

  /** Last modified date for the SKU record. */
  LastModifiedDate?: utcDateTime;

  /** Curated PCD `Sku.Properties` subset (PascalCase keys verbatim). Includes `PartnerChannelLifecycleState` and `DeactivatedLifeCycleState`. */
  Properties?: PcdPropertyBag;
}

// =============================================================================
// Availability + sub-models
// =============================================================================

/** Conditions under which the availability applies. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "PCD-faithful PascalCase trim per schema design; property names mirror the upstream BigCat catalog feed verbatim."
model AvailabilityConditions {
  /** Start date of the availability window. */
  StartDate?: utcDateTime;

  /** End date of the availability window. PCD sentinel `9999-...` is scrubbed to null. */
  EndDate?: utcDateTime;

  /** Whether the availability is permanent. */
  IsPermanent?: boolean;

  /** Supported catalog version. */
  SupportedCatalogVersion?: int32;

  /** Resource set identifiers. */
  ResourceSetIds?: string[];

  /** Eligibility predicate identifiers. */
  EligibilityPredicateIds?: string[];

  /** Client-side conditions. */
  ClientConditions?: ClientConditions;
}

/** Client-side conditions for an availability. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "PCD-faithful PascalCase trim per schema design; property names mirror the upstream BigCat catalog feed verbatim."
model ClientConditions {
  /** Allowed client platforms; empty list means no platform restriction. */
  AllowedPlatforms?: string[];
}

/** A purchase term offered by an availability. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "PCD-faithful PascalCase trim per schema design; property names mirror the upstream BigCat catalog feed verbatim."
model AvailabilityTerm {
  /** The stable term identifier. */
  TermId?: string;

  /** ISO-8601 duration for the term (for example, "P1Y"). */
  TermUnits?: string;

  /** Human-readable term description. */
  TermDescription?: string;
}

/** A meter bound to this value exchange (synthesized from `Sku.Properties.MeterData` filtered by `Av.Properties.MeterType`). */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Synthesized meter shape mirrors the upstream PCD MeterData entry verbatim; the key set is unbounded and cannot be modeled as an explicit type."
model AvailabilityMeter is Record<unknown>;

/** Availability information for a value exchange. PCD-faithful PascalCase. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "PCD-faithful PascalCase trim per schema design; property names mirror the upstream BigCat catalog feed verbatim."
model Availability {
  /** The stable availability identifier (typically equal to the value-exchange id). */
  AvailabilityId: string;

  /** Markets in which this availability is offered (ISO 3166 country codes). */
  Markets?: string[];

  /** Consumption unit type (for example, "DAY"). */
  ConsumptionUnitType?: string;

  /** Display rank for ordering. */
  DisplayRank?: int32;

  /** Alternate identifiers. */
  AlternateIds?: string[];

  /** Last modified date for the availability record. */
  LastModifiedDate?: utcDateTime;

  /** Conditions under which the availability applies. */
  Conditions?: AvailabilityConditions;

  /** Purchase terms offered by this availability. */
  @identifiers(#["TermId"])
  Terms?: AvailabilityTerm[];

  /** Synthesized intersection of `Sku.MarketProperties` and `Av.Markets`. */
  SupportedLanguages?: string[];

  /** Synthesized subset of `Sku.Properties.MeterData` filtered by `Av.Properties.MeterType`. */
  @identifiers(#[])
  Meters?: AvailabilityMeter[];

  /** Curated PCD `Availability.Properties` subset (PascalCase keys verbatim). */
  Properties?: PcdPropertyBag;
}

// =============================================================================
// ValueExchange (UPN) properties
// =============================================================================

/**
 * Properties of a value exchange (UPN). Wraps the denormalized PCD trio of
 * Product, Sku, and Availability. Slim shape: large blobs (raw MeterData,
 * OrderManagementData, Passthrough sub-objects, CoSell, Attributes) are
 * dropped here and live on the rich hydrate response.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Value exchange is a read-only catalog projection synthesized from the upstream BigCat feed; no ARM provisioning lifecycle applies. The resource has no create/update/delete operations and therefore no provisioning state to track."
#suppress "@azure-tools/typespec-azure-core/casing-style" "PCD-faithful PascalCase trim per schema design; property names mirror the upstream BigCat catalog feed verbatim."
model ValueExchangeProperties {
  /** Denormalized product summary. */
  Product: Product;

  /** Denormalized SKU summary. */
  Sku: Sku;

  /** Availability information for this value exchange. */
  Availability: Availability;
}

// =============================================================================
// Enumeration
// =============================================================================

/** Properties of an enumeration set returned by the enumerations endpoint. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Enumeration is a read-only catalog projection of static domain data sourced from the upstream BigCat enumeration controllers; no ARM provisioning lifecycle applies. The resource has no create/update/delete operations and therefore no provisioning state to track."
model EnumerationProperties {
  /** The enumeration type key (for example, "categories", "productFamilies", "claimTypes"). */
  enumerationType: string;

  /** The enumeration values. Shape is enumeration-specific; values are passed through verbatim from the upstream BigCat catalog feed. */
  values?: unknown[];
}
