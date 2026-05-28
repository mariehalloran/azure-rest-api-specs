import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

@doc("Microsoft.Cosmic Resource Provider Management API.")
namespace Microsoft.Cosmic;

// --- Cosmic Ring Definition ---------------------------------------------

@doc("Cosmic Rings.")
union CosmicRing {
  @doc("Plat ring")
  Plat: "plat",

  @doc("Dev ring")
  Dev: "dev",

  @doc("Rnr ring")
  Rnr: "rnr",

  @doc("Tdf ring")
  Tdf: "tdf",

  @doc("Infra ring")
  Infra: "infra",

  @doc("Test ring")
  Test: "test",

  @doc("SDF ring")
  Sdf: "sdf",

  @doc("MSIT ring")
  Msit: "msit",

  @doc("Prod ring")
  Prod: "prod",

  @doc("Gallatin ring")
  Gallatin: "gallatin",

  @doc("Bleu ring")
  Bleu: "bleu",

  @doc("Delos ring")
  Delos: "delos",

  @doc("GCC ring")
  Gcc: "gcc",

  @doc("GCCH ring")
  Gcch: "gcch",

  @doc("DOD ring")
  Dod: "dod",

  @doc("Ag08 ring")
  Ag08: "ag08",

  @doc("Ag09 ring")
  Ag09: "ag09",

  string,
}

// --- Provisioning state ---------------------------------------------

@doc("The provisioning state of a Cosmic resource.")
union CosmicProvisioningState {
  ResourceProvisioningState,

  @doc("The resource is being provisioned.")
  Provisioning: "Provisioning",

  @doc("The resource is being updated.")
  Updating: "Updating",

  @doc("The resource is being deleted.")
  Deleting: "Deleting",

  @doc("The resource creation request has been accepted.")
  Accepted: "Accepted",

  string,
}

// --- Environment enums -----------------------------------------------

@doc("The operating system type for the compute nodes.")
union OsType {
  @doc("Linux operating system.")
  Linux: "Linux",

  @doc("Windows operating system.")
  Windows: "Windows",

  string,
}

@doc("IP Version")
union IpVersion {
  @doc("Version IPv4")
  IPV4: "IPv4",

  @doc("Version IPv6")
  IPV6: "IPv6",

  string,
}

@doc("The GPU driver type.")
union GpuDriverType {
  @doc("CUDA driver for compute workloads.")
  CUDA: "CUDA",

  @doc("GRID driver for visualization workloads.")
  GRID: "GRID",

  string,
}

@doc("The migration state of a namespace instance.")
union MigrationState {
  @doc("Instance spec and cluster spec are mismatched; migration is required but has not started.")
  NeedsMigration: "NeedsMigration",

  @doc("The instance is currently being migrated.")
  InMigration: "InMigration",

  @doc("The instance is correctly placed; no migration is required.")
  NoMigrationNeeded: "NoMigrationNeeded",

  string,
}

@doc("The realization state of an environment resource.")
union RealizationState {
  @doc("Realization has been accepted.")
  Accepted: "Accepted",

  @doc("Realization is in progress.")
  InProgress: "InProgress",

  @doc("Realization succeeded.")
  Succeeded: "Succeeded",

  @doc("Realization failed.")
  Failed: "Failed",

  @doc("Realization was canceled.")
  Canceled: "Canceled",

  @doc("Realization partially succeeded.")
  PartiallySucceeded: "PartiallySucceeded",

  string,
}

@doc("The health state of an environment resource.")
union HealthState {
  @doc("The environment is healthy.")
  Healthy: "Healthy",

  @doc("The environment is unhealthy.")
  Unhealthy: "Unhealthy",

  @doc("The health state is unknown.")
  Unknown: "Unknown",

  string,
}

@doc("The provisioning status of a namespace instance on a cluster.")
union InstanceProvisioningStatus {
  @doc("Status is unspecified.")
  Unspecified: "Unspecified",

  @doc("The instance is ready.")
  Ready: "Ready",

  @doc("The instance has been soft-deleted.")
  SoftDeleted: "SoftDeleted",

  @doc("The instance encountered an error.")
  Error: "Error",

  @doc("The instance is pending provisioning.")
  Pending: "Pending",

  @doc("The instance resources have been cleaned up.")
  ResourcesCleanedUp: "ResourcesCleanedUp",

  @doc("The instance is terminating.")
  Terminating: "Terminating",

  string,
}

// --- Topology models ------------------------------------------------

