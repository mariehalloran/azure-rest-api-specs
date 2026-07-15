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
 * The ContainerCluster resource — proxy resource representing a discovered container cluster.
 * Contains orchestrator info, network/storage profiles, cluster configuration, assessment signals,
 * node summary, and a slim nodes[] array. Child of ContainerSite.
 */
@parentResource(ContainerSite)
model ContainerCluster is Azure.ResourceManager.ProxyResource<
  ContainerClusterProperties,
  false
> {
  ...ResourceNameParameter<
    Resource = ContainerCluster,
    KeyName = "clusterName",
    SegmentName = "containerClusters",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  >;
}

/**
 * ContainerCluster properties.
 */
model ContainerClusterProperties is AzureResourceProperties {
  @doc("Slim node entries for assessment reads.")
  @identifiers(#[])
  nodes?: SlimNodeEntry[];

  @doc("Unique cluster identifier from orchestrator.")
  containerClusterId?: string;

  @doc("Human-readable cluster display name.") clusterDisplayName?: string;
  @doc("Software attributes.") softwareAttributes?: SoftwareAttributes;
  @doc("Software support status.") supportStatus?: SupportStatus;
  @doc("End of support date.") endOfSupportDate?: plainDate;
  @doc("Discovery source.") discoverySource?: string;
  @doc("Appliance name.") applianceName?: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Tags are dynamic key-value pairs"
  @doc("Resource tags.")
  tags?: Record<string>;

  // ── Discovery Metadata ──
  @doc("Discovery completeness level.")
  discoveryCompleteness?: DiscoveryCompleteness;

  @doc("Whether shallow discovery has completed.") isShallowCompleted?: boolean;

  @doc("Whether deep discovery has completed.")
  isDeepDiscoveryCompleted?: boolean;

  @doc("Container orchestrator details.") orchestrator?: OrchestratorProperties;

  @doc("Cluster-wide resource allocation.")
  clusterResources?: ClusterResources;

  @doc("Cluster network profile.")
  clusterNetworkProfile?: ClusterNetworkProfile;

  @doc("Cluster storage profile.") storageProfile?: StorageProfile;

  @doc("Cluster configuration and policies.")
  clusterConfiguration?: ClusterConfiguration;

  // ── Assessment Signals ──
  @doc("Deprecated K8s API usage.") deprecatedApiUsage?: DeprecatedApiUsage;

  @doc("Security assessment signals.") securityAssessment?: SecurityAssessment;

  @doc("Deployment assessment (Helm releases).")
  deploymentAssessment?: DeploymentAssessment;

  @doc("Sizing quality metrics.") sizingQuality?: SizingQuality;

  @doc("Storage assessment signals.")
  storageAssessment?: StorageAssessmentSignals;

  @doc("Network assessment signals.")
  networkAssessment?: NetworkAssessmentSignals;

  @doc("Whether control plane is tainted.") controlPlaneTainted?: boolean;
  @doc("Node summary counts.") nodeSummary?: NodeSummary;

  @doc("Workload controller type counts.")
  workloadControllerSummary?: WorkloadControllerSummary;

  @doc("Cluster capacity and utilization summary.")
  clusterCapacity?: ClusterCapacitySummary;

  @doc("Discovery and validation errors.")
  @identifiers(#[])
  errors?: ContainerDiscoveryError[];

  @doc("The number of critical errors.") criticalErrorCount?: int64;
  @doc("The number of warnings.") warningsCount?: int64;

  @doc("The number of informational messages.")
  informationalMessagesCount?: int64;
}

/**
 * Patch envelope for ContainerCluster.
 */
model ContainerClusterPatchProperties {
  @doc("Container cluster patch properties.")
  properties?: ContainerClusterPatch;
}

/**
 * Patch properties for ContainerCluster.
 */
model ContainerClusterPatch {
  @doc("Slim node entries.")
  @identifiers(#[])
  nodes?: SlimNodeEntry[];

  @doc("Software attributes.") softwareAttributes?: SoftwareAttributes;
  @doc("Software support status.") supportStatus?: SupportStatus;
  @doc("End of support date.") endOfSupportDate?: plainDate;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Tags are dynamic key-value pairs"
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("Discovery completeness level.")
  discoveryCompleteness?: DiscoveryCompleteness;

  @doc("Whether shallow discovery has completed.") isShallowCompleted?: boolean;

  @doc("Whether deep discovery has completed.")
  isDeepDiscoveryCompleted?: boolean;

  @doc("Orchestrator details.") orchestrator?: OrchestratorProperties;
  @doc("Cluster resources.") clusterResources?: ClusterResources;

  @doc("Cluster network profile.")
  clusterNetworkProfile?: ClusterNetworkProfile;

  @doc("Storage profile.") storageProfile?: StorageProfile;
  @doc("Cluster configuration.") clusterConfiguration?: ClusterConfiguration;
  @doc("Deprecated API usage.") deprecatedApiUsage?: DeprecatedApiUsage;
  @doc("Security assessment.") securityAssessment?: SecurityAssessment;
  @doc("Deployment assessment.") deploymentAssessment?: DeploymentAssessment;
  @doc("Sizing quality.") sizingQuality?: SizingQuality;
  @doc("Storage assessment.") storageAssessment?: StorageAssessmentSignals;
  @doc("Network assessment.") networkAssessment?: NetworkAssessmentSignals;
  @doc("Whether control plane is tainted.") controlPlaneTainted?: boolean;
  @doc("Node summary.") nodeSummary?: NodeSummary;

  @doc("Workload controller type counts.")
  workloadControllerSummary?: WorkloadControllerSummary;

  @doc("Cluster capacity and utilization summary.")
  clusterCapacity?: ClusterCapacitySummary;

  @doc("Discovery or processing errors for this cluster.")
  @identifiers(#[])
  errors?: ContainerDiscoveryError[];

  @doc("The number of critical errors.") criticalErrorCount?: int64;
  @doc("The number of warnings.") warningsCount?: int64;

  @doc("The number of informational messages.")
  informationalMessagesCount?: int64;
}

@armResourceOperations
interface ContainerClusters {
  get is ArmResourceRead<ContainerCluster>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<ContainerCluster>;
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    ContainerCluster,
    ContainerClusterPatchProperties
  >;
  delete is ArmResourceDeleteSync<ContainerCluster>;
  listBySite is ArmResourceListByParent<
    ContainerCluster,
    Response = ArmResponse<ContainerClusterList>
  >;
}

@@maxLength(ContainerCluster.name, 63);
@@minLength(ContainerCluster.name, 3);
@@doc(ContainerCluster.name, "The cluster identifier.");
@@doc(ContainerCluster.properties, "Container cluster properties.");
@@doc(
  ContainerClusters.createOrUpdate::parameters.resource,
  "The container cluster resource to create or update."
);
@@doc(
  ContainerClusters.update::parameters.properties,
  "Container cluster patch payload."
);
