import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.ResourceNotifications;

// cspell:words DSTS Dsts

/** Request-rate limits overriding the defaults supplied by an ingestion unit SKU. */
@added(Versions.v2026_08_01_preview)
model CapacityOverrides {
  /** Maximum requests in a rolling 60-second window. */
  @minValue(1)
  maxRequestsPerMinute?: int32;

  /** Maximum requests in a rolling one-second window. */
  @minValue(1)
  maxRequestsPerSecond?: int32;
}

// ─── SKU ─── //

/** SKU name for an ingestion unit. Determines capacity tier and workload type (push or flow). */
@added(Versions.v2026_08_01_preview)
union IngestionUnitSkuName {
  string,

  /** Standard push tier: production HTTP push ingestion capacity. */
  Standard: "Standard",

  /** Premium push tier: high-throughput HTTP push ingestion capacity. */
  Premium: "Premium",

  /** Dedicated push tier: high-volume HTTP push ingestion capacity. */
  Dedicated: "Dedicated",

  /** Standard flow tier: production discovery pipeline capacity. */
  Standard_Flow: "Standard_Flow",

  /** Premium flow tier: high-throughput discovery pipeline capacity. */
  Premium_Flow: "Premium_Flow",

  /** Dedicated flow tier: high-volume discovery pipeline capacity. */
  Dedicated_Flow: "Dedicated_Flow",
}

/** ARN-owned capacity profile assigned to a regional ingestion unit. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitSku {
  /** Capacity profile selecting the workload type and default request-rate limits. */
  name: IngestionUnitSkuName;

  /** Number of capacity units assigned to this ingestion unit. */
  @minValue(1)
  capacity?: int32 = 1;
}

// Polymorphic Authorization

/** Authentication mechanism accepted by an ingestion unit. */
@added(Versions.v2026_08_01_preview)
union AuthenticationType {
  string,

  /** Microsoft Entra application authentication. */
  Aad: "AAD",

  /** DSTS claim authentication. */
  Dsts: "DSTS",
}

/** Base model for an ingestion unit authentication configuration. */
@added(Versions.v2026_08_01_preview)
@discriminator("authenticationType")
model IngestionUnitAuthorization {
  /** Authentication mechanism represented by this entry. */
  authenticationType: AuthenticationType;
}

