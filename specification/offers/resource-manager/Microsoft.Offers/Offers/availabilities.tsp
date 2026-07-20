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

/** Flat properties of an availability, matching the `availabilities` stream. */
@added(Versions.v2026_06_30_preview)
model AvailabilityProperties {
  /** Foreign key linking to the parent product. */
  @maxLength(64)
  productId: string;

  /** Product version propagated from the parent product document. */
  version: int32;

  /** Foreign key linking to the parent SKU. */
  @maxLength(64)
  skuId: string;

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
  propertiesEnvelope?: PcdPropertyBag;

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

  /**
   * Full-fidelity embedded BigCat ResourceSet objects for this availability's
   * availability-level `Conditions.ResourceSetIds`. Additive & nullable — null
   * when the embed feature flag is off or no id matches.
   */
  @identifiers(#["resourceSetId"])
  resourceSets?: ResourceSet[];

  /** Dynamic struct containing provenance and internal routing fields. */
  diagnosticsInformation?: PcdPropertyBag;

  /** The provisioning state of the catalog resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

/** The name of the availability (its catalog identifier). */
@added(Versions.v2026_06_30_preview)
@subscriptionResource
model AvailabilityNameParameter is ResourceNameParameter<
  Resource = CatalogAvailability,
  KeyName = "availabilityId",
  SegmentName = "availabilities",
  NamePattern = "^[a-zA-Z0-9._-]{1,64}$"
>;

/** An availability in the commerce catalog. */
@added(Versions.v2026_06_30_preview)
model CatalogAvailability is Azure.ResourceManager.ProxyResource<
  AvailabilityProperties,
  false
> {
  ...AvailabilityNameParameter;
}

/** Read-only catalog access for availabilities. */
@added(Versions.v2026_06_30_preview)
@armResourceOperations
interface Availabilities {
  /**
   * Get a single availability by its identifier. The catalog is globally keyed:
   * the same `availabilityId` returns the same response for all callers under
   * one API version.
   */
  get is ArmResourceRead<
    CatalogAvailability,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * List all availabilities in the catalog available to the subscription. The
   * catalog is globally keyed, so the same set is returned for all callers under
   * one API version.
   */
  listBySubscription is ArmResourceListByParent<
    CatalogAvailability,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}
