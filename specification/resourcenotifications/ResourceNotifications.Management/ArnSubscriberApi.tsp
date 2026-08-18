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

  tenantId: string;
  servicePrincipal?: string;

  @added(Versions.v2026_06_01_preview)
  identity?: CallerIdentity;
}

/** Cloud scope configuration */
model CloudScope extends Scope {
  /** The discriminator for cloud scope */
  kind: "cloud";

  /** Provider registration or namespace identity used to validate the caller against the RP relationship. */
  id: string;
}

/** Partitioning configuration kind discriminator */
union PartitioningConfigurationKind {
  string,

  /** ARN region partitioning */
  arnRegion: "arnRegion",

  /** Resource location partitioning */
  resourceLocation: "resourceLocation",

  /** Routing location partitioning */
  routingLocation: "routingLocation",

  /** Scope ID hash-based partitioning */
  scopeId: "scopeId",
}

/** Base properties for partitioning configuration */
@discriminator("kind")
model PartitioningConfiguration {
  /** The kind of partitioning configuration */
  kind: PartitioningConfigurationKind;

  /** Only specified for a child partitioning config. References the parent partition name. Root config omits this field. */
  parentPartition?: string;
}

/** ARN region partition definition */
model ArnRegionPartition {
  /** The name of the partition */
  name: string;

  /** The ARN regions included in this partition */
  arnRegions: string[];
}

/** Resource location partition definition */
model ResourceLocationPartition {
  /** The name of the partition */
  name: string;

  /** The resource locations included in this partition */
  resourceLocations: string[];
}

/** Routing location partition definition */
model RoutingLocationPartition {
  /** The name of the partition */
  name: string;

  /** The routing locations included in this partition */
  routingLocations: string[];
}

/** Hash range partition definition */
model HashRangePartition {
  /** The name of the partition */
  name: string;

  /** Single hash range string, e.g., '0:49'. */
  range: string;
}

