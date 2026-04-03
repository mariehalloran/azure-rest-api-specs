import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using OpenAPI;

namespace Microsoft.ResourceNotifications;

// cspell:words DSTS Dsts

// Namespace (read-only parent)

/** Pre-existing namespace representing a registered resource provider in ARN. Read-only - partner details are derived from ServiceTree and the ARM manifest. */
@subscriptionResource
@added(Versions.v2026_03_01_preview)
model Namespace is Azure.ResourceManager.ProxyResource<NamespaceProperties> {
  /** Publisher namespace name (e.g., 'Microsoft.Compute'). */
  @key("namespaceName")
  @segment("namespaces")
  @pattern("^[A-Za-z][A-Za-z0-9]*(\\.[A-Za-z][A-Za-z0-9]*)*$")
  @path
  name: string;
}

/** Properties of the Namespace resource. All fields are read-only, populated from ServiceTree and ARM RP registration. */
@added(Versions.v2026_03_01_preview)
model NamespaceProperties {
  /** Display name of the publishing service, populated from ServiceTree. */
  @visibility(Lifecycle.Read)
  serviceName?: string;

  /** Contact e-mail for the service team, populated from ServiceTree. */
  @visibility(Lifecycle.Read)
  serviceTeamEmail?: string;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface Namespaces {
  /** Get a namespace. Returns partner details derived from ServiceTree and ARM RP registration. */
  get is ArmResourceRead<Namespace>;

  /** List namespaces in subscription. */
  list is ArmResourceListByParent<Namespace>;
}

// PublisherSettings/{settingName}

/** Publisher-facing configuration: resource types, service name linkage, and default throttling. Prerequisite: parent Namespace must exist; returns 400 NamespaceNotFound otherwise. */
@added(Versions.v2026_03_01_preview)
@parentResource(Namespace)
model PublisherSettings
  is Azure.ResourceManager.ProxyResource<PublisherSettingsProperties> {
  /** Publisher setting name. */
  @key("settingName")
  @segment("publisherSettings")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of PublisherSettings. */
@added(Versions.v2026_03_01_preview)
model PublisherSettingsProperties {
  /** Schema version (e.g., '1.0'). */
  schemaVersion?: string = "1.0";

  /** Service name linking to ProviderSettings.allowedPublishers. */
  serviceName?: string;

  /** Resource types this publisher will publish. */
  @OpenAPI.extension("x-ms-identifiers", #["resourceType"])
  publishingResourceTypes?: PublishingResourceType[];

  /** Default IcM / alerting configuration. */
  alertingInfo?: AlertingInfo;

  /** Whether this publisher setting is enabled. Set to false to disable during outages. Default: true. */
  #suppress "EnumInsteadOfBoolean" "enabled is a simple on/off operational toggle"
  enabled?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Resource type declared for publishing. */
@added(Versions.v2026_03_01_preview)
model PublishingResourceType {
  /** Fully qualified type (e.g., 'Microsoft.Compute/virtualMachines'). */
  resourceType: string;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface PublisherSettingsOperations {
  /** Get a publisher setting. */
  get is ArmResourceRead<PublisherSettings>;

  /** Create or update a publisher setting. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<PublisherSettings>;

  /** Delete a publisher setting. */
  delete is ArmResourceDeleteSync<PublisherSettings>;

  /** List publisher settings under a namespace. */
  listByParent is ArmResourceListByParent<PublisherSettings>;
}

/** Throttling policy. */
@added(Versions.v2026_03_01_preview)
model ThrottlingPolicy {
  /** Max requests/minute globally. Default: 20,000. */
  @minValue(20000)
  @maxValue(5000000)
  maxRequestsPerMinute?: int32 = 20000;

  /** Max requests/minute/region. */
  @minValue(20000)
  @maxValue(5000000)
  maxRequestsPerMinutePerRegion?: int32;

  /** Burst multiplier. Default: 1.5. */
  @minValue(1.0)
  @maxValue(5.0)
  burstAllowance?: float64 = 1.5;
}

// Polymorphic Authorization

/** Authorization kind. */
@added(Versions.v2026_03_01_preview)
union AuthorizationKind {
  string,

  /** Azure Active Directory authorization. */
  Aad: "AAD",

  /** DSTS claim-based authorization. */
  Dsts: "DSTS",
}

/** Base model for polymorphic authorization. Discriminated on 'kind'. */
@added(Versions.v2026_03_01_preview)
@discriminator("kind")
model Authorization {
  /** Discriminator: 'AAD' or 'DSTS'. */
  kind: AuthorizationKind;
}

/** AAD authorization with per-application scoping. */
@added(Versions.v2026_03_01_preview)
model AadAuthorization extends Authorization {
  kind: "AAD";

  /** Authorized AAD applications. */
  @OpenAPI.extension("x-ms-identifiers", #["applicationId"])
  @minItems(1)
  applications: AuthorizedApplication[];
}

/** An authorized AAD application. */
@added(Versions.v2026_03_01_preview)
model AuthorizedApplication {
  /** AAD application (client) ID. */
  applicationId: string;

  /** Environment scopes. Empty = all. */
  scopes?: string[];

  /** Allowed tenant IDs. Empty = all. */
  allowedTenantIds?: string[];

  /** Allowed subscription IDs. Empty = all. */
  allowedSubscriptionIds?: string[];
}

/** DSTS claim-based authorization. */
@added(Versions.v2026_03_01_preview)
model DstsAuthorization extends Authorization {
  kind: "DSTS";

  /** Required DSTS claims. */
  @OpenAPI.extension("x-ms-identifiers", #["claim"])
  @minItems(1)
  claims: DstsClaim[];
}

/** A required DSTS claim. */
@added(Versions.v2026_03_01_preview)
model DstsClaim {
  /** DSTS claim URI. */
  claim: url;
}

/** Alerting configuration for discovery pipelines. */
@added(Versions.v2026_03_01_preview)
model AlertingInfo {
  /** Alert severity level. */
  severity?: string;

  /** Alert notification email. */
  notificationEmail?: string;
}

// ProviderSettings (singleton under Namespace)

/** Type ownership governance - managed by the provider namespace (type owner). Controls validation policies and cross-publisher permissions. Prerequisite: parent Namespace must exist; returns 400 NamespaceNotFound otherwise. */
@added(Versions.v2026_03_01_preview)
@singleton
@parentResource(Namespace)
model ProviderSettings
  is Azure.ResourceManager.ProxyResource<ProviderSettingsProperties> {
  /** Singleton key. */
  @key("providerSettingsName")
  @segment("providerSettings")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of ProviderSettings. */
@added(Versions.v2026_03_01_preview)
model ProviderSettingsProperties {
  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface ProviderSettingsOperations {
  /** Get provider settings for this namespace. */
  get is ArmResourceRead<ProviderSettings>;

  /** Create or update provider settings. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<ProviderSettings>;

  /** Delete provider settings. */
  delete is ArmResourceDeleteSync<ProviderSettings>;

  /** List provider settings under a namespace. */
  listByParent is ArmResourceListByParent<ProviderSettings>;
}

// TypeSetting (child of ProviderSettings)

/** Per-type governance override. Type owner sets validationPolicy to control who can publish this type. */
@added(Versions.v2026_03_01_preview)
@parentResource(ProviderSettings)
model TypeSetting
  is Azure.ResourceManager.ProxyResource<TypeSettingProperties> {
  /** Fully qualified resource type (e.g., 'Microsoft.Compute/virtualMachines'). */
  @key("typeName")
  @segment("types")
  @pattern("^[a-zA-Z0-9.%/]{1,128}$")
  @path
  name: string;
}

/** Properties of a TypeSetting. validationPolicy is the core type-owner governance decision. */
@added(Versions.v2026_03_01_preview)
model TypeSettingProperties {
  /** Validation policy controlling who may publish this type. Set by the type owner. */
  validationPolicy: ValidationPolicy;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Validation policy determining publishing authorization for a resource type. Set by the type owner (provider namespace). */
@added(Versions.v2026_03_01_preview)
union ValidationPolicy {
  string,

  /** Standard: parent RP + explicit allowlist. ARM/ARN/ARG always allowed. */
  Default: "Default",

  /** Block parent RP from publishing. Type published exclusively by another namespace. */
  DisallowParentPublishing: "DisallowParentPublishing",

  /** Base namespace may publish extension types on its own resources. */
  BaseNamespaceSameAsPublisher: "BaseNamespaceSameAsPublisher",

  /** Publisher must own the ServiceTree entry for the resource. Strictest policy. */
  PublisherOwnsServiceTree: "PublisherOwnsServiceTree",

  /** Any publisher may publish (no validation). Use with extreme caution - system types only. */
  AllowAll: "AllowAll",
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface TypeSettings {
  /** Get a type setting. */
  get is ArmResourceRead<TypeSetting>;

  /** Create or update a type setting. Type owner sets validationPolicy here. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<TypeSetting>;

  /** Delete a type setting. */
  delete is ArmResourceDeleteSync<TypeSetting>;

  /** List all type settings under provider settings. */
  listByParent is ArmResourceListByParent<TypeSetting>;
}

// AllowedPublisher (child of TypeSetting)

/** Cross-publisher permission grant. Type owner allows another namespace to publish this type, and controls whether that publisher's data flows to ARG. */
@added(Versions.v2026_03_01_preview)
@parentResource(TypeSetting)
model AllowedPublisherResource
  is Azure.ResourceManager.ProxyResource<AllowedPublisherProperties> {
  /** Publisher namespace being granted permission (e.g., 'Microsoft.Advisor'). Use '*' for wildcard (extension types). */
  @key("publisherNamespace")
  @segment("allowedPublishers")
  @pattern("^[A-Za-z][A-Za-z0-9]*(\\.[A-Za-z][A-Za-z0-9]*)*$|^\\*$")
  @path
  name: string;
}

/** Properties of an AllowedPublisher entry. sendToArg is set by the type owner. */
@added(Versions.v2026_03_01_preview)
model AllowedPublisherProperties {
  /** Forward this publisher's events to ARG (default: true). Set by the type owner. */
  #suppress "EnumInsteadOfBoolean" "sendToArg is a simple on/off toggle; an enum adds no value"
  sendToArg?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface AllowedPublishers {
  /** Get an allowed publisher entry. */
  get is ArmResourceRead<AllowedPublisherResource>;

  /** Grant a publisher permission to publish this type. Type owner controls sendToArg. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<AllowedPublisherResource>;

  /** Revoke a publisher's permission to publish this type. */
  delete is ArmResourceDeleteSync<AllowedPublisherResource>;

  /** List all allowed publishers for this type. */
  listByParent is ArmResourceListByParent<AllowedPublisherResource>;
}

/** Flow scheduling configuration. */
@added(Versions.v2026_03_01_preview)
model FlowScheduling {
  /** Interval in hours. */
  intervalHours?: int32 = 24;
}

// ─── INGESTION UNITS ─── //

/** Per-region ingestion configuration linked to a publisher setting. */
@added(Versions.v2026_03_01_preview)
model IngestionUnit
  is Azure.ResourceManager.TrackedResource<IngestionUnitProperties> {
  /** Ingestion unit name (e.g., 'eastus-primary'). */
  @key("unitName")
  @segment("ingestionUnits")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$")
  @path
  name: string;
}

/** Properties for an ingestion unit resource. */
@added(Versions.v2026_03_01_preview)
model IngestionUnitProperties {
  /** ARM resource ID of the linked publisher setting. */
  linkedPublisherSetting: Azure.Core.armResourceIdentifier;

  /** Authorization override for this region. If omitted, inherits from publisherSettings. */
  authorization?: Authorization;

  /** Throttling policy for this ingestion unit. Required. */
  publisherUsageUnit: ThrottlingPolicy;

  /** System-provisioned receiver hostname. Derived from location. */
  @visibility(Lifecycle.Read)
  endpoint?: string;

  /** ARM resource IDs of Event Grid topics/domains routed through this unit. */
  eventGridTopicIds?: string[];

  /** Whether this ingestion unit is enabled. Set to false to disable during outages. Default: true. */
  #suppress "EnumInsteadOfBoolean" "enabled is a simple on/off operational toggle"
  enabled?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Ingestion unit operations. */
@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface IngestionUnits {
  /** Get an ingestion unit. */
  get is ArmResourceRead<IngestionUnit>;

  /** Create or update an ingestion unit. Asynchronous operation. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<IngestionUnit>;

  /** Update tags on an ingestion unit. */
  @patch(#{ implicitOptionality: true })
  update is ArmTagsPatchSync<IngestionUnit>;

  /** Delete an ingestion unit. Asynchronous operation. */
  delete is ArmResourceDeleteWithoutOkAsync<IngestionUnit>;

  /** List ingestion units in a resource group. */
  listByResourceGroup is ArmResourceListByParent<IngestionUnit>;

  /** List ingestion units in a subscription. */
  listBySubscription is ArmListBySubscription<IngestionUnit>;
}

// ─── QUERIES ─── //

/** Reusable KQL query definition stored in the resource provider. */
@subscriptionResource
@added(Versions.v2026_03_01_preview)
model Query is Azure.ResourceManager.ProxyResource<QueryProperties> {
  /** Query name. */
  @key("queryName")
  @segment("queries")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$")
  @path
  name: string;
}

/** Properties for a query resource. */
@added(Versions.v2026_03_01_preview)
model QueryProperties {
  /** KQL query text. */
  query: string;

  /** Human-readable description of this query. */
  description?: string;

  /** Whether this query is enabled. Set to false to disable during outages. Default: true. */
  #suppress "EnumInsteadOfBoolean" "enabled is a simple on/off operational toggle"
  enabled?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Query operations. */
@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface Queries {
  /** Get a query. */
  get is ArmResourceRead<Query>;

  /** Create or update a query. Modifications to existing queries use this operation. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<Query>;

  /** Delete a query. */
  delete is ArmResourceDeleteSync<Query>;

  /** List queries in a subscription. */
  list is ArmResourceListByParent<Query>;
}

// ─── FLOWS (POLYMORPHIC) ─── //

/** The kind of discovery flow. */
@added(Versions.v2026_03_01_preview)
union FlowKind {
  string,

  /** Batch ingestion via Kusto query on a schedule. */
  DiscoveryQuery: "DiscoveryQuery",

  /** Streaming ingestion from Geneva Data Service. */
  DiscoveryStreaming: "DiscoveryStreaming",

  /** Full resource synchronization via ARM LIST calls. */
  FullSync: "FullSync",
}

/** Regional discovery flow with Managed Identity support. Polymorphic by kind. */
@added(Versions.v2026_03_01_preview)
model Flow is Azure.ResourceManager.TrackedResource<FlowProperties> {
  /** Flow name. */
  @key("flowName")
  @segment("flows")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$")
  @path
  name: string;

  /** Managed identity for this flow (Kusto/GDS access). */
  ...ManagedServiceIdentityProperty;
}

/** Common properties for all flow kinds. Discriminated by kind. */
@added(Versions.v2026_03_01_preview)
@discriminator("flowKind")
model FlowProperties {
  /** The kind of discovery flow. */
  flowKind: FlowKind;

  /** ARM resource ID of the linked publisher setting. */
  linkedPublisherSettingsId: Azure.Core.armResourceIdentifier;

  /** Fully qualified resource type this flow processes (e.g., 'Microsoft.Compute/virtualMachines'). */
  fullyQualifiedResourceType: string;

  /** Whether this is a preview notification flow. */
  #suppress "EnumInsteadOfBoolean" "isPreview is a simple flag"
  isPreview?: boolean;

  /** Preview zones for this flow (e.g., ['Galaxy.InfrastructureGraph.QCS']). */
  previewZones?: string[];

  /** Whether this flow is enabled. Set to false to pause the flow during outages. Default: true. */
  #suppress "EnumInsteadOfBoolean" "enabled is a simple on/off operational toggle"
  enabled?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Properties for a DiscoveryQuery flow — batch ingestion via Kusto query on a schedule. */
@added(Versions.v2026_03_01_preview)
model DiscoveryQueryFlowProperties extends FlowProperties {
  /** Discriminator value. */
  flowKind: FlowKind.DiscoveryQuery;

  /** ARM resource ID of the linked query resource. */
  queryId: Azure.Core.armResourceIdentifier;

  /** Partner's Kusto cluster endpoint URL. */
  sourceClusterEndpoint: url;

  /** Partner's Kusto database name. */
  sourceDatabase: string;

  /** Column name for hash partitioning. Omit if no partitioning needed. */
  partitionColumn?: string;

  /** Estimated row count for auto-partition sizing (partitions = rows / 100K). */
  estimatedRowCount: int32;

  /** Scheduling configuration. Default interval: 24 hours. */
  scheduling?: FlowScheduling;

  /** Manual partition count override. Must be >= auto-calculated value. */
  partitionCountOverride?: int32;

  /** Number of parallel Kusto query batches for large datasets (>1M rows). */
  queryParallelism?: int32;

  /** Kusto export distribution strategy. */
  distributionType?: DistributionType;

  /** Credential details for Kusto cluster access. */
  credentialDetails?: CredentialDetails;

  /** System-computed receiver hostname (derived from location). */
  @visibility(Lifecycle.Read)
  endpoint?: string;

  /** System-computed partition count (estimatedRowCount / 100K). */
  @visibility(Lifecycle.Read)
  partitionCount?: int32;
}

/** Properties for a DiscoveryStreaming flow — streaming ingestion from Geneva Data Service. */
@added(Versions.v2026_03_01_preview)
model DiscoveryStreamingFlowProperties extends FlowProperties {
  /** Discriminator value. */
  flowKind: FlowKind.DiscoveryStreaming;

  /** Geneva log account name. */
  gdsAccount: string;

  /** GDS event namespaces. */
  gdsEventNamespaces: string[];

  /** GDS event names within those namespaces. */
  gdsEventNames: string[];

  /** Transformation type for the streaming data. */
  transformationType: TransformationType;
}

/** Properties for a FullSync flow — full resource synchronization via ARM LIST calls. */
@added(Versions.v2026_03_01_preview)
model FullSyncFlowProperties extends FlowProperties {
  /** Discriminator value. */
  flowKind: FlowKind.FullSync;
}

/** Kusto export distribution strategy. */
@added(Versions.v2026_03_01_preview)
union DistributionType {
  string,

  /** Single export operation. */
  single: "single",

  /** Distributed per-node export. */
  perNode: "per_node",
}

/** Transformation type for streaming ingestion. */
@added(Versions.v2026_03_01_preview)
union TransformationType {
  string,

  /** Transform data as ARM resource format. */
  ArmResource: "ArmResource",

  /** Pass-through log data without transformation. */
  PassThroughLogs: "PassThroughLogs",
}

/** Credential details for Kusto cluster access. */
@added(Versions.v2026_03_01_preview)
model CredentialDetails {
  /** User-assigned managed identity resource ID. */
  managedIdentity: string;

  /** Tenant ID for federated identity credential (FIC) mode. */
  tenantId?: string;

  /** Application ID for federated identity credential (FIC) mode. */
  applicationId?: string;
}

/** Patch model for flow updates — tags and identity only. */
@added(Versions.v2026_03_01_preview)
model FlowUpdate {
  /** Resource tags. */
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;

  /** Managed identity update. */
  ...ManagedServiceIdentityProperty;
}

/** Flow operations. */
@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface Flows {
  /** Get a flow. */
  get is ArmResourceRead<Flow>;

  /** Create or update a flow. Asynchronous operation. Use PUT to change flow properties including subtype-specific fields. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Flow>;

  /** Update tags and managed identity on a flow. */
  @patch(#{ implicitOptionality: true })
  update is ArmCustomPatchSync<Flow, FlowUpdate>;

  /** Delete a flow. Asynchronous operation. */
  delete is ArmResourceDeleteWithoutOkAsync<Flow>;

  /** List flows in a resource group. */
  listByResourceGroup is ArmResourceListByParent<Flow>;

  /** List flows in a subscription. */
  listBySubscription is ArmListBySubscription<Flow>;
}
