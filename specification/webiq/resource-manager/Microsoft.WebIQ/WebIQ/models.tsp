import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.WebIQ;

/**
 * The boost level for the allowed domain.
 */
union BoostLevel {
  string,

  /** Domain ranking is demoted. */
  Demoted: "Demoted",

  /** Default boost level. */
  Default: "Default",

  /** Domain ranking is boosted. */
  Boosted: "Boosted",

  /** Domain ranking is super boosted. */
  SuperBoost: "SuperBoost",
}

/**
 * Defines how the query terms should match the search terms entered by the user. If set to Exact (default), the pinned domain appears only if the user's search query exactly matches the specified query. If set to StartsWith, the pinned domain appears if the user's search query starts with the specified query. If set to Contains, the pinned domain appears if the user's search query contains the specified query. If set to EndsWith, the pinned domain appears if the user's search query ends with the specified query.
 */
union PinnedDomainCondition {
  string,

  /** Exact match of the query. */
  Exact: "Exact",

  /** Query starts with the specified term. */
  StartsWith: "StartsWith",

  /** Query contains the specified term. */
  Contains: "Contains",

  /** Query ends with the specified term. */
  EndsWith: "EndsWith",
}

/**
 * Gets the status of the WebIQ resource at the time the operation was called.
 */
union ProvisioningState {
  ResourceProvisioningState,
  string,

  /** The resource is being created. */
  Creating: "Creating",

  /** The resource is being updated. */
  Updating: "Updating",

  /** The resource is being moved. */
  Moving: "Moving",

  /** The resource is being deleted. */
  Deleting: "Deleting",
}

/**
 * The reason for restriction.
 */
union ResourceSkuRestrictionsReasonCode {
  string,

  /** Restricted due to quota ID. */
  QuotaId: "QuotaId",

  /** Not available for the subscription. */
  NotAvailableForSubscription: "NotAvailableForSubscription",
}

/**
 * The unit of the metric.
 */
union UnitType {
  string,

  /** Count unit. */
  Count: "Count",

  /** Bytes unit. */
  Bytes: "Bytes",

  /** Seconds unit. */
  Seconds: "Seconds",

  /** Percent unit. */
  Percent: "Percent",

  /** Count per second unit. */
  CountPerSecond: "CountPerSecond",

  /** Bytes per second unit. */
  BytesPerSecond: "BytesPerSecond",

  /** Milliseconds unit. */
  Milliseconds: "Milliseconds",
}

/**
 * WebIQ account quota usage status.
 */
union QuotaUsageStatus {
  string,

  /** Usage is included in the quota. */
  Included: "Included",

  /** Usage is blocked. */
  Blocked: "Blocked",

  /** Usage is in overage. */
  InOverage: "InOverage",

  /** Usage status is unknown. */
  Unknown: "Unknown",
}

/**
 * The type of restrictions.
 */
union ResourceSkuRestrictionsType {
  string,

  /** Location restriction. */
  Location: "Location",

  /** Zone restriction. */
  Zone: "Zone",
}

/**
 * Properties of WebIQ Custom Search Configuration.
 */