@doc("Optional per-location topology declarations including networking and partition identity.")
model Topology {
  @doc("Per-location topology declarations keyed by canonical Azure region name.")
  @identifiers(#["name"])
  locations?: TopologyLocation[];
}

@doc("Per-location topology configuration including networking and optional partition declarations.")
model TopologyLocation {
  @doc("Canonical Azure region name.")
  @minLength(1)
  name: string;

  @doc("Optional SNAT ports to allocate per node.")
  @minValue(0)
  @maxValue(64000)
  snatPortsPerNode?: int32;

  @doc("BYOIP configuration for ingress traffic.")
  @identifiers(#["ipTagType", "ipTagValue"])
  ingressPublicIps?: IngressPublicIp[];

  @doc("BYOIP configuration for egress traffic.")
  egressPublicIps?: EgressPublicIps;

  @doc("BYOIP configuration for instance-level public IP.")
  instanceLevelPublicIp?: InstanceLevelPublicIp;

  @doc("Optional declared partition set for this location.")
  @identifiers(#["name"])
  partitions?: TopologyPartition[];
}

@doc("Declared partition identity for a location.")
model TopologyPartition {
  @doc("The partition name.")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @minLength(3)
  @maxLength(24)
  name: string;
}

// --- Capacity models ------------------------------------------------

@doc("Capacity configuration for the environment.")
model CapacityPolicy {
  @doc("Per-location desired capacity keyed by canonical Azure region name.")
  @identifiers(#["name"])
  locations?: LocationCapacity[];
}

@doc("Per-location desired capacity.")
model LocationCapacity {
  @doc("Canonical Azure region name.")
  @minLength(1)
  name: string;

  @doc("Total desired instance count in this location.")
  @minValue(1)
  totalInstanceCount?: int32;

  @doc("Optional breakdown of capacity by partition key.")
  @identifiers(#["name"])
  partitions?: PartitionCapacity[];
}

@doc("Explicit capacity configuration for a specific partition.")
model PartitionCapacity {
  @doc("The partition name.")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @minLength(3)
  @maxLength(24)
  name: string;

  @doc("The number of instances to realize for this partition.")
  @minValue(1)
  instanceCount: int32;
}

// --- Resource policy models -----------------------------------------

@doc("Resource policy configuration with layered environment/region/partition overrides.")
model ResourcePolicy {
  @doc("Default resource policy for the environment.")
  environmentDefault?: EnvironmentDefaultPolicy;

  @doc("Per-region resource policy overrides keyed by canonical location.")
  @identifiers(#["name"])
  regionOverrides?: RegionOverride[];
}

@doc("Environment-scoped default resource policy.")
model EnvironmentDefaultPolicy {
  @doc("Per-service pod resource specifications.")
  @identifiers(#[])
  podResources?: PodSpec[];

  @doc("The operating system type.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  os?: OsType;

  @doc("The IP version (IPv4 or IPv6).")
  ipVersion?: IpVersion;

  @doc("The Azure VM family for cluster selection (e.g., 'D_FLEX', 'F_FLEX', 'DV4').")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  vmFamily?: string;
}

@doc("Region-scoped policy overrides.")
model RegionOverride {
  @doc("Canonical Azure region name.")
  @minLength(1)
  name: string;

  @doc("Region-level default policy.")
  regionDefault?: RegionDefaultPolicy;

  @doc("Partition-scoped policy overrides keyed by partition name.")
  @identifiers(#["name"])
  partitions?: PartitionOverride[];
}

@doc("Region-level default resource policy.")
model RegionDefaultPolicy {
  @doc("The IP version override for this region.")
  ipVersion?: IpVersion;
}

@doc("Partition-scoped policy overrides.")
model PartitionOverride {
  @doc("The partition name.")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @minLength(3)
  @maxLength(24)
  name: string;

  @doc("Partition-level default policy.")
  partitionDefault?: PartitionDefaultPolicy;

  @doc("Migration-only per-instance overrides.")
  @identifiers(#["instanceId"])
  instanceOverrides?: InstanceOverride[];
}

@doc("Partition-level default resource policy.")
model PartitionDefaultPolicy {
  @doc("The operating system type override.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  os?: OsType;

  @doc("Per-service pod resource specifications.")
  @identifiers(#[])
  podResources?: PodSpec[];

  @doc("The Azure VM family override for this partition (e.g., 'F_FLEX' for GPU partitions).")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  vmFamily?: string;
}

@doc("Migration-only per-instance resource override.")
model InstanceOverride {
  @doc("Opaque RP instance identifier (GUID).")
  @pattern("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")
  instanceId: string;

  @doc("Optional per-instance quota override.")
  instanceQuota?: InstanceQuota;
}

@doc("Per-instance quota override shape (migration-only).")
model InstanceQuota {
  @doc("The Azure VM family.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  vmFamily?: string;

  @doc("Per-service pod resource specifications.")
  @identifiers(#[])
  podResources?: PodSpec[];
}

// --- Pod resource models ---------------------------------------------

@doc("Pod resource envelope.")
model PodSpec {
  @doc("CPU cores requested per pod (e.g. '0.5', '2').")
  @pattern("^([0-9]*\\.?[0-9]+)$")
  cores?: string;

  @doc("Memory requested per pod (e.g. '512Mi', '2Gi').")
  @pattern("^[0-9]+(\\.[0-9]+)?(Mi|Gi)$")
  memory?: string;

  @doc("CPU cores limit per pod. If unset, defaults to approximately 2x the request.")
  @pattern("^([0-9]*\\.?[0-9]+)$")
  coresLimit?: string;

  @doc("Memory limit per pod. If unset, defaults to approximately 2x the request.")
  @pattern("^[0-9]+(\\.[0-9]+)?(Mi|Gi)$")
  memoryLimit?: string;

  @doc("Number of replicas per cluster.")
  @minValue(1)
  replicas?: int32;

  @doc("Percentage of replicas considered during rolling updates.")
  @minValue(0)
  @maxValue(25)
  rollingUpdateReplicaPercentage?: int32;
}

// --- Environment read-only status models -----------------------------

@doc("Status of the environment.")
model EnvironmentStatus {
  @doc("The overall realization state.")
  realizationState?: RealizationState;

  @doc("Per-region realization details.")
  @identifiers(#["id"])
  realizations?: Realization[];
}

@doc("Realization details for a specific region.")
model Realization {
  @doc("Stable RP-generated identifier for diagnostics.")
  id: string;

  @doc("Canonical Azure region name.")
  region: Azure.Core.azureLocation;

  @doc("Realization-specific state.")
  state?: RealizationState;

  @doc("Partition realization details.")
  @identifiers(#["name"])
  partitions?: Partition[];

  @doc("Instance realization details.")
  @identifiers(#["id"])
  instances?: Instance[];

  @doc("Effective networking configuration applied by the RP for this region.")
  networking?: TopologyLocation;
}

@doc("Partition label present in this realization.")
model Partition {
  @doc("The partition name.")
  name: string;
}

@doc("Operational instance within a realization.")
model Instance {
  @doc("The instance identifier.")
  id: string;

  @doc("The partition this instance belongs to.")
  partition: string;

  @doc("Legacy routing partition metadata preserved for migration parity.")
  routingPartition?: string;

  @doc("The ARM resource ID of the cluster backing this instance.")
  clusterResourceId?: Azure.Core.armResourceIdentifier;

  @doc("The provisioning status of this instance on the backing cluster.")
  status?: InstanceProvisioningStatus;

  @doc("Identities applied to this instance. Each entry's identityType distinguishes pod vs workload.")
  @visibility(Lifecycle.Read)
  @identifiers(#["clientId"])
  identities?: InstanceIdentity[];
}

// --- Identity model --------------------------------------------------

@doc("The kind of managed identity exposed on an Instance.")
union InstanceIdentityType {
  @doc("Pod identity used by namespace pods (sourced from the placement's ring-level identity).")
  Pod: "Pod",

  @doc("Workload (federated) identity (sourced from the placement's cluster-level identity).")
  Workload: "Workload",

  string,
}

@doc("User-assigned managed identity exposed on an Instance.")
model InstanceIdentity {
  @doc("The kind of identity (Pod or Workload).")
  identityType: InstanceIdentityType;

  @doc("Client ID of the user-assigned managed identity.")
  clientId: string;

  @doc("ARM resource ID of the user-assigned managed identity.")
  resourceId?: Azure.Core.armResourceIdentifier;

  @doc("Principal (object) ID of the user-assigned managed identity. Matches ARM common-types UserAssignedIdentity.principalId.")
  principalId: string;
}

// --- Networking models -----------------------------------------------

@doc("Azure public-IP tag types. Extensible - new values may be added without a breaking change.")
union IpTagType {
  @doc("Routing preference for the IP (Internet, Microsoft, etc.).")
  RoutingPreference: "RoutingPreference",

  @doc("First-party Azure service usage tag.")
  FirstPartyUsage: "FirstPartyUsage",

  string,
}

@doc("Ingress public IP configuration using BYOIP.")
model IngressPublicIp {
  @doc("The IP tag type for ingress.")
  ipTagType: IpTagType;

  @doc("The IP tag value for ingress.")
  ipTagValue: string;

  @doc("Names associated with this ingress IP configuration.")
  names?: string[];

  @doc("The IP version (IPv4 or IPv6). Defaults to IPv4.")
  ipVersion?: IpVersion;
}

@doc("Egress public IP configuration using BYOIP.")
model EgressPublicIps {
  @doc("The IP tag type for egress.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  ipTagType?: IpTagType;

  @doc("The IP tag value for egress.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  ipTagValue?: string;

  @doc("The IP capacity for egress.")
  @pattern("^(2|4|8|16)$")
  ipCapacity?: string;

  @doc("The IP version (IPv4 or IPv6). Defaults to IPv4.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  ipVersion?: IpVersion;
}

@doc("BYOIP configuration for instance-level public IP (ILPIP).")
model InstanceLevelPublicIp {
  @doc("Prefix length of the IP block.")
  @minValue(0)
  @maxValue(128)
  @visibility(Lifecycle.Create, Lifecycle.Read)
  prefixLength?: int32;

  @doc("The IP tag type.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  ipTagType?: IpTagType;

  @doc("The IP tag value.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  ipTagValue?: string;

  @doc("The IP version (IPv4 or IPv6). Defaults to IPv4.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  ipVersion?: IpVersion;
}
