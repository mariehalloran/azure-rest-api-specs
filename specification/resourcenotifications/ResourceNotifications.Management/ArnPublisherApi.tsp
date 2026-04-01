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
@added(Versions.v2026_03_01_preview)
model Namespace is Azure.ResourceManager.TrackedResource<NamespaceProperties> {
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

  listByResourceGroup is ArmResourceListByParent<Namespace>;
  listBySubscription is ArmListBySubscription<Namespace>;
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

  /** Default throttling policy for all ingestion paths. Can be overridden per-path (e.g., on Endpoint). */
  throttlingPolicy?: ThrottlingPolicy;

  /** Default IcM / alerting configuration. Can be overridden by child resources (e.g., DiscoveryConfig). */
  alertingInfo?: AlertingInfo;

  /** Safe deployment configuration for gradual or immediate regional rollout. */
  deploymentConfig?: DeploymentConfig;

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

  /** Create or update a publisher setting. Publisher onboarding is a long-running process. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<PublisherSettings>;

  /** Delete a publisher setting. */
  delete is ArmResourceDeleteWithoutOkAsync<PublisherSettings>;

  /** List publisher settings under a namespace. */
  listByParent is ArmResourceListByParent<PublisherSettings>;
}

// Endpoint (singleton under PublisherSettings)