model CustomConfigurationProperties {
  /**
   * List of allowed domains for WebIQ Custom Search configuration. Total number of domains in Allowed List, Blocked List, and Pinned List combined cannot exceed 250.
   */
  @Azure.ResourceManager.identifiers(#["domain"])
  @maxItems(250)
  allowedDomains?: AllowedDomain[];

  /**
   * List of blocked domains for WebIQ Custom Search configuration. Total number of domains in Allowed List, Blocked List, and Pinned List combined cannot exceed 250.
   */
  @Azure.ResourceManager.identifiers(#["domain"])
  @maxItems(250)
  blockedDomains?: BlockedDomain[];

  /**
   * List of pinned domains for WebIQ Custom Search configuration. Total number of domains in Allowed List, Blocked List, and Pinned List combined cannot exceed 250.
   */
  @Azure.ResourceManager.identifiers(#["domain"])
  @maxItems(250)
  pinnedDomains?: PinnedDomain[];

  /**
   * Gets the status of the WebIQ Custom Search configuration at the time the operation was called.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/**
 * An allowed domain for WebIQ Custom Search configuration.
 */
model AllowedDomain {
  /**
   * A domain string that can be used to specify allowed, blocked, or pinned domains in WebIQ Custom Search configuration.
   */
  @pattern("^\\s*(((https?:\\/\\/)|(?!(.*:\\/\\/)))((-\\.)?([^\\s\\/?\\.#]+\\.)([^\\s\\/?\\.#]+\\.?)+([^\\s\\/?\\.#]+)(\\/[^\\s]*)?))\\s*$")
  domain: string;

  /**
   * A flag to indicate whether subpages of the allowed domain should be included in the search result. If set to true (default), all subpages and nested paths under the specified domain will be included in the search result. If set to false, only the main domain will be included in the search result, excluding any subpages.
   */
  includeSubPages?: boolean = true;

  /**
   * The boost level for the allowed domain.
   */
  boostLevel?: BoostLevel = BoostLevel.Default;
}

/**
 * A blocked domain for WebIQ Custom Search configuration.
 */
model BlockedDomain {
  /**
   * A domain string that can be used to specify allowed, blocked, or pinned domains in WebIQ Custom Search configuration.
   */
  @pattern("^\\s*(((https?:\\/\\/)|(?!(.*:\\/\\/)))((-\\.)?([^\\s\\/?\\.#]+\\.)([^\\s\\/?\\.#]+\\.?)+([^\\s\\/?\\.#]+)(\\/[^\\s]*)?))\\s*$")
  domain: string;

  /**
   * A flag to indicate whether subpages of the blocked domain should be excluded from search results. If set to true (default), all subpages and nested paths under the specified domain will be excluded from search results. If set to false, only the main domain will be excluded from search results.
   */
  includeSubPages?: boolean = true;
}

/**
 * A pinned domain for WebIQ Custom Search configuration.
 */
model PinnedDomain {
  /**
   * A domain string that can be used to specify allowed, blocked, or pinned domains in WebIQ Custom Search configuration.
   */
  @pattern("^\\s*(((https?:\\/\\/)|(?!(.*:\\/\\/)))((-\\.)?([^\\s\\/?\\.#]+\\.)([^\\s\\/?\\.#]+\\.?)+([^\\s\\/?\\.#]+)(\\/[^\\s]*)?))\\s*$")
  domain: string;

  /**
   * The search terms or keywords that trigger the pinned domain to appear at the top of the search results if the user's search query meets the condition specified.
   */
  query: string;

  /**
   * Defines how the query terms should match the search terms entered by the user. If set to Exact (default), the pinned domain appears only if the user's search query exactly matches the specified query. If set to StartsWith, the pinned domain appears if the user's search query starts with the specified query. If set to Contains, the pinned domain appears if the user's search query contains the specified query. If set to EndsWith, the pinned domain appears if the user's search query ends with the specified query.
   */
  condition?: PinnedDomainCondition = PinnedDomainCondition.Exact;
}

/**
 * The request body for updating an WebIQ account.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
model WebIQAccountUpdate {
  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Tags is a standard ARM property using Record<string>"
  tags?: Record<string>;

  /**
   * The SKU of WebIQ account.
   */
  sku?: Azure.ResourceManager.CommonTypes.Sku;

  /**
   * The resource-specific properties for this resource.
   */
  properties?: WebIQAccountUpdateProperties;
}

/**
 * The updatable properties of an WebIQ account.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
model WebIQAccountUpdateProperties {
  /**
   * (WebIQ Only) A flag indicating whether WebIQ Statistics is enabled.
   */
  statisticsEnabled?: boolean;
}

/**
 * Properties of WebIQ account.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
model WebIQAccountProperties {
  /**
   * Gets the status of the WebIQ account at the time the operation was called.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * Endpoint of the created account.
   */
  @visibility(Lifecycle.Read)
  endpoint?: url;

  /**
   * An internal identifier.
   */
  @visibility(Lifecycle.Read)
  internalId?: string;

  /**
   * (WebIQ Only) A flag indicating whether WebIQ Statistics is enabled.
   */
  statisticsEnabled?: boolean;
}

/**
 * The list SKUs operation response.
 */
model ResourceSkusResult is Azure.Core.Page<ResourceSku>;

/**
 * Describes an available WebIQ SKU.
 */
model ResourceSku {
  /**
   * The type of resource the SKU applies to.
   */
  @visibility(Lifecycle.Read)
  resourceType?: string;

  /**
   * The name of SKU.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Specifies the tier of WebIQ account.
   */
  @visibility(Lifecycle.Read)
  tier?: string;

  /**
   * The Kind of resources that are supported in this SKU.
   */
  @visibility(Lifecycle.Read)
  kind?: string;

  /**
   * The set of locations that the SKU is available.
   */
  @visibility(Lifecycle.Read)
  locations?: string[];

  /**
   * A list of locations and availability zones in those locations where the SKU is available.
   */
  @Azure.ResourceManager.identifiers(#["location"])
  @visibility(Lifecycle.Read)
  locationInfo?: ResourceSkuLocationInfo[];

  /**
   * The restrictions because of which SKU cannot be used. This is empty if there are no restrictions.
   */
  @Azure.ResourceManager.identifiers(#[])
  @visibility(Lifecycle.Read)
  restrictions?: ResourceSkuRestrictions[];
}

/**
 * Describes an available WebIQ SKU location info.
 */
model ResourceSkuLocationInfo {
  /**
   * Location of the SKU
   */
  @visibility(Lifecycle.Read)
  location?: string;

  /**
   * List of availability zones where the SKU is supported.
   */
  @visibility(Lifecycle.Read)
  zones?: string[];

  /**
   * Details of capabilities available to a SKU in specific zones.
   */
  @visibility(Lifecycle.Read)
  zoneDetails?: ResourceSkuZoneDetails[];
}

/**
 * Describes The zonal capabilities of a SKU.
 */
model ResourceSkuZoneDetails {
  /**
   * The set of zones that the SKU is available in with the specified capabilities.
   */
  @visibility(Lifecycle.Read)
  name?: string[];

  /**
   * A list of capabilities that are available for the SKU in the specified list of zones.
   */
  @visibility(Lifecycle.Read)
  capabilities?: SkuCapability[];
}

/**
 * SkuCapability indicates the capability of a certain feature.
 */
model SkuCapability {
  /**
   * The name of the SkuCapability.
   */
  name?: string;

  /**
   * The value of the SkuCapability.
   */
  value?: string;
}

/**
 * Describes restrictions of a SKU.
 */
model ResourceSkuRestrictions {
  /**
   * The type of restrictions.
   */
  @visibility(Lifecycle.Read)
  type?: ResourceSkuRestrictionsType;

  /**
   * The value of restrictions. If the restriction type is set to location. This would be different locations where the SKU is restricted.
   */
  @visibility(Lifecycle.Read)
  values?: string[];

  /**
   * Information about the restriction where the SKU cannot be used.
   */
  @visibility(Lifecycle.Read)
  restrictionInfo?: ResourceSkuRestrictionInfo;

  /**
   * The reason for restriction.
   */
  @visibility(Lifecycle.Read)
  reasonCode?: ResourceSkuRestrictionsReasonCode;
}

/**
 * Information about the restriction where the SKU cannot be used.
 */
model ResourceSkuRestrictionInfo {
  /**
   * Locations where the SKU is restricted
   */
  @visibility(Lifecycle.Read)
  locations?: string[];

  /**
   * List of availability zones where the SKU is restricted.
   */
  @visibility(Lifecycle.Read)
  zones?: string[];
}

/**
 * The list of WebIQ accounts operation response.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
model WebIQAccountEnumerateSkusResult is Azure.Core.Page<WebIQResourceAndSku>;

/**
 * WebIQ resource type and SKU.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
model WebIQResourceAndSku {
  /**
   * Resource Namespace and Type
   */
  resourceType?: string;

  /**
   * The SKU of WebIQ account.
   */
  sku?: Azure.ResourceManager.CommonTypes.Sku;
}

/**
 * The response to a list usage request.
 */
model UsagesResult is Azure.Core.Page<Usage>;

/**
 * The usage data for a usage request.
 */
model Usage {
  /**
   * The unit of the metric.
   */
  @visibility(Lifecycle.Read)
  unit?: UnitType;

  /**
   * The name information for the metric.
   */
  @visibility(Lifecycle.Read)
  name?: MetricName;

  /**
   * The quota period used to summarize the usage values.
   */
  @visibility(Lifecycle.Read)
  quotaPeriod?: string;

  /**
   * Maximum value for this metric.
   */
  @visibility(Lifecycle.Read)
  limit?: float64;

  /**
   * Current value for this metric.
   */
  @visibility(Lifecycle.Read)
  currentValue?: float64;

  /**
   * Next reset time for current quota.
   */
  @visibility(Lifecycle.Read)
  nextResetTime?: utcDateTime;

  /**
   * WebIQ account quota usage status.
   */
  status?: QuotaUsageStatus;
}

/**
 * A metric name.
 */
model MetricName {
  /**
   * The name of the metric.
   */
  @visibility(Lifecycle.Read)
  value?: string;

  /**
   * The friendly name of the metric.
   */
  @visibility(Lifecycle.Read)
  localizedValue?: string;
}

/**
 * The SKUs to check for availability in the specified subscription and location
 */
model CheckSkuAvailabilityParameter {
  /**
   * The SKU of the resource.
   */
  skus: string[];

  /**
   * Indicates the type of WebIQ account.
   */
  kind: string;

  /**
   * The Type of the resource.
   */
  resourceType: string;
}

/**
 * Check SKU availability result list.
 */
model CheckSkuAvailabilityResultList {
  /**
   * Check SKU availability result list.
   */
  @Azure.ResourceManager.identifiers(#["kind", "skuName"])
  value: CheckSkuAvailabilityResult[];
}

/**
 * Check SKU availability result.
 */
model CheckSkuAvailabilityResult {
  /**
   * Indicates the type of WebIQ account.
   */
  kind?: string;

  /**
   * The Type of the resource.
   */
  resourceType?: string;

  /**
   * The name of SKU.
   */
  skuName?: string;

  /**
   * Indicates the given SKU is available or not.
   */
  skuAvailable?: boolean;

  /**
   * Reason why the SKU is not available.
   */
  reason?: string;

  /**
   * Additional error message.
   */
  message?: string;
}

/**
 * The list of WebIQ accounts.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
model WebIQAccountListResult is Azure.Core.Page<WebIQAccount>;
@@visibility(WebIQAccountListResult.value, Lifecycle.Read);

/**
 * The list of WebIQ Custom Search configurations.
 */
model CustomSearchConfigurationListResult
  is Azure.Core.Page<CustomSearchConfiguration>;
@@visibility(CustomSearchConfigurationListResult.value, Lifecycle.Read);
