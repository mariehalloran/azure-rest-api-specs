import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

namespace Microsoft.FoundryLocal;

@doc("A ModelDeployment resource managed via K8sBridge on an Arc-connected cluster.")
model ModelDeployment is TrackedResource<ModelDeploymentProperties> {
  ...ResourceNameParameter<
    ModelDeployment,
    NamePattern = "^[a-z]([a-z0-9]*(-[a-z0-9]+)*)?$"
  >;
  ...ExtendedLocationProperty;
}

@doc("Properties of a ModelDeployment resource.")
model ModelDeploymentProperties {
  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque configurationSettings"
  @doc("Configuration settings as name-value pairs for the model deployment.")
  configurationSettings?: Record<string>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque configurationProtectedSettings"
  @doc("Configuration settings that are sensitive, as name-value pairs. Write-only — never returned on GET.")
  @secret
  configurationProtectedSettings?: Record<string>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque status"
  @doc("Read-only status of the model deployment reported from the cluster.")
  @visibility(Lifecycle.Read)
  status?: Record<string>;
}

@armResourceOperations
interface ModelDeployments {
  get is ArmResourceRead<ModelDeployment>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ModelDeployment>;
  delete is ArmResourceDeleteWithoutOkAsync<ModelDeployment>;
  update is ArmResourcePatchAsync<ModelDeployment, ModelDeploymentProperties>;
  listByResourceGroup is ArmResourceListByParent<ModelDeployment>;
  listBySubscription is ArmListBySubscription<ModelDeployment>;
}
