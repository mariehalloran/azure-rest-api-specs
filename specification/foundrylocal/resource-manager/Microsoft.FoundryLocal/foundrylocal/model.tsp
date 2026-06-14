import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

namespace Microsoft.FoundryLocal;

@doc("Lifecycle phase of a Model resource as observed by the cluster.")
union ModelPhase {
  @doc("The model is being prepared on the cluster (e.g. credentials being resolved, manifest being fetched).")
  Pending: "Pending",

  @doc("The model is available for use by deployments.")
  Available: "Available",

  @doc("The model has encountered an error.")
  Error: "Error",

  string,
}

@doc("Standard Kubernetes-style condition type for a Model.")
union ModelConditionType {
  @doc("Whether the model is currently available for use by deployments.")
  Available: "Available",

  string,
}

@doc("Detailed status condition reported for a Model.")
model ModelCondition {
  @doc("Condition type.")
  type: ModelConditionType;

  @doc("Condition status.")
  status: ModelDeploymentConditionStatus;

  @doc("Machine-readable reason for the condition's last transition.")
  reason?: string;

  @doc("Human-readable message describing the condition.")
  message?: string;

  @doc("Timestamp of the last transition for this condition.")
  lastTransitionTime?: utcDateTime;
}

@doc("Observed status of a Model as reported by the cluster.")
model ModelStatus {
  @doc("Current lifecycle phase of the model on the cluster.")
  phase?: ModelPhase;

  @doc("Latest human-readable status message.")
  message?: string;

  @doc("Latest condition states reported by the cluster.")
  @identifiers(#["type"])
  conditions?: ModelCondition[];

  @doc("Timestamp when the cluster last refreshed this status block.")
  lastObservedAt?: utcDateTime;
}

@doc("Reference to a Kubernetes Secret holding registry credentials. The secret must exist in either the target deployment namespace or the operator's release namespaces.")
model SecretReference {
  @doc("Name of the Kubernetes Secret.")
  @minLength(1)
  @maxLength(253)
  name: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "Key NAMES (not secret values) in the referenced Kubernetes Secret."
  @doc("Key in the secret that holds the username. Defaults to 'username'.")
  usernameKey?: string = "username";

  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "Key NAMES (not secret values) in the referenced Kubernetes Secret."
  @doc("Key in the secret that holds the password. Defaults to 'password'.")
  passwordKey?: string = "password";
}

@doc("Discriminator for the kind of registry credentials used to pull a custom model image.")
union RegistryCredentialsKind {
  @doc("Credentials are stored in a pre-existing Kubernetes Secret on the target cluster.")
  KubernetesSecretRef: "KubernetesSecretRef",

  string,
}

@doc("Registry authentication credentials for pulling a custom model image. Exactly one variant is used per Model, indicated by `kind`.")
@discriminator("kind")
model RegistryCredentials {
  @doc("Discriminator: which credentials shape is in use.")
  kind: RegistryCredentialsKind;
}

@doc("Credentials stored in a Kubernetes Secret that already exists in the same namespace as the model on the cluster.")
model KubernetesSecretCredentials extends RegistryCredentials {
  kind: RegistryCredentialsKind.KubernetesSecretRef;

  @doc("Reference to the Kubernetes Secret containing registry credentials.")
  secretRef: SecretReference;
}

@doc("Custom model source description. Points at a container image in a registry.")
model CustomModelSource {
  @doc("Container registry URL, e.g. 'myacr.azurecr.io'.")
  @minLength(1)
  @maxLength(253)
  registry: string;

  @doc("Repository path within the registry, e.g. 'models/my-custom-model'.")
  @minLength(1)
  @maxLength(253)
  repository: string;

  @doc("Image or artifact tag.")
  @minLength(1)
  @maxLength(128)
  tag: string;

  @doc("Registry authentication credentials.")
  credentials: RegistryCredentials;
}

@doc("Source description for a Model. v1 supports only custom (user-provided) sources.")
model ModelSource {
  @doc("Custom model source from a container registry.")
  custom: CustomModelSource;
}

@doc("Supported compute types for a Model variant.")
union ComputeType {
  @doc("CPU compute.")
  Cpu: "Cpu",

  @doc("GPU compute.")
  Gpu: "Gpu",

  string,
}

@doc("A hardware-specific variant of a Model.")
model ModelVariant {
  @doc("Variant identifier, unique within the model.")
  @minLength(1)
  @maxLength(253)
  id: string;

  @doc("Compute type this variant targets.")
  compute: ComputeType;

  @doc("Optional ONNX Runtime execution provider, e.g. 'CUDAExecutionProvider'.")
  @maxLength(64)
  executionProvider?: string;

  @doc("Optional model file size in bytes.")
  @minValue(0)
  fileSizeBytes?: int64;

  @doc("Selection priority for this variant. Lower values are preferred. Defaults to 50.")
  @minValue(1)
  @maxValue(100)
  priority?: int32 = 50;
}

@doc("Resource requirements for a Model.")
model ModelRequirements {
  @doc("Minimum system RAM required, e.g. '2Gi'.")
  minMemory?: string;

  @doc("Minimum GPU VRAM required, e.g. '4Gi'.")
  minVram?: string;

  @doc("Compute types this model supports.")
  supportedCompute?: ComputeType[];
}

@doc("Declared capabilities of a Model.")
model ModelCapabilities {
  @doc("Model task type, e.g. 'chat-completion', 'text-generation'.")
  @maxLength(64)
  task?: string;

  @doc("Maximum context window size supported by the model.")
  @minValue(1)
  contextLength?: int32;

  @doc("Whether the model supports streaming responses. Defaults to false.")
  streaming?: boolean = false;
}

@doc("Properties of a Model resource.")
model ModelProperties {
  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @doc("Source describing where the model artifacts come from.")
  source: ModelSource;

  @doc("Human-readable model name shown in tooling.")
  @maxLength(256)
  displayName?: string;

  @doc("Long-form description of the model.")
  @maxLength(1024)
  description?: string;

  @doc("Model publisher or author.")
  @maxLength(128)
  publisher?: string;

  @doc("SPDX-style license identifier, e.g. 'Apache-2.0', 'MIT'.")
  @maxLength(64)
  license?: string;

  @doc("URL to the full license text.")
  @maxLength(512)
  licenseUrl?: url;

  @doc("Hardware-specific model variants, used by deployments to select the right artifact for their compute type.")
  @identifiers(#["id"])
  variants?: ModelVariant[];

  @doc("Resource requirements for the model.")
  requirements?: ModelRequirements;

  @doc("Declared capabilities of the model.")
  capabilities?: ModelCapabilities;

  @doc("Observed status of the model as reported by the cluster.")
  @visibility(Lifecycle.Read)
  status?: ModelStatus;
}

@doc("A Model registered on an Azure Arc-enabled Kubernetes cluster. Models are reusable artifacts that one or more ModelDeployments can reference.")
model Model is TrackedResource<ModelProperties> {
  ...ResourceNameParameter<
    Model,
    NamePattern = "^[a-z]([a-z0-9]*(-[a-z0-9]+)*)?$"
  >;
  ...RequiredExtendedLocationProperty;
}

@doc("The type used for update operations of the Model.")
model ModelUpdate {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Standard ARM resource tags are modeled as Record<string>."
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("The resource-specific properties for this resource.")
  properties?: ModelUpdateProperties;
}

@doc("The updatable properties of the Model. The model source is immutable post-create; metadata, variants, requirements, and capabilities can be updated.")
model ModelUpdateProperties {
  @doc("Human-readable model name shown in tooling.")
  @maxLength(256)
  displayName?: string;

  @doc("Long-form description of the model.")
  @maxLength(1024)
  description?: string;

  @doc("Model publisher or author.")
  @maxLength(128)
  publisher?: string;

  @doc("SPDX-style license identifier.")
  @maxLength(64)
  license?: string;

  @doc("URL to the full license text.")
  @maxLength(512)
  licenseUrl?: url;

  @doc("Hardware-specific model variants.")
  @identifiers(#["id"])
  variants?: ModelVariant[];

  @doc("Resource requirements for the model.")
  requirements?: ModelRequirements;

  @doc("Declared capabilities of the model.")
  capabilities?: ModelCapabilities;
}

@armResourceOperations
interface Models {
  get is ArmResourceRead<Model>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Model>;
  delete is ArmResourceDeleteWithoutOkAsync<
    Model,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, Model> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  update is ArmCustomPatchAsync<
    Model,
    ModelUpdate,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, Model> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  listByResourceGroup is ArmResourceListByParent<Model>;
  listBySubscription is ArmListBySubscription<Model>;
}
