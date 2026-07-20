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

/** Flat properties of a SKU, matching the `skus` stream. */
@added(Versions.v2026_06_30_preview)
model SkuProperties {
  /** Foreign key linking this SKU to its parent product. */
  @maxLength(64)
  productId: string;

  /** Product version propagated from the parent product document. */
  version: int32;

  /** Classification of the SKU type within the commerce platform. */
  @maxLength(64)
  skuType?: string;

  /** Describes how the SKU is fulfilled (for example, license key, SaaS provisioning, physical delivery). */
  @maxLength(64)
  fulfillmentType?: string;

  /** Indicates whether this SKU represents a trial/evaluation offering. */
  isTrial?: boolean;

  /** Indicates whether this SKU is available for pre-order before general availability. */
  isPreOrder?: boolean;

  /** Indicates whether this SKU is a bundle composed of multiple child SKUs. */
  isBundle?: boolean;

  /** Billing-recurrence object for the SKU. */
  recurrencePolicy?: PcdPropertyBag;

  /** Minimum quantity that can be ordered for this SKU in a single transaction. */
  minOrderQuantity?: int32;

  /** Maximum quantity that can be ordered for this SKU in a single transaction. */
  maxOrderQuantity?: int32;

  /** Fulfillment-specific data including provisioning URIs and delivery instructions. */
  fulfillmentData?: PcdPropertyBag;

  /** Order management data at the SKU level. */
  orderManagementData?: PcdPropertyBag;

  /** Cross-PCD benefit join key (FCP = SKU UPN, P3 = ProductId). */
  @maxLength(64)
  benefitGroupId?: string;

  /** SKU-level Financial Product Model discriminator. */
  @maxLength(64)
  offerType?: string;

  /** Location scope for region-scoped benefit grants (ASP / autofit). */
  @maxLength(128)
  location?: string;

  /** ARM region name for region-scoped benefit grants. */
  @maxLength(128)
  armRegionName?: string;

  /** SKU-level attributes / autofit reservation key-value data. */
  attributes?: PcdPropertyBag;

  /** P3 financial-product classification. */
  @maxLength(64)
  classification?: string;

  /** P3 financial-product sub-classification. */
  @maxLength(64)
  subClassification?: string;

  /** Legacy reservation marker (RI/P3) carrying `salesMotionType`. */
  benefitsRpData?: PcdPropertyBag;

  /** Region scoping predicate. */
  @maxLength(128)
  region?: string;

  /** Cloud scoping predicate. */
  @maxLength(64)
  cloud?: string;

  /** ARM SKU name join key. */
  @maxLength(128)
  armSkuName?: string;

  /** Resource identifier join key. */
  @maxLength(256)
  resourceId?: string;

  /** Meter identifier array used for meter/resource joins. */
  meterIds?: string[];

  /** SKU display name predicate. */
  @maxLength(256)
  skuName?: string;

  /** Benefits associated with this SKU (for example, entitlements, feature access). */
  benefits?: PcdPropertyBag;

  /** Constraint rules governing SKU eligibility and purchasing restrictions. */
  constraintsData?: PcdPropertyBag;

  /** Market-specific properties at the SKU level (availability, pricing overrides per market). */
  marketProperties?: PcdPropertyBag;

  /** Localized display properties at the SKU level in multiple languages. */
  localizedProperties?: PcdPropertyBag;

  /** FCP/P3 benefit policy bag. */
  benefitPolicy?: PcdPropertyBag;

  /** P3 single committed-unit meter data. */
  meterData?: PcdPropertyBag;

  /** Legacy P3 reservation block retained for round-trip under the new model. */
  reservationOfferConfiguration?: PcdPropertyBag;

  /** Whole `Sku.Properties` envelope captured verbatim as a loss-free fallback. */
  propertiesEnvelope?: PcdPropertyBag;

  /** Display title of the SKU, promoted from localized properties. */
  @maxLength(256)
  skuTitle?: string;

  /** Human-readable description of the SKU. */
  @maxLength(2048)
  description?: string;

  /** Default language code for the SKU's localized content. */
  @maxLength(16)
  language?: string;

  /** Dynamic struct containing provenance and internal routing fields. */
  diagnosticsInformation?: PcdPropertyBag;

  /** The provisioning state of the catalog resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

/** The name of the SKU (its catalog identifier within the product). */
@added(Versions.v2026_06_30_preview)
@subscriptionResource
model SkuNameParameter is ResourceNameParameter<
  Resource = CatalogSku,
  KeyName = "skuId",
  SegmentName = "skus",
  NamePattern = "^[a-zA-Z0-9._-]{1,64}$"
>;

/** A SKU in the commerce catalog. */
@added(Versions.v2026_06_30_preview)
model CatalogSku is Azure.ResourceManager.ProxyResource<SkuProperties, false> {
  ...SkuNameParameter;
}

/** Read-only catalog access for SKUs. */
@added(Versions.v2026_06_30_preview)
@armResourceOperations
interface Skus {
  /**
   * Get a single SKU by its identifier. The catalog is globally keyed: the same
   * `skuId` returns the same response for all callers under one API version.
   */
  get is ArmResourceRead<
    CatalogSku,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * List all SKUs in the catalog available to the subscription. The catalog is
   * globally keyed, so the same set is returned for all callers under one API
   * version.
   */
  listBySubscription is ArmResourceListByParent<
    CatalogSku,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}
