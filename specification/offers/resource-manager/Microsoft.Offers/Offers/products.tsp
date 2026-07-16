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

/** Flat properties of a product, matching the `products` stream. */
@added(Versions.v2026_06_30_preview)
model ProductProperties {
  /** Integer version of the product document. */
  version: int32;

  /** The family or category grouping to which this product belongs (for example, Azure, Microsoft 365). */
  @maxLength(128)
  productFamily?: string;

  /** Classifies the product type within the commerce platform (for example, Platform, SaaS, DevTool). */
  @maxLength(64)
  productType?: string;

  /** The line of business under which this product falls. Defaults to `Azure` when not explicitly set. */
  @maxLength(64)
  lineOfBusiness?: string;

  /** Primary selling motion / ownership model for the product. */
  @maxLength(128)
  ownershipSellingMotion?: string;

  /** Service family grouping used for reporting and categorization (for example, Compute, Storage, Networking). */
  @maxLength(128)
  serviceFamilyName?: string;

  /** The specific Azure/commerce service this product belongs to. */
  @maxLength(128)
  serviceName?: string;

  /** Indicates whether this is a first-party Microsoft product (true) or a third-party/ISV product (false). */
  isMicrosoftProduct?: boolean;

  /** Indicates whether this product is designated as a test product and excluded from production reporting. */
  isTestProduct?: boolean;

  /** Identifier of the seller or publisher offering this product in the marketplace. */
  @maxLength(64)
  sellerId?: string;

  /** Financial Product Model (FCP/P3) program discriminator. */
  @maxLength(64)
  offerType?: string;

  /** Eligibility rules and constraints at the product level. */
  eligibility?: PcdPropertyBag;

  /** Consumption model information for the product, including meter and term definitions. */
  consumption?: PcdPropertyBag;

  /** Pricing model and configuration data at the product level. */
  pricing?: PcdPropertyBag;

  /** Product-level policies governing purchasing, renewal, and lifecycle behavior. */
  policies?: PcdPropertyBag;

  /** Alternate identifiers for cross-referencing this product across systems. */
  alternateIds?: string[];

  /** Market-specific properties (pricing, availability per market) at the product level. */
  marketProperties?: PcdPropertyBag;

  /** Localized display properties (title, description) in multiple languages at the product level. */
  localizedProperties?: PcdPropertyBag;

  /** Whole `Product.Properties` envelope captured verbatim as a loss-free fallback. */
  propertiesEnvelope?: PcdPropertyBag;

  /** Display name of the product, promoted from localized properties. */
  @maxLength(256)
  displayName?: string;

  /** Human-readable description of the product. */
  @maxLength(2048)
  description?: string;

  /** Name of the publisher, promoted from localized properties. */
  @maxLength(256)
  publisherName?: string;

  /** Dynamic struct containing low-traffic provenance and internal routing fields. */
  diagnosticsInformation?: PcdPropertyBag;

  /** The provisioning state of the catalog resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

/** The name of the product (its catalog identifier). */
@added(Versions.v2026_06_30_preview)
@subscriptionResource
model ProductNameParameter is ResourceNameParameter<
  Resource = CatalogProduct,
  KeyName = "productId",
  SegmentName = "products",
  NamePattern = "^[a-zA-Z0-9._-]{1,64}$"
>;

/** A product in the commerce catalog. */
@added(Versions.v2026_06_30_preview)
model CatalogProduct is Azure.ResourceManager.ProxyResource<
  ProductProperties,
  false
> {
  ...ProductNameParameter;
}

/** Read-only catalog access for products. */
@added(Versions.v2026_06_30_preview)
@armResourceOperations
interface Products {
  /**
   * Get a single product by its identifier. The catalog is globally keyed: the
   * same `productId` returns the same response for all callers under one API
   * version.
   */
  get is ArmResourceRead<
    CatalogProduct,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * List all products in the catalog available to the subscription. The catalog
   * is globally keyed, so the same set is returned for all callers under one API
   * version.
   */
  listBySubscription is ArmResourceListByParent<
    CatalogProduct,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}
