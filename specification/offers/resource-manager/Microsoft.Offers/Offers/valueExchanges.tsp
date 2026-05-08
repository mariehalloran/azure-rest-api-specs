import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Offers;

/**
 * Value exchange (UPN) resource.
 *
 * A subscription-scoped, read-only proxy resource representing one
 * transactable value-exchange (BigCat UPN) in the Microsoft commercial
 * catalog. Returns the canonical, stable, slim VE shape; the same
 * `valueExchangeId` returns the same response for all callers under one
 * API version. No market/language/fragment inputs are accepted; for
 * localized or market-specific content, use the hydrate action.
 *
 * Addressed at
 * `/subscriptions/{subscriptionId}/providers/Microsoft.Offers/valueExchanges/{valueExchangeId}`.
 */
@subscriptionResource
model ValueExchange is Azure.ResourceManager.ProxyResource<ValueExchangeProperties> {
  ...ResourceNameParameter<
    Resource = ValueExchange,
    KeyName = "valueExchangeId",
    SegmentName = "valueExchanges",
    NamePattern = "^[A-Z0-9]{12}$"
  >;
  ...EntityTagProperty;
}

/** Read-only operations on value-exchange catalog resources. */
@armResourceOperations
interface ValueExchanges {
  /**
   * Get a single value-exchange resource by its identifier. Returns the
   * canonical, stable, slim shape; the same response is returned for the
   * same id under one API version regardless of caller.
   */
  get is ArmResourceRead<ValueExchange>;
}

@@doc(ValueExchange.name,
  "The value-exchange identifier (BigCat UPN id, e.g. `DZH318Z0995B`)."
);
@@doc(ValueExchange.properties, "The properties of the value-exchange resource.");
