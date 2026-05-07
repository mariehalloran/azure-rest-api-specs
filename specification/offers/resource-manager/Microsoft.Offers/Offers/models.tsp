import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Offers;

/**
 * Ownership classification of a product. Indicates whether the product is
 * owned by Microsoft (first-party) or by a third-party publisher.
 */
union UpnOwnership {
  string,

  /** First-party (Microsoft-owned) product. */
  FirstParty: "1PP",

  /** Third-party (publisher-owned) product. */
  ThirdParty: "3PP",
}

/** The commercial type of a SKU. */
union SkuType {
  string,

  /** Consumption-based SKU (pay-as-you-go). */
  Consumption: "Consumption",

  /** Subscription-based SKU. */
  Subscription: "Subscription",

  /** One-time purchase SKU. */
  OneTime: "OneTime",
}

/** Unit metadata associated with a value exchange. */
model ValueExchangeUnit {
  /** A human-readable hint describing the unit (for example, "vCPU Duration - 1 Hour"). */
  hint?: string;
}

/** Dimension metadata associated with a value exchange. */
model ValueExchangeDimensions {
  /** The Azure region dimension (for example, "westus2"). */
  region?: string;

  /** The feature dimension (for example, a product feature name). */
  feature?: string;
}

/**
 * Value-exchange (UPN identity) metadata. The value exchange is the leaf of
 * the OCP Product -> SKU -> Value Exchange hierarchy and is the transactable
 * identity addressed by this resource.
 */
model ValueExchange {
  /** The stable identifier of the value exchange. */
  valueExchangeId: string;

  /** Unit metadata for the value exchange. */
  unit?: ValueExchangeUnit;

  /** Dimension metadata for the value exchange. */
  dimensions?: ValueExchangeDimensions;
}

/**
 * Denormalized product summary embedded in a UPN. Only identifying and
 * discovery-relevant product fields are exposed here; the full product
 * document is not retrievable as a separate resource type.
 */
model ProductSummary {
  /** The stable product identifier. */
  productId: string;

  /** The human-readable friendly name of the product. */
  friendlyName?: string;

  /** The offer template identifier for this product (for example, "offer-template/az-generic"). */
  template?: string;

  /** Discovery tags associated with the product. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Product tags are free-form discovery metadata sourced from the upstream BigCat catalog; the key set is unbounded and cannot be modeled as an explicit type."
  discoveryTags?: Record<string>;

  /** Ownership classification of the product. */
  ownership?: UpnOwnership;
}

/**
 * Additional metadata about the SKU. The SKU identity itself is exposed at
 * the resource envelope as `sku.name`; this model carries denormalized
 * descriptive fields not covered by the standard ARM SKU envelope.
 */
model SkuSummary {
  /** The human-readable friendly name of the SKU. */
  friendlyName?: string;

  /** The commercial type of the SKU. */
  commercialType?: SkuType;
}

/**
 * Properties of a UPN (Unified Product Node) resource. A UPN is the
 * transactable catalog identity and carries denormalized product and SKU
 * summaries plus the value-exchange identity.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "UPN is a read-only catalog projection synthesized from the upstream BigCat feed; no ARM provisioning lifecycle applies. The resource has no create/update/delete operations and therefore no provisioning state to track."
model UpnProperties {
  /** The value-exchange identity that this UPN represents. */
  valueExchange: ValueExchange;

  /** Denormalized product summary. */
  product: ProductSummary;

  /** Additional descriptive metadata about the SKU. The SKU identity is exposed at the resource envelope as `sku.name`. */
  skuDetails?: SkuSummary;

  /** The offer-template identifier for this UPN (for example, "offer-template/az-vm"). */
  template?: string;
}
