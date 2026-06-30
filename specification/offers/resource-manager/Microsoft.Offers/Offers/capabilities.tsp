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

/** Request body for looking up a capability row for an entity. */
@added(Versions.v2026_06_30_preview)
model LookupCapabilityRequest {
  /** Entity product id. */
  @maxLength(64)
  productId: string;

  /** The capability that produced this row (its registry name). */
  @maxLength(128)
  capability: string;

  /** Entity SKU id, when the capability is keyed at that grain. */
  @maxLength(64)
  skuId?: string;

  /** Entity value-exchange (UPN) id, when the capability is keyed at that grain. */
  @maxLength(64)
  valueExchangeId?: string;
}

/** Flat properties of a capability row, matching the `capabilities` (long/EAV) stream. */
@added(Versions.v2026_06_30_preview)
model CapabilityProperties {
  /** Entity SKU id, when the capability is keyed at that grain. */
  @maxLength(64)
  skuId?: string;

  /** Entity value-exchange (UPN) id, when the capability is keyed at that grain. */
  @maxLength(64)
  valueExchangeId?: string;

  /**
   * Per-capability JSON bag serialized as a string; its contract is the
   * capability's `dataSchema`. Keys whose source value is null are dropped.
   */
  data?: string;
}

/** The result of a capability lookup. */
@added(Versions.v2026_06_30_preview)
model LookupCapabilityResult {
  /** The entity product id the result corresponds to. */
  @maxLength(64)
  productId: string;

  /** The capability that produced this row. */
  @maxLength(128)
  capability: string;

  /** The flat capability projection. */
  properties: CapabilityProperties;
}

/** Read-only catalog lookup actions for capabilities. */
@added(Versions.v2026_06_30_preview)
@armResourceOperations
interface Capabilities {
  /**
   * Look up a single capability row for an entity by its product id and
   * capability name (optionally narrowed by skuId / valueExchangeId). The
   * catalog is globally keyed: the same key returns the same response for all
   * callers under one API version. Modeled as a POST action because the
   * response is identical for every caller in a subscription and the catalog
   * is not a per-subscription resource collection.
   */
  @autoRoute
  @action("lookupCapability")
  lookup is ArmProviderActionSync<
    Request = LookupCapabilityRequest,
    Response = LookupCapabilityResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}
