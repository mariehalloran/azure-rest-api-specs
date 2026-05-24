import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

@armProviderNamespace
@service(#{ title: "ZeroTrustSegmentationClient" })
@versioned(Versions)
@doc("ZeroTrustSegmentation resource provider API.")
namespace Microsoft.ZeroTrustSegmentation;

/** ZeroTrustSegmentation API versions */
enum Versions {
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  v2025_02_01_preview: "2025-02-01-preview",

  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  v2025_07_01_preview: "2025-07-01-preview",

  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_01_01_preview: "2026-01-01-preview",
}

@doc("A zero trust segmentation resource. this resource defines the SegmentationManager.")
model SegmentationManager is TrackedResource<SegmentationManagerProperties> {
  @doc("Name of the segmentation manager")
  @key("segmentationManagerName")
  @pattern("^[a-zA-Z0-9-]{3,250}$")
  @path
  @segment("segmentationManagers")
  name: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Adding property for versioning"
  @added(Versions.v2025_07_01_preview)
  @doc("The managed service identities assigned to this resource.")
  identity?: SegmentationManagerManagedServiceIdentity;
}

@added(Versions.v2025_07_01_preview)
@doc("Managed service identity for the segmentation manager.")
model SegmentationManagerManagedServiceIdentity {
  @doc("The type of managed service identity.")
  type: SegmentationManagerManagedServiceIdentityType;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Following ARM pattern for user assigned identities"
  @doc("The user assigned identities associated with the resource.")
  userAssignedIdentities?: Record<Azure.ResourceManager.CommonTypes.UserAssignedIdentity | null>;
}

@added(Versions.v2025_07_01_preview)
@doc("The type of managed service identity.")
union SegmentationManagerManagedServiceIdentityType {
  @doc("No managed identity is assigned to this resource.")
  "None",

  @doc("User Assigned Managed Identity")
  "UserAssigned",

  string,
}

@doc("Segmentation manager properties")
model SegmentationManagerProperties {
  @doc("The collection of ARM resource IDs for the monitored logs.")
  logSources: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Network/networkWatchers/flowLogs";
    }
  ]>[];

  @doc("The analysis run type")
  analysisRunType: AnalysisRunType;

  @doc("The start time of a snapshot run")
  startTime?: utcDateTime;

  @doc("The end time of a snapshot run")
  endTime?: utcDateTime;

  @doc("The mode of segmentation to be applied")
  segmentationMode: SegmentationMode;

  @doc("The description of the segmentation manager")
  description?: string;

  ...DefaultProvisioningStateProperty;
  ...ManagedByProperty;
}

@added(Versions.v2026_01_01_preview)
@doc("A zero trust segmentation resource for API version 2026-01-01-preview.")
model SegmentationManagerV2026Preview
  is TrackedResource<SegmentationManagerPropertiesV2026Preview> {
  @doc("Name of the segmentation manager")
  @key("segmentationManagerName")
  @pattern("^[a-zA-Z0-9-]{3,250}$")
  @path
  @segment("segmentationManagers")
  name: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Adding property for versioning"
  @doc("The managed service identities assigned to this resource.")
  identity?: SegmentationManagerManagedServiceIdentity;

  ...ManagedByProperty;
}

@added(Versions.v2026_01_01_preview)
@doc("Segmentation manager properties for API version 2026-01-01-preview.")
model SegmentationManagerPropertiesV2026Preview {
  @doc("The collection of Azure resource IDs that define the scope of the segmentation.")
  scope: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Network/virtualNetworks";
    }
  ]>[];

  @doc("Azure Resource ID of the Log Analytics Workspace where graph data will be stored")
  targetLogAnalyticsWorkspaceId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OperationalInsights/workspaces";
    }
  ]>;

  @doc("Managed-On-Behalf-Of configuration.")
  @visibility(Lifecycle.Read)
  managedOnBehalfOfConfiguration?: CommonTypes.ManagedOnBehalfOfConfiguration;

  @doc("The start time of a snapshot run")
  startTime?: utcDateTime;

  @doc("The end time of a snapshot run")
  endTime?: utcDateTime;

  @doc("The description of the segmentation manager")
  description?: string;

  @visibility(Lifecycle.Read)
  @doc("The provisioning state of the resource.")
  provisioningState?: SegmentationManagerProvisioningState;
}

