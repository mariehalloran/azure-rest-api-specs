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

/** Request body for looking up a value exchange (UPN) by its identifier. */
model LookupValueExchangeRequest {
  /** The value-exchange identifier (BigCat UPN id, e.g. `DZH318Z0995B`). */
  @pattern("^[A-Z0-9]{12}$")
  valueExchangeId: string;
}

/** The result of a value-exchange lookup. */
model LookupValueExchangeResult {
  /** The value-exchange identifier the result corresponds to. */
  @pattern("^[A-Z0-9]{12}$")
  valueExchangeId: string;

  /** The denormalized, slim value-exchange projection. */
  properties: ValueExchangeProperties;
}

/** The name of the offer value (its UPN identifier). */
@added(Versions.v2026_06_30_preview)
@subscriptionResource
model OfferValueNameParameter is ResourceNameParameter<
  Resource = OfferValue,
  KeyName = "productCode",
  SegmentName = "offerValues",
  NamePattern = "^[A-Z0-9]{12}$"
>;

/** An offer value (UPN) in the commerce catalog. */
@added(Versions.v2026_06_30_preview)
model OfferValue is Azure.ResourceManager.ProxyResource<
  ValueExchangeProperties,
  false
> {
  ...OfferValueNameParameter;
}

/** Legacy lookup access for value-exchange (UPN) entries. */
@armResourceOperations
interface ValueExchanges {
  /**
   * Look up a single value-exchange (UPN) by its identifier. The catalog is
   * globally keyed: the same `valueExchangeId` returns the same response for
   * all callers under one API version. Modeled as a POST action because the
   * response is identical for every caller in a subscription and the catalog
   * is not a per-subscription resource collection.
   */
  @autoRoute
  @action("lookupValueExchange")
  lookup is ArmProviderActionSync<
    Request = LookupValueExchangeRequest,
    Response = LookupValueExchangeResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

/** Read-only catalog access for offer-value (UPN) entries. */
@added(Versions.v2026_06_30_preview)
@armResourceOperations
interface OfferValues {
  /**
   * Get a single offer value (UPN) by its identifier. The catalog is
   * globally keyed: the same `valueExchangeId` returns the same response for
   * all callers under one API version.
   */
  get is ArmResourceRead<
    OfferValue,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * List all offer-value (UPN) entries in the catalog available to the
   * subscription. The catalog is globally keyed, so the same set is returned for
   * all callers under one API version.
   */
  listBySubscription is ArmResourceListByParent<
    OfferValue,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}
