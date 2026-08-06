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

/** The kind of scope for resource subscriptions, determining how notifications are scoped and delivered */
union ScopeKind {
  string,

  /** Tenant scope */
  tenant: "tenant",

  /** Cloud scope */
  cloud: "cloud",
}

/** Base properties for scope configuration */
@discriminator("kind")
model Scope {
  /** The kind of scope */
  kind: ScopeKind;
}

/** The caller identity extracted from the AAD token, validated against the manifest */
@added(Versions.v2026_06_01_preview)
model CallerIdentity {
  /** The application ID extracted from the auth token */
  @visibility(Lifecycle.Read)
  appId?: uuid;

  /** The object ID extracted from the auth token */
  @visibility(Lifecycle.Read)
  objectId?: uuid;

  /** The tenant ID extracted from the auth token */
  @visibility(Lifecycle.Read)
  tenantId?: uuid;
}

/** Tenant scope configuration */
model TenantScope extends Scope {
  /** The discriminator for tenant scope */
  kind: "tenant";

  tenantId?: string;
  servicePrincipal?: string;

  @added(Versions.v2026_06_01_preview)
  identity?: CallerIdentity;
}

/** Cloud scope configuration */
model CloudScope extends Scope {
  /** The discriminator for cloud scope */
  kind: "cloud";

  /** The resource provider id populated by the caller, used to perform the linked access check and validate the caller has permission against the RP itself. */
  @added(Versions.v2026_06_01_preview)
  id?: string;

  /** The provider namespace populated by caller */
  providerNamespace?: string;

  /** The application ID extracted from request, checked against manifest */
  appId?: uuid;
}

/** Partitioning configuration kind discriminator */
union PartitioningConfigurationKind {
  string,

  /** ARN location partitioning */
  arnLocation: "arnLocation",

  /** Resource location partitioning */
  @added(Versions.v2026_06_01_preview)
  resourceLocation: "resourceLocation",

  /** Routing location partitioning */
  @added(Versions.v2026_06_01_preview)
  routingLocation: "routingLocation",

  /** Scope ID hash-based partitioning */
  @added(Versions.v2026_06_01_preview)
  scopeId: "scopeId",
}

/** Base properties for partitioning configuration */
@discriminator("kind")
model PartitioningConfiguration {
  /** The kind of partitioning configuration */
  kind: PartitioningConfigurationKind;
}

/** Partition definition */
model Partition {
  /** The name of the partition */
  name: string;

  /** The regions for this partition */
  regions: string[];
}

/** ARN location partitioning configuration */
model ArnLocationPartitioningConfiguration extends PartitioningConfiguration {
  /** The discriminator for ARN location partitioning */
  kind: "arnLocation";

  /** The partitions list */
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  partitions: Partition[];
}

/** Resource location partitioning configuration */
@added(Versions.v2026_06_01_preview)
model ResourceLocationPartitioningConfiguration
  extends PartitioningConfiguration {
  /** The discriminator for resource location partitioning */
  kind: "resourceLocation";

  /** The partitions list */
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  partitions: Partition[];
}

/** Routing location partitioning configuration */
@added(Versions.v2026_06_01_preview)
model RoutingLocationPartitioningConfiguration
  extends PartitioningConfiguration {
  /** The discriminator for routing location partitioning */
  kind: "routingLocation";

  /** The partitions list */
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  partitions: Partition[];
}

/** A key/value pair entry for scope ID partitioning */
@added(Versions.v2026_06_01_preview)
model ScopeIdPartitionEntry {
  /** The partition key */
  key: string;

  /** The partition value */
  value: string;
}

