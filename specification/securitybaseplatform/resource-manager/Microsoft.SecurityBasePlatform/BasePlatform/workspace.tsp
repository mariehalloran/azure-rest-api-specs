import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./shared-models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.SecurityBasePlatform;

@doc("Azure Resource Manager resource ID of an Azure Container Registry.")
scalar ContainerRegistryResourceId
  extends Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ContainerRegistry/registries",
    }
  ]>;

@doc("Represents a Workspace - a lightweight organizational container for Cluster resources.")
model Workspace is TrackedResource<WorkspaceProperties> {
  @doc("The name of the Workspace.")
  @key("workspaceName")
  @segment("workspaces")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@doc("Properties of the Workspace.")
model WorkspaceProperties {
  @doc("The Service Tree ID associated with this workspace.")
  serviceTreeId?: string;

  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @visibility(Lifecycle.Read)
  @doc("Configuration of the managed resource group associated with the resource.")
  managedResourceGroupConfiguration?: ManagedResourceGroupConfiguration;

  @visibility(Lifecycle.Read)
  @doc("Managed On Behalf Of Configuration.")
  managedOnBehalfOfConfiguration?: CommonTypes.ManagedOnBehalfOfConfiguration;

  @visibility(Lifecycle.Read)
  @doc("The container registry provisioned for this workspace.")
  containerRegistry?: WorkspaceContainerRegistry;
}

@doc("The container registry provisioned for this workspace.")
model WorkspaceContainerRegistry {
  @doc("The login server host name of the Azure Container Registry.")
  @visibility(Lifecycle.Read)
  loginServer?: string;

  @doc("The name of the Azure Container Registry.")
  @visibility(Lifecycle.Read)
  name?: string;

  @doc("The Azure Resource Manager resource ID of the Azure Container Registry.")
  @visibility(Lifecycle.Read)
  resourceId?: ContainerRegistryResourceId;
}

@armResourceOperations(Workspace)
interface Workspaces {
  get is ArmResourceRead<Workspace>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Workspace>;
  update is ArmCustomPatchAsync<
    Workspace,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      Workspace,
      Update<WorkspaceProperties>
    >,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, Workspace> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  delete is ArmResourceDeleteWithoutOkAsync<
    Workspace,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  listByResourceGroup is ArmResourceListByParent<Workspace>;
  listBySubscription is ArmListBySubscription<Workspace>;
}
