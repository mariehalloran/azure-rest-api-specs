import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ContainerSite.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.ApplicationMigration;

/**
 * The ContainerNode resource — proxy resource under ContainerSite.
 * Created for BOTH orchestrated nodes (K8s/Swarm) and standalone container hosts (Docker/Podman).
 * Provides full node/host detail (labels, taints, OS info, runtime, capacity, GPU, hypervisor,
 * conditions, annotations) for portal drill-down and detailed migration planning.
 * Linked to parent cluster via containerClusterId property (empty for standalone hosts).
 */
@parentResource(ContainerSite)
model ContainerNode is Azure.ResourceManager.ProxyResource<
  ContainerNodeProperties,
  false
> {
  ...ResourceNameParameter<
    Resource = ContainerNode,
    KeyName = "nodeName",
    SegmentName = "containerNodes",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  >;
}

/**
 * ContainerNode properties — full node detail.
 */
model ContainerNodeProperties is AzureResourceProperties {
  // ── Node Identity ──
  @doc("Whether this is a standalone container host (no orchestrator).")
  isStandaloneHost?: boolean;

  @doc("ARM resource ID of the parent cluster. Empty for standalone hosts.")
  clusterArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ApplicationMigration/containerSites/containerClusters";
    }
  ]>;

  @doc("Cluster ID.") containerClusterId?: string;
  @doc("Parent cluster name.") parentClusterName?: string;
  @doc("Unique node identifier.") containerNodeId?: string;
  @doc("Node display name.") nodeDisplayName?: string;
  @doc("Node role.") nodeRole?: NodeRole;

  @doc("ARM resource ID of the underlying VM.")
  machineArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OffAzure/serverSites/machines";
    },
    {
      type: "Microsoft.OffAzure/vmwareSites/machines";
    },
    {
      type: "Microsoft.OffAzure/hyperVSites/machines";
    }
  ]>;

  @doc("Azure Migrate internal host GUID for Kusto correlation.")
  hostId?: string;

  @doc("Fully qualified domain name of the host.") hostFqdn?: string;
  @doc("Primary IP address of the host.") hostPrimaryIp?: string;
  @doc("Node availability status.") availability?: NodeAvailability;

  // ── Workload Linkage (reverse edge) ──
  @doc("Resource names of the container workloads scheduled on this node.")
  containerWorkloadIds?: string[];

  // ── Software & Discovery Metadata ──
  @doc("Software attributes.") softwareAttributes?: SoftwareAttributes;

  @doc("Support status.") supportStatus?: SupportStatus;
  @doc("End of support date.") endOfSupportDate?: plainDate;
  @doc("Discovery source.") discoverySource?: string;
  @doc("Appliance name.") applianceName?: string;

  // ── Discovery Metadata ──
  @doc("Discovery completeness level.")
  discoveryCompleteness?: DiscoveryCompleteness;

  @doc("Whether shallow discovery has completed.") isShallowCompleted?: boolean;

  @doc("Whether deep discovery has completed.")
  isDeepDiscoveryCompleted?: boolean;

  @doc("Whether kubeconfig-based discovery has completed.")
  isKubeconfigDiscoveryCompleted?: boolean;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Tags are dynamic key-value pairs"
  @doc("Resource tags as key-value pairs.")
  tags?: Record<string>;

  // ── Host OS Details ──
  @doc("Host OS details.") hostOs?: HostOsProperties;

  // ── Container Runtimes (full detail) ──
  @doc("Full container runtime details.")
  @identifiers(#[])
  containerRuntimes?: ContainerRuntimeDetails[];

  // ── Orchestrator Agent ──
  @doc("Orchestrator agent details.")
  orchestratorAgent?: OrchestratorAgentProperties;

  // ── Node Capacity (full) ──
  @doc("Full node capacity details.") nodeCapacity?: FullNodeCapacity;

  // ── GPU ──
  @doc("GPU hardware details for the node, including model and count.")
  gpu?: GpuProperties;

  // ── Hypervisor ──
  @doc("Hypervisor details detected on the node, if virtualized.")
  hypervisor?: HypervisorProperties;

  // ── Labels, Taints, Conditions, Annotations ──
  @doc("Full node labels as key-value pairs.")
  @identifiers(#[])
  nodeLabels?: KeyValuePair[];

  @doc("Full node taints.")
  nodeTaints?: string[];

  @doc("Node health conditions.")
  @identifiers(#[])
  nodeConditions?: NodeCondition[];

  @doc("Node annotations as key-value pairs.")
  @identifiers(#[])
  nodeAnnotations?: KeyValuePair[];

  // ── Errors ──
  @doc("Discovery errors.")
  @identifiers(#[])
  errors?: ContainerDiscoveryError[];

  @doc("The number of critical errors.") criticalErrorCount?: int64;
  @doc("The number of warnings.") warningsCount?: int64;
}

/**
 * Patch envelope for ContainerNode.
 */
model ContainerNodePatchProperties {
  @doc("Container node patch properties.")
  properties?: ContainerNodePatch;
}

/**
 * Patch properties for ContainerNode.
 */
model ContainerNodePatch {
  // ── Cluster Linkage ──
  // Patchable so the service can backfill node→cluster linkage with a sparse,
  // concurrency-safe PATCH after cluster composition, without a read-modify-write PUT.
  @doc("Whether this is a standalone container host (no orchestrator).")
  isStandaloneHost?: boolean;

  @doc("ARM resource ID of the parent cluster. Empty for standalone hosts.")
  clusterArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ApplicationMigration/containerSites/containerClusters";
    }
  ]>;

  @doc("Parent cluster name.") parentClusterName?: string;
  @doc("Node display name.") nodeDisplayName?: string;
  @doc("Node role.") nodeRole?: NodeRole;
  @doc("Node availability status.") availability?: NodeAvailability;
  @doc("Fully qualified domain name of the host.") hostFqdn?: string;
  @doc("Primary IP address of the host.") hostPrimaryIp?: string;
  @doc("Software attributes.") softwareAttributes?: SoftwareAttributes;
  @doc("Support status.") supportStatus?: SupportStatus;
  @doc("End of support date.") endOfSupportDate?: plainDate;

  @doc("Discovery completeness level.")
  discoveryCompleteness?: DiscoveryCompleteness;

  @doc("Whether shallow discovery has completed.") isShallowCompleted?: boolean;

  @doc("Whether deep discovery has completed.")
  isDeepDiscoveryCompleted?: boolean;

  @doc("Whether kubeconfig-based discovery has completed.")
  isKubeconfigDiscoveryCompleted?: boolean;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Tags are dynamic key-value pairs"
  @doc("Resource tags as key-value pairs.")
  tags?: Record<string>;

  @doc("Host OS details.") hostOs?: HostOsProperties;

  @doc("Container runtimes.")
  @identifiers(#[])
  containerRuntimes?: ContainerRuntimeDetails[];

  @doc("Orchestrator agent details.")
  orchestratorAgent?: OrchestratorAgentProperties;

  @doc("Full node capacity details.") nodeCapacity?: FullNodeCapacity;

  @doc("GPU hardware details for the node, including model and count.")
  gpu?: GpuProperties;

  @doc("Hypervisor details detected on the node, if virtualized.")
  hypervisor?: HypervisorProperties;

  @doc("Full node labels as key-value pairs.")
  @identifiers(#[])
  nodeLabels?: KeyValuePair[];

  @doc("Full node taints.") nodeTaints?: string[];

  @doc("Node health conditions.")
  @identifiers(#[])
  nodeConditions?: NodeCondition[];

  @doc("Node annotations as key-value pairs.")
  @identifiers(#[])
  nodeAnnotations?: KeyValuePair[];

  @doc("Discovery errors.")
  @identifiers(#[])
  errors?: ContainerDiscoveryError[];

  @doc("The number of critical errors.") criticalErrorCount?: int64;
  @doc("The number of warnings.") warningsCount?: int64;
}

@armResourceOperations
interface ContainerNodes {
  get is ArmResourceRead<ContainerNode>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<ContainerNode>;
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<ContainerNode, ContainerNodePatchProperties>;
  delete is ArmResourceDeleteSync<ContainerNode>;
  listBySite is ArmResourceListByParent<
    ContainerNode,
    Response = ArmResponse<ContainerNodeList>
  >;
}

@@maxLength(ContainerNode.name, 253);
@@minLength(ContainerNode.name, 1);
@@doc(ContainerNode.name, "The node identifier.");
@@doc(ContainerNode.properties, "Container node properties.");
@@doc(
  ContainerNodes.createOrUpdate::parameters.resource,
  "The container node resource to create or update."
);
@@doc(
  ContainerNodes.update::parameters.properties,
  "Container node patch payload."
);