/** Scope ID hash-based partitioning configuration */
@added(Versions.v2026_06_01_preview)
model ScopeIdPartitioningConfiguration extends PartitioningConfiguration {
  /** The discriminator for scope ID partitioning */
  kind: "scopeId";

  /** The field based on which the scope is hashed */
  configName: string;

  /** Number of hash buckets. The scope id is hashed into the range [0, hashBucket - 1]. Must be a positive integer. */
  hashBucket: int32;

  /** Map of partition key to partition value. Must be non-null/non-empty. */
  @OpenAPI.extension("x-ms-identifiers", #["key"])
  partitions: ScopeIdPartitionEntry[];

  /** Optional map from a partition key to the name of a nested partitioning configuration, enabling hierarchical partitioning. */
  @OpenAPI.extension("x-ms-identifiers", #["key"])
  partitionToPartitioningConfigurationMappings?: ScopeIdPartitionEntry[];

  /** Data boundary for the configuration. Defaults to Global. */
  dataBoundary?: DataBoundary;
}

/** Available options for resource subscriptions */
union SubscriptionOptions {
  string,

  /** Enables delivery of periodic snapshots */
  enablePeriodicSnapshots: "enablePeriodicSnapshots",

  /** Enables delivery of writes and deletes */
  enableDeltas: "enableDeltas",
}

/** The data boundary used for routing notifications and enforcing data residency/compliance */
@added(Versions.v2026_06_01_preview)
union DataBoundary {
  string,

  /** Global data boundary */
  global: "Global",

  /** European Union data boundary */
  eu: "EU",
}

/** The authentication type used by ARN when delivering notifications to the subscriber */
@added(Versions.v2026_06_01_preview)
union SubscriberAuthType {
  string,

  /** Default RBAC based authentication */
  defaultRBAC: "DefaultRBAC",

  /** Datacenter STS based authentication (default) */
  dSTS: "DSTS",
}

/** The kind of delivery mode, determining how notifications are distributed across destination endpoints */
@added(Versions.v2026_06_01_preview)
union DeliveryModeKind {
  string,

  /** Deliver every notification to all endpoints (default) */
  fanOut: "FanOut",

  /** Distribute notifications across endpoints based on partitioning */
  partitioning: "Partitioning",

  /** Distribute notifications evenly across endpoints */
  equalDistribution: "EqualDistribution",
}

/** Base configuration for how notifications are distributed across a subscription's destination endpoints */
@added(Versions.v2026_06_01_preview)
@discriminator("kind")
model DeliveryModeConfiguration {
  /** The kind of delivery mode */
  kind: DeliveryModeKind;
}

/** Fan-out delivery mode: every notification is delivered to all endpoints */
@added(Versions.v2026_06_01_preview)
model FanOutDeliveryModeConfiguration extends DeliveryModeConfiguration {
  /** The discriminator for fan-out delivery mode */
  kind: "FanOut";
}

/** Partitioning delivery mode: notifications are distributed across endpoints based on partitioning */
@added(Versions.v2026_06_01_preview)
model PartitioningDeliveryModeConfiguration extends DeliveryModeConfiguration {
  /** The discriminator for partitioning delivery mode */
  kind: "Partitioning";

  /** The partitioning configuration settings. Supported kind: arnLocation */
  configurationSettings: PartitioningConfiguration;
}

/** Equal-distribution delivery mode: notifications are distributed evenly across endpoints */
@added(Versions.v2026_06_01_preview)
model EqualDistributionDeliveryModeConfiguration
  extends DeliveryModeConfiguration {
  /** The discriminator for equal-distribution delivery mode */
  kind: "EqualDistribution";
}

/** Properties of a resource subscription */
model ResourceSubscriptionProperties {
  /** The query to execute - only one table can be targeted at a time */
  query: string;

  /** The scope for the execution of the filter */
  scope: Scope;

  /** The data boundary used for routing notifications and enforcing data residency/compliance */
  @added(Versions.v2026_06_01_preview)
  dataBoundary?: DataBoundary;

  /** The authentication type used by ARN when delivering notifications to the subscriber. Defaults to DSTS. */
  @added(Versions.v2026_06_01_preview)
  subscriberAuthType?: SubscriberAuthType;

  /** Determines how notifications are distributed across the subscription's destination endpoints. Defaults to FanOut. */
  @added(Versions.v2026_06_01_preview)
  deliveryMode?: DeliveryModeConfiguration;

  /** Compatibility alias for delivery mode configuration used by existing examples. */
  @added(Versions.v2026_06_01_preview)
  deliveryModeConfiguration?: DeliveryModeConfiguration;

  /** Defines how to partition the event stream. Supported kind: arnLocation */
  partitioningConfiguration?: PartitioningConfiguration;

  /** Additional partitioning configurations applied to the event stream */
  @added(Versions.v2026_06_01_preview)
  @OpenAPI.extension("x-ms-identifiers", #[])
  partitionConfigurations?: PartitioningConfiguration[];

  /** Optional configuration options */
  @visibility(Lifecycle.Read)
  options?: SubscriptionOptions[];

  /** The status of the last operation */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** The resource provisioning state */
@lroStatus
union ProvisioningState {
  ResourceProvisioningState,

  /** The resource is being provisioned */
  Provisioning: "Provisioning",

  /** The resource is updating */
  Updating: "Updating",

  /** The resource is being deleted */
  Deleting: "Deleting",

  /** The resource create request has been accepted */
  Accepted: "Accepted",

  string,
}

/** Resource subscription for Azure Resource Notifications */
@resource("resourceSubscriptions")
model ResourceSubscription
  is Azure.ResourceManager.TrackedResource<ResourceSubscriptionProperties> {
  /** The name of the resource subscription */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]*$")
  @key("subscriptionRuleName")
  @segment("resourceSubscriptions")
  @path
  name: string;
}

/** Operations for Resource Subscriptions */
@armResourceOperations
interface ResourceSubscriptions {
  /** Gets a resource subscription */
  get is ArmResourceRead<ResourceSubscription>;

  /** Creates or updates a resource subscription */
  #suppress "@azure-tools/typespec-azure-core/invalid-final-state" "This is a valid final state for a PUT operation"
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ResourceSubscription>;

  /** Updates the tags on a resource subscription */
  @OpenAPI.extension(
    "x-ms-examples",
    #{
      `Update a resource subscription`: #{
        $ref: "./examples/ResourceSubscriptions_Update.json",
      },
    }
  )
  @patch(#{ implicitOptionality: true })
  update is ArmTagsPatchSync<ResourceSubscription>;

  /** Deletes a resource subscription. Asynchronous operation. */
  delete is ArmResourceDeleteWithoutOkAsync<ResourceSubscription>;

  /** Lists all resource subscriptions in a resource group */
  @OpenAPI.extension(
    "x-ms-examples",
    #{
      `List all resource subscriptions in a resource group`: #{
        $ref: "./examples/ResourceSubscriptions_List.json",
      },
    }
  )
  listByResourceGroup is ArmResourceListByParent<ResourceSubscription>;

  /** Lists all resource subscriptions in a subscription */
  @OpenAPI.extension(
    "x-ms-examples",
    #{
      `List all resource subscriptions in a subscription`: #{
        $ref: "./examples/ResourceSubscriptions_ListBySubscription.json",
      },
    }
  )
  listBySubscription is ArmListBySubscription<ResourceSubscription>;
}

