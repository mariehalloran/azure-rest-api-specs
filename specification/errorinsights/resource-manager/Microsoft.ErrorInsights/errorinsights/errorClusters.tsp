import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.ErrorInsights;

/** A cluster of similar error events (tenant-scoped, global resource). */
@tenantResource
model ErrorCluster is ProxyResource<ErrorClusterProperties> {
  /** The error cluster name. */
  @key("clusterName")
  @segment("errorClusters")
  @pattern("^[a-zA-Z0-9_-]{1,128}$")
  @path
  name: string;
}

/** Properties of an error cluster. */
model ErrorClusterProperties {
  /** Unique hash identifier for this cluster. */
  @visibility(Lifecycle.Read)
  clusterId: string;

  /** Error code associated with this cluster (e.g., GatewayTimeout). */
  @visibility(Lifecycle.Read)
  errorCode: string;

  /** Representative error message for this cluster. */
  @visibility(Lifecycle.Read)
  errorMessage?: string;

  /** Azure resource type associated with this cluster (e.g., Microsoft.Compute/virtualMachines). */
  @visibility(Lifecycle.Read)
  targetResourceType?: string;

  /** Number of error instances in this cluster. */
  @visibility(Lifecycle.Read)
  @minValue(0)
  memberCount: int32;

  /** When this cluster was first observed. */
  @visibility(Lifecycle.Read)
  firstSeen: utcDateTime;

  /** The provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: Azure.ResourceManager.ResourceProvisioningState;
}

@armResourceOperations
interface ErrorClusters {
  /** Get an error cluster. */
  get is ArmResourceRead<ErrorCluster>;
  /** List all error clusters. */
  list is ArmResourceListByParent<ErrorCluster>;
}