@added(Versions.v2026_01_01_preview)
@doc("The provisioning state of a resource type.")
@Azure.Core.lroStatus
union SegmentationManagerProvisioningState {
  ResourceProvisioningState,

  @doc("Resource provisioning in progress.")
  Provisioning: "Provisioning",

  @doc("Resource deletion in progress.")
  Deleting: "Deleting",

  @doc("Resource provisioning request has been accepted.")
  Accepted: "Accepted",
}

@doc("Specifies the mode of segmentation to be applied.")
union SegmentationMode {
  string,

  @doc("No segmentation applied")
  None: "None",

  @doc("Automatic Mode")
  Automatic: "Automatic",
}

@doc("Analysis run type")
union AnalysisRunType {
  string,

  @doc("Single run")
  OneTime: "OneTime",

  @doc("Continuous run")
  Continuous: "Continuous",
}

@doc("Set label record")
model SetLabelRecord {
  @doc("IP address of the workload")
  ipAddress: string;

  @doc("MAC address of the workload")
  macAddress: string;

  @doc("Labels as key-value pairs")
  @identifiers(#[])
  labels?: LabelPair[];
}

@doc("Represent a label as key-value pair")
model LabelPair {
  @doc("Label key")
  key: string;

  @doc("Label value")
  value: string;
}

@doc("The request model for the SetLabels API")
model SetLabelsRequest {
  @doc("List of labels that need to be updated")
  @identifiers(#[])
  labels: SetLabelRecord[];
}

@doc("The request model for the GetGraph API")
model GetGraphRequest {
  @doc("The start time of the graph")
  startTime: utcDateTime;

  @doc("The end time of the graph")
  endTime: utcDateTime;
}

@doc("The response model for the GetGraph API")
model GetGraphResponse {
  @doc("Graph representation")
  graph: Graph;
}

@doc("Graph representation model")
model Graph {
  @doc("List of vertices in the graph")
  vertices: Vertex[];

  @doc("List of edges connecting the vertices in the graph")
  @identifiers(#[])
  edges: Edge[];

  @doc("Total weights for all edges in the graph")
  totalTrafficWeights: TotalTrafficWeights;
}

@doc("Vertex model representing a node in the network")
model Vertex {
  @doc("Unique identifier for the vertex")
  id: string;

  @doc("IP address of the vertex")
  ipAddress: string;

  @doc("MAC address of the vertex")
  macAddress: string;

  @doc("Geographical location of the vertex")
  location: string;

  @doc("Azure Resource Manager ID of the vertex")
  armId?: string;

  @doc("Name of the vertex")
  name?: string;

  @doc("Labels associated with the vertex as key-value pairs")
  @identifiers(#[])
  labels: LabelPair[];
}

@doc("Edge model representing a connection between two vertices")
model Edge {
  @doc("Source vertex ID")
  source: string;

  @doc("Target vertex ID")
  target: string;

  @doc("Timestamp of the edge in milliseconds since epoch")
  hourT: int64;

  @doc("Traffic weights associated with the edge")
  trafficWeights: TrafficWeights;
}

@doc("Total traffic weights for all edges in the graph")
model TotalTrafficWeights {
  @doc("Total incoming packets")
  totalInPackets: float32;

  @doc("Total incoming bytes")
  totalInBytes: float32;

  @doc("Total incoming connections")
  totalInConnections: float32;

  @doc("Total outgoing packets")
  totalOutPackets: float32;

  @doc("Total outgoing bytes")
  totalOutBytes: float32;

  @doc("Total outgoing connections")
  totalOutConnections: float32;
}

@doc("TrafficWeights model")
model TrafficWeights {
  @doc("Incoming packet weight as a percentage")
  inPacketWeight: float32;

  @doc("Incoming byte weight as a percentage")
  inByteWeight: float32;

  @doc("Incoming connection weight as a percentage")
  inConnectionWeight: float32;

  @doc("Outgoing packet weight as a percentage")
  outPacketWeight: float32;

  @doc("Outgoing byte weight as a percentage")
  outByteWeight: float32;

  @doc("Outgoing connection weight as a percentage")
  outConnectionWeight: float32;
}

interface Operations extends Azure.ResourceManager.Operations {}

@armResourceOperations
interface SegmentationManagers {
  // 2025 operations (available in 2025 API versions, removed in 2026).
  @sharedRoute
  @removed(Versions.v2026_01_01_preview)
  get is ArmResourceRead<SegmentationManager>;

  @list
  @sharedRoute
  @removed(Versions.v2026_01_01_preview)
  listByResourceGroup is ArmResourceListByParent<SegmentationManager>;

  @list
  @sharedRoute
  @removed(Versions.v2026_01_01_preview)
  listBySubscription is ArmListBySubscription<SegmentationManager>;

  @sharedRoute
  @removed(Versions.v2026_01_01_preview)
  createOrReplace is ArmResourceCreateOrReplaceSync<SegmentationManager>;

  @sharedRoute
  @removed(Versions.v2026_01_01_preview)
  update is ArmResourcePatchSync<
    SegmentationManager,
    SegmentationManagerProperties
  >;

  @sharedRoute
  @removed(Versions.v2026_01_01_preview)
  delete is ArmResourceDeleteSync<SegmentationManager>;

  @sharedRoute
  @removed(Versions.v2026_01_01_preview)
  setLabels is ArmResourceActionNoContentSync<
    SegmentationManager,
    SetLabelsRequest
  >;

  @removed(Versions.v2026_01_01_preview)
  getGraph is ArmResourceActionSync<
    SegmentationManager,
    GetGraphRequest,
    GetGraphResponse
  >;

  // 2026 operations (introduced in 2026-01-01-preview).
  @sharedRoute
  @renamedFrom(Versions.v2026_01_01_preview, "get")
  @added(Versions.v2026_01_01_preview)
  getAsync is ArmResourceRead<SegmentationManagerV2026Preview>;

  @list
  @sharedRoute
  @renamedFrom(Versions.v2026_01_01_preview, "listByResourceGroup")
  @added(Versions.v2026_01_01_preview)
  listByResourceGroupAsync is ArmResourceListByParent<SegmentationManagerV2026Preview>;

  @list
  @sharedRoute
  @renamedFrom(Versions.v2026_01_01_preview, "listBySubscription")
  @added(Versions.v2026_01_01_preview)
  listBySubscriptionAsync is ArmListBySubscription<SegmentationManagerV2026Preview>;

  @sharedRoute
  @renamedFrom(Versions.v2026_01_01_preview, "createOrReplace")
  @added(Versions.v2026_01_01_preview)
  createOrReplaceAsync is ArmResourceCreateOrReplaceAsync<SegmentationManagerV2026Preview>;

  @sharedRoute
  @renamedFrom(Versions.v2026_01_01_preview, "update")
  @added(Versions.v2026_01_01_preview)
  updateAsync is ArmResourcePatchAsync<
    SegmentationManagerV2026Preview,
    SegmentationManagerPropertiesV2026Preview
  >;

  @sharedRoute
  @renamedFrom(Versions.v2026_01_01_preview, "delete")
  @added(Versions.v2026_01_01_preview)
  deleteAsync is ArmResourceDeleteWithoutOkAsync<SegmentationManagerV2026Preview>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes" "Required to align with PostResponseCodes"
  @renamedFrom(Versions.v2026_01_01_preview, "setWorkloadSegments")
  @added(Versions.v2026_01_01_preview)
  @doc("Set segments for the provided workloads. This API can be used to update or remove workload segments.")
  setWorkloadSegmentsAsync is ArmResourceActionNoContentAsync<
    SegmentationManagerV2026Preview,
    SetWorkloadSegmentsRequest
  >;
}

@added(Versions.v2026_01_01_preview)
@doc("Set workload segment record")
model SetWorkloadSegmentRecord {
  @doc("The Azure resource ID of the workload to which the segment should be applied")
  workloadId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Compute/virtualMachines";
    },
    {
      type: "Microsoft.Compute/virtualMachineScaleSets";
    }
  ]>;

  @doc("Workload environment")
  environment?: string;

  @doc("Workload application")
  application?: string;

  @doc("Workload role")
  role?: string;
}

@added(Versions.v2026_01_01_preview)
@doc("The request model for the SetWorkloadSegments API.")
model SetWorkloadSegmentsRequest {
  @doc("List of workload segments that need to be updated")
  @identifiers(#["workloadId"])
  @maxItems(1500)
  workloadSegments: SetWorkloadSegmentRecord[];
}
