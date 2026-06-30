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

/** Request body for looking up a product by its identifier and version. */
@added(Versions.v2026_06_30_preview)
model LookupProductRequest {
  /** Unique identifier for a product in the commerce catalog. */
  @maxLength(64)
  productId: string;

  /** Integer version of the product document. */
  version: int32;
}

/** Flat properties of a product, matching the `products` stream. */
@added(Versions.v2026_06_30_preview)
model ProductProperties {
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
  productPolicies?: PcdPropertyBag;

  /** Alternate identifiers for cross-referencing this product across systems. */
  alternateIds?: string[];

  /** Market-specific properties (pricing, availability per market) at the product level. */
  marketProperties?: PcdPropertyBag;

  /** Localized display properties (title, description) in multiple languages at the product level. */
  localizedProperties?: PcdPropertyBag;

  /** Whole `Product.Properties` envelope captured verbatim as a loss-free fallback. */
  properties?: PcdPropertyBag;

  /** Display name of the product, promoted from localized properties. */
  @maxLength(256)
  displayName?: string;

  /** Human-readable description of the product. */
  @maxLength(2048)
  description?: string;

  /** The default language code for this product's localized content. */
  @maxLength(16)
  defaultLanguageCode?: string;

  /** Name of the publisher, promoted from localized properties. */
  @maxLength(256)
  publisherName?: string;

  /** Dynamic struct containing low-traffic provenance and internal routing fields. */
  diagnosticsInformation?: PcdPropertyBag;
}

/** The result of a product lookup. */
@added(Versions.v2026_06_30_preview)
model LookupProductResult {
  /** The product identifier the result corresponds to. */
  @maxLength(64)
  productId: string;

  /** The product version the result corresponds to. */
  version: int32;

  /** The flat product projection. */
  properties: ProductProperties;
}

/** Read-only catalog lookup actions for products. */
@added(Versions.v2026_06_30_preview)
@armResourceOperations
interface Products {
  /**
   * Look up a single product by its identifier and version. The catalog is
   * globally keyed: the same `(productId, version)` returns the same response
   * for all callers under one API version. Modeled as a POST action because
   * the response is identical for every caller in a subscription and the
   * catalog is not a per-subscription resource collection.
   */
  @autoRoute
  @action("lookupProduct")
  lookup is ArmProviderActionSync<
    Request = LookupProductRequest,
    Response = LookupProductResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}