/** Microsoft Entra application authentication configuration. */
@added(Versions.v2026_08_01_preview)
model AadIngestionUnitAuthorization extends IngestionUnitAuthorization {
  authenticationType: "AAD";

  /** Applications permitted to publish through this ingestion unit. */
  @identifiers(#["applicationId"])
  @minItems(1)
  applications: AuthorizedApplication[];
}

/** A Microsoft Entra application permitted to publish through an ingestion unit. */
@added(Versions.v2026_08_01_preview)
model AuthorizedApplication {
  /** Microsoft Entra application ID. */
  applicationId: string;

  /** Notification scopes permitted for this application. */
  @minItems(1)
  scopes: string[];

  /** Allowed resource-home tenant IDs. Empty or omitted permits all tenants. */
  allowedTenantIds?: string[];

  /** Allowed subscription IDs. Empty or omitted permits all subscriptions. */
  allowedSubscriptionIds?: string[];
}

/** DSTS claim authentication configuration. */
@added(Versions.v2026_08_01_preview)
model DstsIngestionUnitAuthorization extends IngestionUnitAuthorization {
  authenticationType: "DSTS";

  /** DSTS claims permitted to publish through this ingestion unit. */
  @identifiers(#["claim"])
  @minItems(1)
  claims: DstsClaimAuthorization[];
}

/** A publisher-defined DSTS claim permitted to publish through an ingestion unit. */
@added(Versions.v2026_08_01_preview)
model DstsClaimAuthorization {
  /** Case-sensitive DSTS claim moniker. */
  @minLength(1)
  claim: string;
}

// ─── INGESTION UNITS ─── //

/** Regional ingestion capacity for a publisher registered with Microsoft.ProviderHub. */
@added(Versions.v2026_08_01_preview)
@parentResource(ArmLocationResource<"Extension">)
model IngestionUnit
  is Azure.ResourceManager.ProxyResource<IngestionUnitProperties, false> {
  /** Ingestion unit name. */
  @key("ingestionUnitName")
  @segment("ingestionUnits")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$")
  @path
  name: string;
}

/** Properties for an ingestion unit resource. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitProperties {
  /** Capacity profile assigned to this ingestion unit. */
  sku: IngestionUnitSku;

  /** Request-rate limits overriding the defaults supplied by the SKU. */
  capacityOverrides?: CapacityOverrides;

  /** Authentication mechanisms permitted to publish through this ingestion unit. */
  @identifiers(#["authenticationType"])
  @minItems(1)
  authorizations: IngestionUnitAuthorization[];

  /** System-provisioned receiver hostname. */
  @visibility(Lifecycle.Read)
  endpoint?: string;

  /** ARM resource IDs of Event Grid topics/domains routed through this unit. */
  eventGridTopicIds?: Azure.Core.armResourceIdentifier[];

  /** Whether this ingestion unit is enabled. Set to false to disable during outages. Default: true. */
  #suppress "EnumInsteadOfBoolean" "enabled is a simple on/off operational toggle"
  enabled?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Capacity profile fields supported by an ingestion unit PATCH request. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitSkuUpdate {
  /** Updated capacity profile. */
  name?: IngestionUnitSkuName;

  /** Updated number of capacity units. */
  @minValue(1)
  capacity?: int32;
}

/** Capacity override fields supported by an ingestion unit PATCH request. */
@added(Versions.v2026_08_01_preview)
model CapacityOverridesPatch {
  /** Updated minute limit. */
  @minValue(1)
  maxRequestsPerMinute?: int32;

  /** Updated one-second limit. */
  @minValue(1)
  maxRequestsPerSecond?: int32;
}

/** Ingestion unit properties supported by a PATCH request. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitPatchProperties {
  /** Updated capacity profile. */
  sku?: IngestionUnitSkuUpdate;

  /** Updated request-rate overrides. */
  capacityOverrides?: CapacityOverridesPatch;

  /** Complete replacement authentication collection. */
  @identifiers(#["authenticationType"])
  @minItems(1)
  authorizations?: IngestionUnitAuthorization[];

  /** Updated Event Grid topics routed through this ingestion unit. */
  eventGridTopicIds?: Azure.Core.armResourceIdentifier[];

  /** Updated enabled state. */
  enabled?: boolean;
}

/** Ingestion unit PATCH request. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitPatch {
  /** Properties to update. */
  properties?: IngestionUnitPatchProperties;
}

/** Ingestion unit operations. */
@added(Versions.v2026_08_01_preview)
@armResourceOperations
interface IngestionUnits {
  /** Get an ingestion unit. */
  get is ArmResourceRead<IngestionUnit>;

  /** Create or update an ingestion unit. Asynchronous operation. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<IngestionUnit>;

  /** Update an ingestion unit. Asynchronous operation. */
  update is ArmCustomPatchAsync<
    IngestionUnit,
    IngestionUnitPatch,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, IngestionUnit> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /** Delete an ingestion unit. Asynchronous operation. */
  delete is ArmResourceDeleteWithoutOkAsync<
    IngestionUnit,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, IngestionUnit> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /** List ingestion units in a location. */
  listByLocation is ArmResourceListByParent<IngestionUnit>;
}

// ─── FLOWS ─── //

/** Inline KQL query definition embedded in a discovery query flow. */
@added(Versions.v2026_08_01_preview)
model QueryDefinition {
  /** KQL query text. */
  query: string;

  /** Human-readable description of this query. */
  description?: string;
}

/** Scheduling configuration for a discovery query flow. */
@added(Versions.v2026_08_01_preview)
model FlowScheduling {
  /** Interval in hours. */
  intervalHours?: int32 = 24;
}

/** The kind of discovery flow. */
@added(Versions.v2026_08_01_preview)
union FlowKind {
  string,

  /** Batch ingestion via Kusto query on a schedule. */
  DiscoveryQuery: "DiscoveryQuery",

  /** Streaming ingestion from Geneva Data Service. */
  DiscoveryStreaming: "DiscoveryStreaming",

  /** Full resource synchronization via Azure Resource Manager LIST calls. */
  FullSync: "FullSync",
}

/** Regional discovery flow using capacity from a linked ingestion unit. */
@added(Versions.v2026_08_01_preview)
model Flow is Azure.ResourceManager.TrackedResource<FlowProperties> {
  /** Flow name. */
  @key("flowName")
  @segment("flows")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$")
  @path
  name: string;
}

/** Common properties for all discovery flow kinds. */
@added(Versions.v2026_08_01_preview)
@discriminator("flowKind")
model FlowProperties {
  /** The kind of discovery flow. */
  flowKind: FlowKind;

  /** ARM resource ID of the user-assigned managed identity used to authenticate to the partner data source. */
  managedIdentityResourceId?: Azure.Core.armResourceIdentifier;

  /** ARM resource ID of the flow-tier ingestion unit supplying capacity. The ingestion unit must exist, be enabled, and have the same location as this flow. */
  ingestionUnitId: Azure.Core.armResourceIdentifier;

  /** Fully qualified resource type processed by this flow. */
  fullyQualifiedResourceType: string;

  /** Whether this is a preview notification flow. */
  #suppress "EnumInsteadOfBoolean" "isPreview is a simple flag"
  isPreview?: boolean;

  /** Preview zones for this flow. */
  previewZones?: string[];

  /** Whether this flow is enabled. Set to false to pause the flow during outages. */
  #suppress "EnumInsteadOfBoolean" "enabled is a simple on/off operational toggle"
  enabled?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Properties for a discovery query flow. */
@added(Versions.v2026_08_01_preview)
model DiscoveryQueryFlowProperties extends FlowProperties {
  flowKind: FlowKind.DiscoveryQuery;

  /** Inline KQL query definition for this flow. */
  queryDefinition: QueryDefinition;

  /** Partner Kusto cluster endpoint URL. */
  sourceClusterEndpoint: url;

  /** Partner Kusto database name. */
  sourceDatabase: string;

  /** Column name for hash partitioning. */
  partitionColumn?: string;

  /** Estimated row count used for automatic partition sizing. */
  estimatedRowCount: int32;

  /** Scheduling configuration. */
  scheduling?: FlowScheduling;

  /** Manual partition count override. */
  partitionCountOverride?: int32;

  /** Number of parallel Kusto query batches. */
  queryParallelism?: int32;

  /** Kusto export distribution strategy. */
  distributionType?: DistributionType;

  /** System-computed partition count. */
  @visibility(Lifecycle.Read)
  partitionCount?: int32;
}

/** Properties for a discovery streaming flow. */
@added(Versions.v2026_08_01_preview)
model DiscoveryStreamingFlowProperties extends FlowProperties {
  flowKind: FlowKind.DiscoveryStreaming;

  /** Geneva log account name. */
  gdsAccount: string;

  /** Geneva Data Service event namespaces. */
  gdsEventNamespaces: string[];

  /** Geneva Data Service event names. */
  gdsEventNames: string[];

  /** Transformation applied to streaming data. */
  transformationType: TransformationType;
}

/** Properties for a full synchronization flow. */
@added(Versions.v2026_08_01_preview)
model FullSyncFlowProperties extends FlowProperties {
  flowKind: FlowKind.FullSync;
}

/** Kusto export distribution strategy. */
@added(Versions.v2026_08_01_preview)
union DistributionType {
  string,

  /** Single export operation. */
  single: "single",

  /** Distributed per-node export. */
  perNode: "per_node",
}

/** Transformation applied to streaming data. */
@added(Versions.v2026_08_01_preview)
union TransformationType {
  string,

  /** Transform data into Azure Resource Manager resource format. */
  ArmResource: "ArmResource",

  /** Pass through log data without transformation. */
  PassThroughLogs: "PassThroughLogs",
}

/** Flow PATCH request. */
@added(Versions.v2026_08_01_preview)
model FlowUpdate {
  /** Resource tags. */
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;
}

/** Flow operations. */
@added(Versions.v2026_08_01_preview)
@armResourceOperations
interface Flows {
  /** Get a flow. */
  get is ArmResourceRead<Flow>;

  /** Create or update a flow. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Flow>;

  /** Update flow tags. */
  @patch(#{ implicitOptionality: true })
  update is ArmCustomPatchSync<Flow, FlowUpdate>;

  /** Delete a flow. */
  delete is ArmResourceDeleteWithoutOkAsync<Flow>;

  /** List flows in a resource group. */
  listByResourceGroup is ArmResourceListByParent<Flow>;

  /** List flows in a subscription. */
  listBySubscription is ArmListBySubscription<Flow>;
}
