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
@removed(Versions.v2026_06_30_preview)
model LookupValueExchangeRequest {
  /** The value-exchange identifier (BigCat UPN id, e.g. `DZH318Z0995B`). */
  @pattern("^[A-Z0-9]{12}$")
  valueExchangeId: string;
}

/** The result of a value-exchange lookup. */
@removed(Versions.v2026_06_30_preview)
model LookupValueExchangeResult {
  /** The value-exchange identifier the result corresponds to. */
  @pattern("^[A-Z0-9]{12}$")
  valueExchangeId: string;

  /** The denormalized, slim value-exchange projection. */
  properties: ValueExchangeProperties;
}

/** The name of the value exchange (its UPN identifier). */
@added(Versions.v2026_06_30_preview)
@subscriptionResource
model ValueExchangeNameParameter
  is ResourceNameParameter<
    Resource = ValueExchange,
    KeyName = "valueExchangeId",
    SegmentName = "valueExchanges",
    NamePattern = "^[A-Z0-9]{12}$"
  >;

/** A value exchange (UPN) in the commerce catalog. */
@added(Versions.v2026_06_30_preview)
model ValueExchange
  is Azure.ResourceManager.ProxyResource<ValueExchangeProperties, false> {
  ...ValueExchangeNameParameter;
}

/** Read-only catalog access for value-exchange (UPN) entries. */
@armResourceOperations
interface ValueExchanges {
  /**
   * Look up a single value-exchange (UPN) by its identifier. The catalog is
   * globally keyed: the same `valueExchangeId` returns the same response for
   * all callers under one API version. Modeled as a POST action because the
   * response is identical for every caller in a subscription and the catalog
   * is not a per-subscription resource collection.
   */
  @removed(Versions.v2026_06_30_preview)
  @autoRoute
  @action("lookupValueExchange")
  lookup is ArmProviderActionSync<
    Request = LookupValueExchangeRequest,
    Response = LookupValueExchangeResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;

  /**
   * Get a single value-exchange (UPN) by its identifier. The catalog is
   * globally keyed: the same `valueExchangeId` returns the same response for
   * all callers under one API version.
   */
  @added(Versions.v2026_06_30_preview)
  get is ArmResourceRead<
    ValueExchange,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}
