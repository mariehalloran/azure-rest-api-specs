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

@doc("Observed lifecycle phase of a model deployment on the cluster.")
union ModelDeploymentPhase {
  @doc("The deployment has been accepted by the cluster but not yet scheduled.")
  Pending: "Pending",

  @doc("The deployment is being created on the cluster.")
  Creating: "Creating",

  @doc("The deployment is in the operational phase. Detailed readiness is reported via conditions.")
  Running: "Running",

  @doc("The deployment is being updated.")
  Updating: "Updating",

  @doc("The deployment has encountered an error.")
  Error: "Error",

  @doc("The deployment is being terminated.")
  Terminating: "Terminating",

  string,
}

@doc("Standard Kubernetes-style condition type for a model deployment.")
union ModelDeploymentConditionType {
  @doc("Whether the deployment is currently available and serving traffic.")
  Available: "Available",

  @doc("Whether the deployment is currently being rolled out.")
  Progressing: "Progressing",

  @doc("Whether the deployment is in a degraded state.")
  Degraded: "Degraded",

  string,
}

@doc("Standard Kubernetes-style condition status.")
union ModelDeploymentConditionStatus {
  @doc("The condition is currently true.")
  True: "True",

  @doc("The condition is currently false.")
  False: "False",

  @doc("The current condition status is unknown.")
  Unknown: "Unknown",

  string,
}

@doc("Detailed status condition reported for a model deployment.")
model ModelDeploymentCondition {
  @doc("Condition type.")
  type: ModelDeploymentConditionType;

  @doc("Condition status.")
  status: ModelDeploymentConditionStatus;

  @doc("Machine-readable reason for the condition's last transition.")
  reason?: string;

  @doc("Human-readable message describing the condition.")
  message?: string;

  @doc("Timestamp of the last transition for this condition.")
  lastTransitionTime?: utcDateTime;
}

@doc("Identifies the specific model variant the cluster resolved and deployed.")
model ResolvedModel {
  @doc("Resolved model identifier (catalog name) on the cluster.")
  name?: string;

  @doc("Selected variant identifier within the model (e.g., 'cpu-fp16', 'gpu-int8').")
  variant?: string;

  @doc("Container image deployed by the cluster.")
  image?: string;
}

@doc("Observed status of a model deployment as reported by the cluster.")
model ModelDeploymentStatus {
  @doc("Current lifecycle phase of the deployment on the cluster.")
  phase?: ModelDeploymentPhase;

  @doc("Latest human-readable status message.")
  message?: string;

  @doc("Inference endpoint URL exposed by the deployment, once ready.")
  endpointUrl?: url;

  @doc("Number of replicas currently in the Ready condition.")
  @minValue(0)
  readyReplicas?: int32;

  @doc("Latest condition states reported by the cluster.")
  @identifiers(#["type"])
  conditions?: ModelDeploymentCondition[];

  @doc("Information about the model variant the cluster resolved and deployed for this request.")
  resolvedModel?: ResolvedModel;

  @doc("Timestamp when the cluster last refreshed this status block.")
  lastObservedAt?: utcDateTime;
}

@doc("A model deployment running on an Azure Arc-enabled Kubernetes cluster.")
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

  @doc("Observed status of the model deployment as reported by the cluster.")
  @visibility(Lifecycle.Read)
  status?: ModelDeploymentStatus;
}

@doc("The type used for update operations of the ModelDeployment.")
model ModelDeploymentUpdate {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Standard ARM resource tags are modeled as Record<string>."
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("The resource-specific properties for this resource.")
  properties?: ModelDeploymentUpdateProperties;
}

@doc("The updatable properties of the ModelDeployment.")
model ModelDeploymentUpdateProperties {
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
    ModelDeploymentUpdate,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, ModelDeployment> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  listByResourceGroup is ArmResourceListByParent<ModelDeployment>;
  listBySubscription is ArmListBySubscription<ModelDeployment>;
}