/** HTTP endpoint ingestion configuration with polymorphic authorization. Throttling here overrides the publisher-level default from PublisherSettings. */
@added(Versions.v2026_03_01_preview)
@singleton
@parentResource(PublisherSettings)
model Endpoint
  is Azure.ResourceManager.ProxyResource<EndpointProperties> {
  /** Singleton key. */
  @key("endpointName")
  @segment("endpoints")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of Endpoint. */
@added(Versions.v2026_03_01_preview)
model EndpointProperties {
  /** Receiver endpoint URLs provisioned by the system, keyed by scope (e.g., 'global', 'eu'). Read-only. */
  @visibility(Lifecycle.Read)
  endpoints?: EndpointUrls;

  /** Throttling policy override for this ingestion path. If omitted, inherits from PublisherSettings.throttlingPolicy. Default: 20,000 req/min, 1.5x burst. */
  throttlingPolicy?: ThrottlingPolicy;

  /** Polymorphic authorization (AAD or DSTS). */
  authorization?: Authorization;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Receiver endpoint URLs keyed by scope. */
@added(Versions.v2026_03_01_preview)
model EndpointUrls {
  /** Global receiver endpoint URL. */
  global?: url;

  /** EU-scoped receiver endpoint URL. */
  eu?: url;
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

/** A single stage in a deployment rollout, mapping a stage name to its target Azure regions. */
@added(Versions.v2026_03_01_preview)
model StageDefinition {
  /** Name of the deployment stage (e.g. "canary", "stage1", "remaining"). */
  name: string;

  /** Azure regions assigned to this stage. Use "*" to match all remaining regions. */
  regions: string[];
}

/** Safe deployment configuration for gradual regional rollout of publisher settings. */
@added(Versions.v2026_03_01_preview)
model DeploymentConfig {
  /** Ordered stage definitions for gradual regional rollout.
   * Each entry maps a stage name to its target Azure regions. Array order defines rollout sequence. */
  stageDefinition?: StageDefinition[];

  /** Whether managed SDP is enabled for this publisher's config rollout. */
  managedSdpEnabled?: boolean;

  /** Wait duration between stages (ISO 8601 duration). Default: PT24H. */
  waitDuration?: duration;
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

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface Endpoints {
  /** Get the HTTP endpoint configuration. */
  get is ArmResourceRead<Endpoint>;

  /** Create or update the HTTP endpoint configuration. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<Endpoint>;

  /** Delete the HTTP endpoint configuration. */
  delete is ArmResourceDeleteSync<Endpoint>;

  /** List HTTP endpoint configurations under a publisher setting. */
  listByParent is ArmResourceListByParent<Endpoint>;
}

// EventGridConfig (LEGACY - singleton under PublisherSettings)

/** LEGACY: Event Grid topic-based ingestion for existing publishers. New publishers must use Endpoint instead. */
@added(Versions.v2026_03_01_preview)
@singleton
@parentResource(PublisherSettings)
model EventGridConfig
  is Azure.ResourceManager.ProxyResource<EventGridConfigProperties> {
  /** Singleton key. */
  @key("eventGridConfigName")
  @segment("eventGridConfigs")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of EventGridConfig. */
@added(Versions.v2026_03_01_preview)
model EventGridConfigProperties {
  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface EventGridConfigs {
  /** Get the legacy Event Grid configuration. */
  get is ArmResourceRead<EventGridConfig>;

  /** Create or update the legacy Event Grid configuration. New publishers should use Endpoint instead. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<EventGridConfig>;

  /** Delete the legacy Event Grid configuration. */
  delete is ArmResourceDeleteSync<EventGridConfig>;

  /** List Event Grid configurations under a publisher setting. */
  listByParent is ArmResourceListByParent<EventGridConfig>;
}

// TopicConfigs (child of EventGridConfig)

/** LEGACY: Individual Event Grid topic reference. Only topicResourceId is publisher-provided. */
@added(Versions.v2026_03_01_preview)
@parentResource(EventGridConfig)
model TopicConfig
  is Azure.ResourceManager.ProxyResource<TopicConfigProperties> {
  /** System-generated GUID identifying this topic configuration. */
  @key("topicConfigId")
  @segment("topicConfigs")
  @pattern("^[a-fA-F0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of TopicConfig. Minimal publisher surface - only the EG topic resource ID. */
@added(Versions.v2026_03_01_preview)
model TopicConfigProperties {
  /** ARM resource ID of the publisher-owned Event Grid topic. */
  topicResourceId: string;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface TopicConfigs {
  get is ArmResourceRead<TopicConfig>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<TopicConfig>;
  delete is ArmResourceDeleteSync<TopicConfig>;
  listByParent is ArmResourceListByParent<TopicConfig>;
}

// DiscoveryConfig (singleton under PublisherSettings)

/** Global Discovery defaults (ADF stamp, endpoints, alerting). */
@added(Versions.v2026_03_01_preview)
@singleton
@parentResource(PublisherSettings)
model DiscoveryConfig
  is Azure.ResourceManager.ProxyResource<DiscoveryConfigProperties> {
  /** Singleton key. */
  @key("discoveryConfigName")
  @segment("discoveryConfigs")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of DiscoveryConfig. */
@added(Versions.v2026_03_01_preview)
model DiscoveryConfigProperties {
  /** Default ADF stamp for discovery pipelines. */
  adfStamp?: string;

  /** Default alerting configuration. */
  alertingInfo?: AlertingInfo;

  /** Default data mapping configuration. */
  defaultMapping?: string;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Alerting configuration for discovery pipelines. */
@added(Versions.v2026_03_01_preview)
model AlertingInfo {
  /** Alert severity level. */
  severity?: string;

  /** Alert notification email. */
  notificationEmail?: string;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface DiscoveryConfigs {
  get is ArmResourceRead<DiscoveryConfig>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<DiscoveryConfig>;
  delete is ArmResourceDeleteSync<DiscoveryConfig>;

  /** List discovery configurations under a publisher setting. */
  listByParent is ArmResourceListByParent<DiscoveryConfig>;
}

// KustoQueries (child of DiscoveryConfig)

/** Reusable Kusto query definition. */
@added(Versions.v2026_03_01_preview)
@parentResource(DiscoveryConfig)
model KustoQuery is Azure.ResourceManager.ProxyResource<KustoQueryProperties> {
  /** Query name. */
  @key("queryName")
  @segment("kustoQueries")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of a KustoQuery. */
@added(Versions.v2026_03_01_preview)
model KustoQueryProperties {
  /** KQL query text. */
  query: string;

  /** Description of what this query returns. */
  description?: string;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface KustoQueries {
  get is ArmResourceRead<KustoQuery>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<KustoQuery>;
  delete is ArmResourceDeleteSync<KustoQuery>;
  listByParent is ArmResourceListByParent<KustoQuery>;
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

/** Properties of ProviderSettings. ARG metadata (logicalTable) is system-resolved and read-only. */
@added(Versions.v2026_03_01_preview)
model ProviderSettingsProperties {
  /** ARG logical table for this provider's types. Read-only - resolved from ARG dataset configuration at runtime. */
  @visibility(Lifecycle.Read)
  logicalTable?: string;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface ProviderSettingsOperations {
  /** Get provider settings for this namespace. */
  get is ArmResourceRead<ProviderSettings>;

  /** Create or update provider settings. logicalTable is system-resolved. */
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

  /** ARG logical table override for this type. Read-only - resolved from ARG dataset configuration. */
  @visibility(Lifecycle.Read)
  logicalTable?: string;

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

// DiscoveryPipeline (top-level, subscription-scoped, regional)

/** Regional batch ingestion pipeline with Managed Identity support. */
@added(Versions.v2026_03_01_preview)
model DiscoveryPipeline
  is Azure.ResourceManager.TrackedResource<DiscoveryPipelineProperties> {
  /** Pipeline name (e.g., 'compute-batch-eastus'). */
  @key("pipelineName")
  @segment("discoveryPipelines")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;

  ...ManagedServiceIdentityProperty;
}

/** Properties of a DiscoveryPipeline. */
@added(Versions.v2026_03_01_preview)
model DiscoveryPipelineProperties {
  /** ARM resource ID of the linked PublisherSettings. */
  linkedPublisherSettingsId: Azure.Core.armResourceIdentifier;

  /** Kusto cluster URL. */
  kustoClusterUrl?: url;

  /** Kusto database name. */
  kustoDatabaseName?: string;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Patch model for DiscoveryPipeline updates (tags + identity). */
@added(Versions.v2026_03_01_preview)
model DiscoveryPipelinePatch {
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;
  ...ManagedServiceIdentityProperty;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface DiscoveryPipelines {
  get is ArmResourceRead<DiscoveryPipeline>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DiscoveryPipeline>;

  /** Update discovery pipeline tags and identity. */
  @patch(#{ implicitOptionality: true })
  update is ArmCustomPatchSync<DiscoveryPipeline, DiscoveryPipelinePatch>;

  delete is ArmResourceDeleteWithoutOkAsync<DiscoveryPipeline>;
  listByResourceGroup is ArmResourceListByParent<DiscoveryPipeline>;
  listBySubscription is ArmListBySubscription<DiscoveryPipeline>;
}

// DiscoveryFlow (child of DiscoveryPipeline)

/** Individual batch ingestion flow. */
@added(Versions.v2026_03_01_preview)
@parentResource(DiscoveryPipeline)
model DiscoveryFlow
  is Azure.ResourceManager.ProxyResource<DiscoveryFlowProperties> {
  /** Flow name. */
  @key("flowName")
  @segment("flows")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of a DiscoveryFlow. */
@added(Versions.v2026_03_01_preview)
model DiscoveryFlowProperties {
  /** Flow kind. */
  kind: "BatchIngestion";

  /** Orchestration engine (Direct or ADF). */
  orchestration?: string;

  /** Fully qualified resource type this flow ingests. */
  fullyQualifiedResourceType?: string;

  /** Reference to a kustoQuery name from discoveryConfig. */
  kustoQuery?: string;

  /** Scheduling configuration. */
  scheduling?: FlowScheduling;

  /** Partitioning strategy. */
  partitioning?: FlowPartitioning;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Flow scheduling configuration. */
@added(Versions.v2026_03_01_preview)
model FlowScheduling {
  /** Interval in hours. */
  intervalHours?: int32 = 24;
}

/** Flow partitioning strategy. */
@added(Versions.v2026_03_01_preview)
model FlowPartitioning {
  /** Partitioning strategy (e.g., 'subscription'). */
  strategy?: string;

  /** Max number of partitions. */
  maxPartitions?: int32;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface DiscoveryFlows {
  get is ArmResourceRead<DiscoveryFlow>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<DiscoveryFlow>;
  delete is ArmResourceDeleteSync<DiscoveryFlow>;
  listByParent is ArmResourceListByParent<DiscoveryFlow>;
}

// DiscoveryIngestion (top-level, subscription-scoped, regional)

/** Regional streaming ingestion from GDS/Event Hub. */
@added(Versions.v2026_03_01_preview)
model DiscoveryIngestion
  is Azure.ResourceManager.TrackedResource<DiscoveryIngestionProperties> {
  /** Ingestion name. */
  @key("ingestionName")
  @segment("discoveryIngestions")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of a DiscoveryIngestion. */
@added(Versions.v2026_03_01_preview)
model DiscoveryIngestionProperties {
  /** ARM resource ID of the linked PublisherSettings. */
  linkedPublisherSettingsId: Azure.Core.armResourceIdentifier;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface DiscoveryIngestions {
  get is ArmResourceRead<DiscoveryIngestion>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DiscoveryIngestion>;

  /** Update discovery ingestion tags. */
  update is ArmTagsPatchSync<DiscoveryIngestion>;

  delete is ArmResourceDeleteWithoutOkAsync<DiscoveryIngestion>;
  listByResourceGroup is ArmResourceListByParent<DiscoveryIngestion>;
  listBySubscription is ArmListBySubscription<DiscoveryIngestion>;
}

// IngestionFlow (child of DiscoveryIngestion)

/** Individual streaming ingestion flow. */
@added(Versions.v2026_03_01_preview)
@parentResource(DiscoveryIngestion)
model IngestionFlow
  is Azure.ResourceManager.ProxyResource<IngestionFlowProperties> {
  /** Flow name. */
  @key("flowName")
  @segment("flows")
  @pattern("^[a-zA-Z0-9-]{1,64}$")
  @path
  name: string;
}

/** Properties of an IngestionFlow. */
@added(Versions.v2026_03_01_preview)
model IngestionFlowProperties {
  /** Flow kind. */
  kind: "Streaming";

  /** GDS event namespace. */
  gdsEventNamespace?: string;

  /** GDS event name. */
  gdsEventName?: string;

  /** Transformation type. */
  transformationType?: string;

  /** Event Hub configuration. */
  eventHubConfig?: EventHubConfig;

  /** Consumer group name. */
  consumerGroup?: string;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Event Hub configuration for streaming ingestion. */
@added(Versions.v2026_03_01_preview)
model EventHubConfig {
  /** Event Hub namespace. */
  eventHubNamespace?: string;

  /** Event Hub name. */
  eventHubName?: string;
}

@added(Versions.v2026_03_01_preview)
@armResourceOperations
interface IngestionFlows {
  get is ArmResourceRead<IngestionFlow>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<IngestionFlow>;
  delete is ArmResourceDeleteSync<IngestionFlow>;
  listByParent is ArmResourceListByParent<IngestionFlow>;
}
