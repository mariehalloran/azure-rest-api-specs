import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

namespace Microsoft.SecurityBasePlatform;

interface Operations extends Azure.ResourceManager.Operations {}

@doc("The status of the current operation.")
@Azure.Core.lroStatus
union ProvisioningState {
  Azure.ResourceManager.ResourceProvisioningState,

  @doc("Resource is being provisioned.")
  Provisioning: "Provisioning",

  @doc("Resource is being updated.")
  Updating: "Updating",

  @doc("Resource is being deleted.")
  Deleting: "Deleting",

  @doc("Resource creation request has been accepted.")
  Accepted: "Accepted",
}

@doc("Configuration of the managed resource group associated with the resource.")
model ManagedResourceGroupConfiguration {
  @doc("The resource group name.")
  @visibility(Lifecycle.Read)
  name?: string;

  @doc("The resource group location.")
  @visibility(Lifecycle.Read)
  location?: string;
}