// Destination Models

/** Destination kind discriminator */
union DestinationKind {
  string,

  /** Fabric table destination */
  fabricTable: "fabricTable",

  /** Storage account destination */
  storageAccount: "storageAccount",

  /** Webhook (HTTP endpoint) destination */
  @added(Versions.v2026_06_01_preview)
  webhook: "webhook",

  /** Event Hub destination */
  @added(Versions.v2026_06_01_preview)
  eventhub: "eventhub",
}

/** Available destination options */
union DestinationOptions {
  string,

  /** Enables delivery of the initial snapshot */
  enableInitialSnapshot: "enableInitialSnapshot",
}

/** Base properties for destination configuration */
@discriminator("kind")
model DestinationProperties {
  /** The kind of destination */
  kind: DestinationKind;

  /** The status of the last operation */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Fabric endpoint configuration */
model FabricEndpoint {
  /** The workspace ID */
  workspaceId: string;

  /** The database ID */
  databaseId: string;
}

/** Fabric table destination properties */
model FabricTableDestinationProperties extends DestinationProperties {
  /** The discriminator for fabric table destination */
  kind: "fabricTable";

  /** The output schema - readonly for now, will provide a way for 1P to set to fabric1P */
  @visibility(Lifecycle.Read)
  outputSchema?: string;

  /** The output encoding - readonly and not configurable */
  @visibility(Lifecycle.Read)
  outputEncoding?: string;

  /** The fabric endpoint configuration */
  endpoint: FabricEndpoint;

  /** Optional destination configuration options */
  @visibility(Lifecycle.Read)
  options?: DestinationOptions[];
}

/** Storage account endpoint */
model StorageAccountEndpoint {
  /** The storage account endpoint resource ID */
  id: string;
}

/** Path policy kind discriminator */
union PathPolicyKind {
  string,

  /** Time and scope range hash path policy */
  timeAndScopeRangeHash: "timeAndScopeRangeHash",
}

/** Base properties for path policy configuration */
@discriminator("kind")
model PathPolicy {
  /** The kind of path policy */
  kind: PathPolicyKind;
}

/** Time and scope range hash path policy */
model TimeAndScopeRangeHashPathPolicy extends PathPolicy {
  /** The discriminator for time and scope range hash path policy */
  kind: "timeAndScopeRangeHash";

  /**
   * The source of time used for partitioning and hashing.
   * Typical values include "eventTime" (use the event timestamp) and "systemTime" (use the ingestion/processing time).
   */
  timeSource: string;

  /**
   * The logical scope used for hashing into buckets, for example "tenant", "subscription", or "resourceGroup".
   */
  scope: string;

  /** The number of scope buckets to hash the chosen scope into. */
  scopeBuckets: int32;

  /**
   * The path template string with variable placeholders that will be resolved at runtime, following the pattern:
   * year={yyyy},month={mm},day={dd}/hour={hh}/tenantBucket={scopeBucket}.
   * Placeholders such as {yyyy}, {mm}, {dd}, {hh}, and {scopeBucket} are replaced with the corresponding values.
   */
  pathTemplate: string;
}

/** Batching policy kind discriminator */
union BatchingPolicyKind {
  string,

  /** Min count max delay batching policy */
  minCountMaxDelay: "minCountMaxDelay",
}

/** The delivery mode for endpoints, determining how notifications are distributed across endpoints */
union EndpointDeliveryMode {
  string,

  /** Spreads load over all endpoints */
  roundRobin: "round-robin",

  /** Delivers to the first available endpoint */
  failover: "failover",
}

/** Base properties for batching policy configuration */
@discriminator("kind")
model BatchingPolicy {
  /** The kind of batching policy */
  kind: BatchingPolicyKind;
}

/** Min count max delay batching policy */
model MinCountMaxDelayBatchingPolicy extends BatchingPolicy {
  /** The discriminator for min count max delay batching policy */
  kind: "minCountMaxDelay";

  /** Minimum number of resources */
  minResources: int32;

  /** Maximum delay in ISO 8601 duration format (e.g., PT5M for 5 minutes) */
  maxDelay: duration;
}

/** Storage account destination properties */
model StorageAccountDestinationProperties extends DestinationProperties {
  /** The discriminator for storage account destination */
  kind: "storageAccount";

  /** Which partitions go to this destination */
  partitions: string[];

  /** Incoming notifications are mapped to a path based on the path policy */
  pathPolicy: PathPolicy;

  /** Notifications for the same path are batched following the batching policy */
  batchingPolicy?: BatchingPolicy;

  /** The schema to use for the delivered notifications - read-only, must be "firstParty" for now */
  @visibility(Lifecycle.Read)
  outputSchema?: string;

  /** Format for the output - read-only, must be "parquet" for now */
  @visibility(Lifecycle.Read)
  outputEncoding?: string;

  /** Storage container to store the data */
  endpointContainer: string;

  /** How to deliver to the endpoints below */
  endpointDeliveryMode: EndpointDeliveryMode;

  /** Set of endpoints to use */
  @OpenAPI.extension("x-ms-identifiers", #["id"])
  endpoints: StorageAccountEndpoint[];
}

/** Webhook endpoint configuration */
@added(Versions.v2026_06_01_preview)
model WebhookEndpoint {
  /** The HTTPS endpoint URL to which notifications are delivered */
  url: url;

  /** The application ID used to acquire a token for delivery */
  applicationId: string;
}

/** Webhook destination properties */
@added(Versions.v2026_06_01_preview)
model WebhookDestinationProperties extends DestinationProperties {
  /** The discriminator for webhook destination */
  kind: "webhook";

  /** The schema to use for the delivered notifications */
  outputSchema: string;

  /** The encoding/format to use for the delivered notifications */
  outputEncoding: string;

  /** The set of webhook endpoints to deliver notifications to */
  @OpenAPI.extension("x-ms-identifiers", #["url"])
  endpoints: WebhookEndpoint[];
}

/** Event Hub endpoint configuration */
@added(Versions.v2026_06_01_preview)
model EventHubEndpoint {
  /** The Azure resource ID of the target Event Hub */
  id: armResourceIdentifier;
}

/** Event Hub destination properties */
@added(Versions.v2026_06_01_preview)
model EventHubDestinationProperties extends DestinationProperties {
  /** The discriminator for event hub destination */
  kind: "eventhub";

  /** The schema to use for the delivered notifications */
  outputSchema: string;

  /** The encoding/format to use for the delivered notifications */
  outputEncoding: string;

  /** The set of event hub endpoints to deliver notifications to */
  @OpenAPI.extension("x-ms-identifiers", #["id"])
  endpoints: EventHubEndpoint[];
}

/** The identity type. */
@added(Versions.v2026_06_01_preview)
union ResourceIdentityType {
  string,

  /** Indicates that a user assigned identity is associated with the resource. */
  UserAssigned: "UserAssigned",
}

/** The details of a user assigned identity. */
@added(Versions.v2026_06_01_preview)
model UserAssignedIdentitiesValue {
  /** The principal id of user assigned identity. */
  @visibility(Lifecycle.Read)
  principalId?: string;

  /** The client id of user assigned identity. */
  @visibility(Lifecycle.Read)
  clientId?: string;
}

/** Identity for the destination resource, used by ARN to deliver notifications to the destination endpoint. */
@added(Versions.v2026_06_01_preview)
model Identity {
  /** The identity type. */
  type: ResourceIdentityType;

  /** The user identity associated with the destination. The user identity dictionary key references will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "User assigned identities are keyed by ARM resource id, following the Microsoft.Authorization/policyAssignments Identity model"
  userAssignedIdentities?: Record<UserAssignedIdentitiesValue>;
}

/** Destination resource for Azure Resource Notifications */
@resource("destinations")
@parentResource(ResourceSubscription)
model Destination
  is Azure.ResourceManager.TrackedResource<DestinationProperties> {
  /** The name of the destination */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]*$")
  @key("destinationName")
  @segment("destinations")
  @path
  name: string;

  /** The managed identity used by ARN to deliver notifications to the destination endpoint. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Custom identity model on the resource envelope, following the Microsoft.Authorization/policyAssignments pattern"
  identity?: Identity;
}

@@added(Destination.identity, Versions.v2026_06_01_preview);

/** The updatable fields of a destination resource. */
model DestinationUpdate {
  /** Resource tags. */
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;

  /** The managed identity used by ARN to deliver notifications to the destination endpoint. */
  identity?: Identity;
}

@@added(DestinationUpdate.identity, Versions.v2026_06_01_preview);

/** Operations for Destinations */
@armResourceOperations
interface Destinations {
  /** Gets a destination */
  @operationId("ResourceSubscriptionDestinations_Get")
  get is ArmResourceRead<Destination>;

  /** Creates or updates a destination. Asynchronous operation. */
  @operationId("ResourceSubscriptionDestinations_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Destination>;

  /** Updates the tags on a destination */
  @operationId("ResourceSubscriptionDestinations_Update")
  @patch(#{ implicitOptionality: true })
  update is ArmCustomPatchSync<Destination, DestinationUpdate>;

  /** Deletes a destination. Asynchronous operation. */
  @operationId("ResourceSubscriptionDestinations_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<Destination>;

  /** Lists all destinations for a resource subscription */
  @OpenAPI.extension(
    "x-ms-examples",
    #{
      `List all destinations for a resource subscription`: #{
        $ref: "./examples/ResourceSubscriptionDestinations_List.json",
      },
    }
  )
  @operationId("ResourceSubscriptionDestinations_List")
  list is ArmResourceListByParent<Destination>;
}
