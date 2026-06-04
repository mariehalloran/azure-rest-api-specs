import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

namespace Microsoft.FoundryLocal;

@doc("Provisioning state of a ModelDeployment resource.")
union ProvisioningState {
  ResourceProvisioningState,

  @doc("The resource request has been accepted for processing.")
  Accepted: "Accepted",

  @doc("The resource is being provisioned.")
  Provisioning: "Provisioning",

  @doc("The resource is being deleted.")
  Deleting: "Deleting",

  string,
}

@doc("A ModelDeployment resource managed via K8sBridge on an Arc-connected cluster.")
model ModelDeployment is TrackedResource<ModelDeploymentProperties> {
  ...ResourceNameParameter<
    ModelDeployment,
    NamePattern = "^[a-z]([a-z0-9]*(-[a-z0-9]+)*)?$"
  >;
  ...RequiredExtendedLocationProperty;
}

@doc("Model representing the required `extendedLocation` envelope property for this Arc-only resource.")
model RequiredExtendedLocationProperty {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Arc-only resource requires extendedLocation in the resource envelope (Extended Locations §18)."
  @doc("The Arc-enabled cluster extended location where this model deployment runs.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  extendedLocation: Foundations.ExtendedLocation;
}

@doc("Properties of a ModelDeployment resource.")
model ModelDeploymentProperties {
  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque configurationSettings"
  @doc("Configuration settings as name-value pairs for the model deployment.")
  configurationSettings?: Record<string>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque configurationProtectedSettings"
  @doc("Configuration settings that are sensitive, as name-value pairs.")
  @secret
  @visibility(Lifecycle.Create, Lifecycle.Update)
  configurationProtectedSettings?: Record<string>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque status"
  @doc("Read-only status of the model deployment reported from the cluster.")
  @visibility(Lifecycle.Read)
  status?: Record<string>;
}

@doc("Updatable properties of a ModelDeployment resource.")
model ModelDeploymentPatchProperties {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque configurationSettings"
  @doc("Configuration settings as name-value pairs for the model deployment.")
  configurationSettings?: Record<string>;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Extensions pattern uses Record<string> for opaque configurationProtectedSettings"
  @doc("Configuration settings that are sensitive, as name-value pairs.")
  @secret
  @visibility(Lifecycle.Create, Lifecycle.Update)
  configurationProtectedSettings?: Record<string>;
}

@armResourceOperations
interface ModelDeployments {
  get is ArmResourceRead<ModelDeployment>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ModelDeployment>;
  delete is ArmResourceDeleteWithoutOkAsync<
    ModelDeployment,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, ModelDeployment> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  update is ArmCustomPatchAsync<
    ModelDeployment,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      ModelDeployment,
      ModelDeploymentPatchProperties
    >,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, ModelDeployment> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  listByResourceGroup is ArmResourceListByParent<ModelDeployment>;
  listBySubscription is ArmListBySubscription<ModelDeployment>;
}
