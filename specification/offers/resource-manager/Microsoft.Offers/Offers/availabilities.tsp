import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Offers;

/** Request body for looking up an availability by its identifier. */
@added(Versions.v2026_06_30_preview)
model LookupAvailabilityRequest {
  /** Unique identifier for the availability record. */
  @maxLength(64)
  availabilityId: string;
}

/** Flat properties of an availability, matching the `availabilities` stream. */
@added(Versions.v2026_06_30_preview)
model AvailabilityProperties {
  /** Foreign key linking to the parent product. */
  @maxLength(64)
  productId?: string;

  /** Product version propagated from the parent product document. */
  version?: int32;

  /** Foreign key linking to the parent SKU. */
  @maxLength(64)
  skuId?: string;

  /** Numeric rank for determining display ordering of availabilities. */
  displayRank?: int32;

  /** Identifier for the legal/compliance affirmation required at purchase time. */
  @maxLength(64)
  affirmationId?: string;

  /** Consumption unit type feeding the canonical granted-by-scope unit (for example, `PTU`). */
  @maxLength(64)
  consumptionUnitType?: string;

  /** Available purchase/fulfillment actions for this availability. */
  actions?: PcdPropertyBag;

  /** Full availability properties bag containing extended metadata. */
  properties?: PcdPropertyBag;

  /** Verbatim eligibility-evaluation envelope kept as one decision unit. */
  conditions?: PcdPropertyBag;

  /** Order management data at the availability level. */
  orderManagementData?: PcdPropertyBag;

  /** Array of term identifiers applicable to this availability. */
  termIds?: string[];

  /** Markets in which this availability is offered. */
  markets?: string[];

  /** Policies governing this availability (cancellation, refund, etc.). */
  availabilityPolicies?: PcdPropertyBag;

  /** Pricing rule identifiers used to compute the price for this availability. */
  pricingRuleIds?: string[];

  /** Digital asset data associated with this availability's fulfillment. */
  assetsData?: PcdPropertyBag;

  /** Alternate identifiers for this availability. */
  alternateIds?: string[];

  /** Dynamic struct containing provenance and internal routing fields. */
  diagnosticsInformation?: PcdPropertyBag;
}

/** The result of an availability lookup. */
@added(Versions.v2026_06_30_preview)
model LookupAvailabilityResult {
  /** The availability identifier the result corresponds to. */
  @maxLength(64)
  availabilityId: string;

  /** The flat availability projection. */
  properties: AvailabilityProperties;
}

/** Read-only catalog lookup actions for availabilities. */
@added(Versions.v2026_06_30_preview)
@armResourceOperations
interface Availabilities {
  /**
   * Look up a single availability by its identifier. The catalog is globally
   * keyed: the same `availabilityId` returns the same response for all callers
   * under one API version. Modeled as a POST action because the response is
   * identical for every caller in a subscription and the catalog is not a
   * per-subscription resource collection.
   */
  @autoRoute
  @action("lookupAvailability")
  lookup is ArmProviderActionSync<
    Request = LookupAvailabilityRequest,
    Response = LookupAvailabilityResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}
