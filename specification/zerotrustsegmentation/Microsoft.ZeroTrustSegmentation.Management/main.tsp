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
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_01_01_preview: "2026-01-01-preview",
}

@doc("Managed service identity for the segmentation manager.")
model SegmentationManagerManagedServiceIdentity {
  @doc("The type of managed service identity.")
  type: SegmentationManagerManagedServiceIdentityType;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Following ARM pattern for user assigned identities"
  @doc("The user assigned identities associated with the resource.")
  userAssignedIdentities?: Record<Azure.ResourceManager.CommonTypes.UserAssignedIdentity | null>;
}

@doc("The type of managed service identity.")
union SegmentationManagerManagedServiceIdentityType {
  @doc("No managed identity is assigned to this resource.")
  "None",

  @doc("User Assigned Managed Identity")
  "UserAssigned",

  string,
}

@doc("A zero trust segmentation resource.")
model SegmentationManager is TrackedResource<SegmentationManagerProperties> {
  @doc("Name of the segmentation manager")
  @key("segmentationManagerName")
  @pattern("^[a-zA-Z0-9-]{3,80}$")
  @path
  @segment("segmentationManagers")
  name: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Adding property for versioning"
  @doc("The managed service identities assigned to this resource.")
  identity: SegmentationManagerManagedServiceIdentity;

  ...ManagedByProperty;
}

@doc("Segmentation manager properties.")
model SegmentationManagerProperties {
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

  @visibility(Lifecycle.Read)
  @doc("The provisioning state of the resource.")
  provisioningState?: SegmentationManagerProvisioningState;
}

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

interface Operations extends Azure.ResourceManager.Operations {}

@armResourceOperations
interface SegmentationManagers {
  get is ArmResourceRead<SegmentationManager>;
  createOrReplace is ArmResourceCreateOrReplaceAsync<SegmentationManager>;
  update is ArmResourcePatchAsync<
    SegmentationManager,
    SegmentationManagerProperties
  >;
  delete is ArmResourceDeleteWithoutOkAsync<SegmentationManager>;

  @list
  listByResourceGroup is ArmResourceListByParent<SegmentationManager>;

  @list
  listBySubscription is ArmListBySubscription<SegmentationManager>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes" "Required to align with PostResponseCodes"
  @doc("Set segments for the provided workloads. This API can be used to update or remove workload segments.")
  setWorkloadSegments is ArmResourceActionNoContentAsync<
    SegmentationManager,
    SetWorkloadSegmentsRequest
  >;
}

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

@doc("The request model for the SetWorkloadSegments API.")
model SetWorkloadSegmentsRequest {
  @doc("List of workload segments that need to be updated")
  @identifiers(#["workloadId"])
  @maxItems(1500)
  workloadSegments: SetWorkloadSegmentRecord[];
}