/** ARN region partitioning configuration */
model ArnRegionPartitioningConfiguration extends PartitioningConfiguration {
  /** The discriminator for ARN region partitioning */
  kind: "arnRegion";

  /** The partitions list */
  @identifiers(#["name"])
  partitions: ArnRegionPartition[];
}

/** Resource location partitioning configuration */
@added(Versions.v2026_06_01_preview)
model ResourceLocationPartitioningConfiguration
  extends PartitioningConfiguration {
  /** The discriminator for resource location partitioning */
  kind: "resourceLocation";

  /** The partitions list */
  @identifiers(#["name"])
  partitions: ResourceLocationPartition[];
}

/** Routing location partitioning configuration */
@added(Versions.v2026_06_01_preview)
model RoutingLocationPartitioningConfiguration
  extends PartitioningConfiguration {
  /** The discriminator for routing location partitioning */
  kind: "routingLocation";

  /** The partitions list */
  @identifiers(#["name"])
  partitions: RoutingLocationPartition[];
}

/** Scope ID hash-based partitioning configuration */
@added(Versions.v2026_06_01_preview)
model ScopeIdPartitioningConfiguration extends PartitioningConfiguration {
  /** The discriminator for scope ID partitioning */
  kind: "scopeId";

  /** Number of hash buckets. The scope id is hashed into the range [0, hashBucketCount - 1]. Must be a positive integer. */
  hashBucketCount: int32;

  /** The partitions list. Ranges must be sorted, contiguous, gap-free, and cover [0, hashBucketCount - 1]. */
  @identifiers(#["name"])
  partitions: HashRangePartition[];
}

/** Optional configuration options for a resource subscription */
#suppress "@azure-tools/typespec-client-generator-core/csharp-model-suffix" "Name kept for backward compatibility and to match the wire property name 'options'."
@added(Versions.v2026_08_01_preview)
model ResourceSubscriptionOptions {
  /** Strips notification payload/resources before delivery. */
  skipPayload?: boolean;

  /** Subscriber receives preview/pre-GA notifications that are otherwise dropped. */
  allowPreviewNotifications?: boolean;

  /** The authentication type used by ARN when delivering notifications to the subscriber. Defaults to DefaultRBAC when omitted. */
  authorizationMode?: AuthorizationMode;
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
union AuthorizationMode {
  string,

  /** Default RBAC-based authorization mode (default when omitted). */
  defaultRBAC: "DefaultRBAC",

  /** Datacenter STS based authentication (default) */
  dSTS: "DSTS",
}

/** The kind of delivery mode, determining how notifications are distributed across destination endpoints */
@added(Versions.v2026_06_01_preview)
union DeliveryModeKind {
  string,

  /** Deliver every notification to all endpoints (default) */
  fanOut: "fanOut",

  /** Distribute notifications across endpoints based on partitioning */
  partitioned: "partitioned",
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
  kind: "fanOut";
}

/** Partitioning delivery mode: notifications are distributed across endpoints based on partitioning */
@added(Versions.v2026_06_01_preview)
model PartitioningDeliveryModeConfiguration extends DeliveryModeConfiguration {
  /** The discriminator for partitioning delivery mode */
  kind: "partitioned";

  /** The partitioning configurations. Present only when kind = partitioned. */
  @identifiers(#[])
  partitioningConfigurations: PartitioningConfiguration[];
}

/** Properties of a resource subscription */
model ResourceSubscriptionProperties {
  /** The query to execute - only one table can be targeted at a time */
  query: string;

  /** The scope for the execution of the filter */
  scope: Scope;

  /** Determines how notifications are distributed across the subscription's destination endpoints. Defaults to fanOut. */
  @added(Versions.v2026_06_01_preview)
  deliveryMode?: DeliveryModeConfiguration;

  /** Optional configuration options */
  @added(Versions.v2026_08_01_preview)
  options?: ResourceSubscriptionOptions;

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
  eventHub: "eventHub",
}

/** The kind of destination-level delivery mode */
@added(Versions.v2026_08_01_preview)
union DestinationDeliveryModeKind {
  string,

  /** Deliver every notification to all endpoints in the destination (default) */
  fanOut: "fanOut",

  /** Distribute notifications evenly across the destination's endpoints */
  equalDistribution: "equalDistribution",
}

/** Base configuration for how notifications are distributed across a destination's endpoints */
@added(Versions.v2026_08_01_preview)
@discriminator("kind")
model DestinationDeliveryMode {
  /** The kind of destination delivery mode */
  kind: DestinationDeliveryModeKind;
}

/** Fan-out destination delivery mode: every notification is delivered to all endpoints */
@added(Versions.v2026_08_01_preview)
model FanOutDestinationDeliveryMode extends DestinationDeliveryMode {
  /** The discriminator for fan-out destination delivery mode */
  kind: "fanOut";
}

/** Equal-distribution destination delivery mode: notifications are distributed evenly across endpoints */
@added(Versions.v2026_08_01_preview)
model EqualDistributionDestinationDeliveryMode extends DestinationDeliveryMode {
  /** The discriminator for equal-distribution destination delivery mode */
  kind: "equalDistribution";
}

/** Base properties shared by all destination kinds */
model DestinationPropertiesBase {
  /** The status of the last operation */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** Destination-level data boundary used to route/deliver notifications for EU/global where required. */
  @added(Versions.v2026_08_01_preview)
  dataBoundary?: DataBoundary;

  /** Parent partition names this destination receives. Required when the parent subscription's deliveryMode is partitioned. */
  partitions?: string[];

  /** Delivery mode applied only within this destination to its endpoints. Defaults to fanOut. */
  @added(Versions.v2026_08_01_preview)
  deliveryMode?: DestinationDeliveryMode;
}

/** Fabric endpoint configuration */
model FabricEndpoint {
  /** The workspace ID */
  workspaceId: string;

  /** The database ID */
  databaseId: string;
}

/** Storage account endpoint */
model StorageAccountEndpoint {
  /** The storage account endpoint resource ID */
  id: armResourceIdentifier;
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
   * The logical scope used for hashing into buckets, for example 'tenant', 'subscription', or 'resourceGroup'.
   */
  scope: string;

  /** The number of scope buckets to hash the chosen scope into. */
  scopeBucketsCount: int32;

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
/** Webhook endpoint configuration */
@added(Versions.v2026_06_01_preview)
model WebhookEndpoint {
  /** The HTTPS endpoint URL to which notifications are delivered */
  url: url;

  /** The application id used as audience/auth target for delivery. */
  appId: string;
}

/** Event Hub endpoint configuration */
@added(Versions.v2026_06_01_preview)
model EventHubEndpoint {
  /** The Azure resource ID of the target Event Hub */
  id: armResourceIdentifier;
}

/** The identity type for a destination resource. Only UserAssigned is supported. */
@added(Versions.v2026_06_01_preview)
union ResourceIdentityType {
  string,

  /** User-assigned managed identity. Only UserAssigned is supported; to swap the assigned identity, update userAssignedIdentities with the new identity resource ID. */
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

/** Identity for the destination resource, used by ARN to deliver notifications to the destination endpoint. Only user-assigned managed identity is supported. */
@added(Versions.v2026_06_01_preview)
model Identity {
  /** The identity type. Only UserAssigned is supported. To change the assigned identity, PATCH userAssignedIdentities with the replacement identity resource ID; removal is not supported. */
  type: ResourceIdentityType;

  /** The user identity associated with the destination. The user identity dictionary key references will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "User assigned identities are keyed by ARM resource id, following the Microsoft.Authorization/policyAssignments Identity model"
  userAssignedIdentities: Record<UserAssignedIdentitiesValue>;
}

/** Destination resource for Azure Resource Notifications */
@discriminator("kind")
@resource("destinations")
@parentResource(ResourceSubscription)
model Destination
  is Azure.ResourceManager.TrackedResource<DestinationPropertiesBase> {
  /** The name of the destination */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]*$")
  @key("destinationName")
  @segment("destinations")
  @path
  name: string;

  /** The kind of destination */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "kind is the ARM envelope discriminator for the Destination polymorphic resource type"
  kind: DestinationKind;

  /** The managed identity used by ARN to deliver notifications to the destination endpoint. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Custom identity model on the resource envelope, following the Microsoft.Authorization/policyAssignments pattern"
  identity: Identity;
}

@@added(Destination.identity, Versions.v2026_06_01_preview);

/** Fabric table destination */
model FabricTableDestination extends Destination {
  /** The discriminator for fabric table destination */
  kind: DestinationKind.fabricTable;

  /** The fabric endpoint configuration */
  endpoint: FabricEndpoint;
}

/** Storage account destination */
model StorageAccountDestination extends Destination {
  /** The discriminator for storage account destination */
  kind: DestinationKind.storageAccount;

  /** Container where blobs are written. Applies to all storage account endpoints in this destination. */
  container: string;

  /** Incoming notifications are mapped to a path based on the path policy */
  pathPolicy: PathPolicy;

  /** Notifications for the same path are batched following the batching policy */
  batchingPolicy?: BatchingPolicy;

  /** Set of endpoints to use */
  @identifiers(#["id"])
  endpoints: StorageAccountEndpoint[];
}

/** Webhook destination */
@added(Versions.v2026_06_01_preview)
model WebhookDestination extends Destination {
  /** The discriminator for webhook destination */
  kind: DestinationKind.webhook;

  /** The set of webhook endpoints to deliver notifications to */
  @identifiers(#["url"])
  endpoints: WebhookEndpoint[];
}

/** Event Hub destination */
@added(Versions.v2026_06_01_preview)
model EventHubDestination extends Destination {
  /** The discriminator for event hub destination */
  kind: DestinationKind.eventHub;

  /** The set of event hub endpoints to deliver notifications to */
  @identifiers(#["id"])
  endpoints: EventHubEndpoint[];
}

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
interface ResourceSubscriptionDestinations {
  /** Gets a destination */
  get is ArmResourceRead<Destination>;

  /** Creates or updates a destination. Asynchronous operation. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Destination>;

  /** Updates the tags on a destination */
  @patch(#{ implicitOptionality: true })
  update is ArmCustomPatchSync<Destination, DestinationUpdate>;

  /** Deletes a destination. Asynchronous operation. */
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
  list is ArmResourceListByParent<Destination>;
}
