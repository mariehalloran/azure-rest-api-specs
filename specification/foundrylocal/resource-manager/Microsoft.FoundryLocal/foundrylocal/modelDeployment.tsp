import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

namespace Microsoft.FoundryLocal;

// ----------------------------------------------------------------------------
// Shared envelope models
// ----------------------------------------------------------------------------

@doc("Provisioning state of a resource.")
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

@doc("Model representing the required `extendedLocation` envelope property for Arc-only resources in Microsoft.FoundryLocal.")
model RequiredExtendedLocationProperty {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Arc-only resources require extendedLocation in the resource envelope (Extended Locations §18)."
  @doc("The Arc-enabled cluster extended location where this resource runs. Required; immutable after create.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  extendedLocation: Foundations.ExtendedLocation;
}

// ----------------------------------------------------------------------------
// Status types
// ----------------------------------------------------------------------------

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

// ----------------------------------------------------------------------------
// Workload and runtime configuration
// ----------------------------------------------------------------------------

@doc("Type of inference workload served by a model deployment.")
union WorkloadType {
  @doc("Generative (LLM) workload.")
  Generative: "Generative",

  @doc("Predictive (classification/regression) workload. Requires a custom model.")
  Predictive: "Predictive",

  string,
}

@doc("Inference runtime engine that serves the model.")
union RuntimeType {
  @doc("ONNX Runtime GenAI engine.")
  OnnxGenai: "OnnxGenai",

  @doc("vLLM engine. Requires GPU compute.")
  Vllm: "Vllm",

  @doc("Models-as-a-Service router. Forwards inference requests to an external MaaS endpoint. Required when using the Maas model variant.")
  Maas: "Maas",

  string,
}

@doc("vLLM-specific runtime configuration. Relevant only when `runtime` is `Vllm`.")
model VllmConfig {
  @doc("Size of the model weight cache PVC in GiB. Cluster default is 100 if omitted.")
  @minValue(1)
  modelCacheStorageGi?: int32;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "vLLM engine arguments are passed through to the runtime; the set of valid keys depends on the vLLM version installed on the cluster, so the schema is intentionally extensible. Pending review at ARM modeling office hours pre-GA."
  @doc("vLLM engine preferences passed through to the runtime, e.g. `max_model_len`, `gpu_memory_utilization`. Keys and accepted values depend on the vLLM version installed on the cluster.")
  preferences?: Record<string>;
}

// ----------------------------------------------------------------------------
// Resource requirements, env, tolerations, endpoint
// ----------------------------------------------------------------------------

@doc("Minimum resource requests for the inference container.")
model ResourceRequests {
  @doc("CPU request, e.g. '100m', '0.5', '2'. Cluster default is '2000m' if omitted.")
  cpu?: string;

  @doc("Memory request, e.g. '256Mi', '1Gi'. Cluster default is '256Mi' if omitted.")
  memory?: string;
}

@doc("Maximum resource limits for the inference container.")
model ResourceLimits {
  @doc("CPU limit. Cluster default is '4000m' if omitted.")
  cpu?: string;

  @doc("Memory limit. Cluster default is '1Gi' if omitted.")
  memory?: string;

  @doc("Number of GPUs (nvidia.com/gpu) requested.")
  @minValue(0)
  @maxValue(8)
  gpu?: int32;
}

@doc("Resource requirements for the inference container.")
model ResourceRequirements {
  @doc("Minimum resources required.")
  requests?: ResourceRequests;

  @doc("Maximum resources allowed.")
  limits?: ResourceLimits;
}

@doc("Environment variable to set on the inference container.")
model EnvVar {
  @doc("Environment variable name.")
  @minLength(1)
  name: string;

  @doc("Environment variable value.")
  value: string;
}

@doc("Operator for a Kubernetes node taint toleration.")
union TolerationOperator {
  @doc("Toleration value must equal the taint value.")
  Equal: "Equal",

  @doc("Toleration matches any value (or the absence of a value).")
  Exists: "Exists",

  string,
}

@doc("Effect of a Kubernetes node taint to tolerate.")
union TolerationEffect {
  @doc("Pods will not be scheduled onto tainted nodes unless they tolerate the taint.")
  NoSchedule: "NoSchedule",

  @doc("Scheduler will avoid placing pods on tainted nodes but will not strictly forbid it.")
  PreferNoSchedule: "PreferNoSchedule",

  @doc("Running pods that do not tolerate the taint will be evicted.")
  NoExecute: "NoExecute",

  string,
}

@doc("Kubernetes node taint toleration that allows the inference pods to be scheduled on tainted nodes.")
model Toleration {
  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "Kubernetes taint key is an identifier, not a secret."
  @doc("Taint key to tolerate.")
  @minLength(1)
  key: string;

  @doc("Operator. 'Equal' matches by key+value; 'Exists' matches by key only.")
  operator: TolerationOperator;

  @doc("Taint value (required when operator is 'Equal').")
  value?: string;

  @doc("Taint effect to tolerate.")
  effect: TolerationEffect;

  @doc("Duration in seconds to tolerate the taint. Only valid for 'NoExecute' effect.")
  @minValue(0)
  tolerationSeconds?: int32;
}

@doc("Ingress path matching type.")
union PathType {
  @doc("Match by URL path prefix.")
  Prefix: "Prefix",

  @doc("Exact path match.")
  Exact: "Exact",

  @doc("Implementation-specific path match semantics, as defined by the Ingress controller.")
  ImplementationSpecific: "ImplementationSpecific",

  string,
}

@doc("TLS configuration for the Ingress.")
model TlsConfig {
  @doc("Whether TLS is enabled on the Ingress. Cluster default is false if omitted. When true, `endpoint.host` and `secretName` are required.")
  enabled?: boolean;

  @doc("Name of the Kubernetes TLS secret to use. Required when TLS is enabled.")
  @minLength(1)
  @maxLength(253)
  secretName?: string;
}

@doc("External endpoint (Kubernetes Ingress) configuration for the deployment.")
model EndpointConfig {
  @doc("Whether to provision an Ingress for the deployment. Cluster default is false if omitted.")
  enabled?: boolean;

  @doc("Hostname for the Ingress.")
  @maxLength(253)
  host?: string;

  @doc("URL path served by the Ingress. Derived from the deployment name if not specified.")
  path?: string;

  @doc("Target path to rewrite incoming requests to.")
  rewritePath?: string;

  @doc("Path matching type. Cluster default is 'ImplementationSpecific' if omitted.")
  pathType?: PathType;

  @doc("Name of the IngressClass to use. Cluster default is 'nginx' if omitted.")
  ingressClassName?: string;

  @doc("TLS configuration for the Ingress.")
  tls?: TlsConfig;
}

// ----------------------------------------------------------------------------
// Model reference (discriminated union)
// ----------------------------------------------------------------------------

@doc("Discriminator for the kind of model reference used by a deployment.")
union ModelReferenceKind {
  @doc("Inline reference to a model from the Foundry Local catalog.")
  Catalog: "Catalog",

  @doc("Inline reference to a custom model from a container registry.")
  Custom: "Custom",

  @doc("Reference to an external Models-as-a-Service deployment. Requires `runtime` to be `Maas`.")
  Maas: "Maas",

  @doc("Reference to an existing Microsoft.FoundryLocal/models resource on the same Arc cluster.")
  Ref: "Ref",

  string,
}

@doc("Reference to the model that a deployment serves. Exactly one variant is used per deployment, indicated by `kind`.")
@discriminator("kind")
model ModelReference {
  @doc("Discriminator: which model-reference shape is in use.")
  kind: ModelReferenceKind;
}

@doc("Reference to a model from the Foundry Local catalog. The cluster resolves the catalog entry against its installed catalog ConfigMap.")
model ModelByCatalog extends ModelReference {
  kind: ModelReferenceKind.Catalog;

  @doc("Catalog model name (e.g. 'phi-4').")
  @minLength(1)
  @maxLength(253)
  catalogName: string;

  @doc("Catalog model version. Defaults to 'latest'.")
  catalogVersion?: string = "latest";
}

@doc("Inline reference to a custom model. Equivalent to creating a Microsoft.FoundryLocal/models resource and referencing it, but provides a one-shot path for deployments that do not need a reusable Model.")
model ModelByCustom extends ModelReference {
  kind: ModelReferenceKind.Custom;

  @doc("Container registry URL.")
  @minLength(1)
  @maxLength(253)
  registry: string;

  @doc("Repository path within the registry.")
  @minLength(1)
  @maxLength(253)
  repository: string;

  @doc("Image or artifact tag.")
  @minLength(1)
  @maxLength(128)
  tag: string;

  @doc("Registry authentication credentials.")
  credentials: RegistryCredentials;

  @doc("Optional model task type, e.g. 'chat-completion', 'automatic-speech-recognition'.")
  @minLength(1)
  @maxLength(64)
  task?: string;
}

@doc("SKU for a Models-as-a-Service deployment.")
model MaasSku {
  @doc("MaaS SKU name, e.g. 'ProvisionedManaged'. Immutable after create.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @minLength(1)
  @maxLength(64)
  name: string;

  @doc("Provisioned capacity units. Mutable via PATCH.")
  @minValue(1)
  @maxValue(100000)
  capacity: int32;
}

@doc("MaaS model format.")
union MaasFormat {
  @doc("OpenAI-compatible API.")
  OpenAI: "OpenAI",

  string,
}

@doc("Reference to an external Models-as-a-Service (MaaS) deployment. Inference traffic is forwarded to the upstream MaaS endpoint via a thin CPU-only router pod on the cluster. Requires `runtime` to be `Maas` and `compute` to be `Cpu`.")
model ModelByMaas extends ModelReference {
  kind: ModelReferenceKind.Maas;

  @doc("MaaS model API format.")
  format: MaasFormat;

  @doc("Upstream MaaS model name, e.g. 'gpt-4o'.")
  @minLength(1)
  @maxLength(253)
  modelName: string;

  @doc("Upstream MaaS model version, e.g. '2024-08-06'.")
  @minLength(1)
  @maxLength(64)
  modelVersion: string;

  @doc("Name of the MaaS backend (configured on the cluster's helm values) to route through. Immutable after create.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @minLength(1)
  @maxLength(47)
  @pattern("^[a-z][a-z0-9-]{0,46}$")
  backendRef: string;

  @doc("Name of the deployment in the upstream MaaS control plane. Immutable after create.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @minLength(1)
  @maxLength(25)
  @pattern("^[a-z0-9]([a-z0-9-]{0,23}[a-z0-9])?$")
  maasDeploymentName: string;

  @doc("SKU for the MaaS deployment. `name` is immutable after create; `capacity` is mutable.")
  sku: MaasSku;
}

@doc("Reference to an existing Microsoft.FoundryLocal/models resource. The referenced Model must be on the same Arc cluster (same `extendedLocation`) as the deployment.")
model ModelByRef extends ModelReference {
  kind: ModelReferenceKind.Ref;

  @doc("ARM resource ID of the Microsoft.FoundryLocal/models resource to reference.")
  modelId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.FoundryLocal/models";
    }
  ]>;
}

// ----------------------------------------------------------------------------
// ModelDeployment resource
// ----------------------------------------------------------------------------

@doc("Properties of a ModelDeployment resource. Cross-field constraints (e.g. `Predictive` requires a Custom model; `Vllm` runtime requires GPU compute; `Maas` model requires `Maas` runtime and CPU compute) are enforced by the cluster on PUT and surface as 400 errors if violated.")
model ModelDeploymentProperties {
  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @doc("Reference to the model this deployment serves. Immutable after create.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  `model`: ModelReference;

  @doc("Compute type for the deployment.")
  compute: ComputeType;

  @doc("Type of inference workload. Defaults to `Generative`. `Predictive` requires a Custom model.")
  workloadType?: WorkloadType = WorkloadType.Generative;

  @doc("Inference runtime engine. Defaults to `OnnxGenai`. Must be `Maas` if and only if the model is `Maas`. `Vllm` requires `Gpu` compute.")
  runtime?: RuntimeType = RuntimeType.OnnxGenai;

  @doc("Human-readable deployment name shown in tooling.")
  @maxLength(256)
  displayName?: string;

  @doc("Number of pod replicas to run. Defaults to 1.")
  @minValue(1)
  @maxValue(100)
  replicas?: int32 = 1;

  @doc("Container port the inference server listens on. Defaults to 5000.")
  @minValue(1024)
  @maxValue(65535)
  port?: int32 = 5000;

  @doc("When true, allows `Gpu` compute without requiring the `nvidia.com/gpu` resource limit. Must be used with `nodeSelector` to target GPU nodes manually.")
  skipGpuResource?: boolean = false;

  @doc("vLLM-specific runtime configuration. Used only when `runtime` is `Vllm`.")
  vllmConfig?: VllmConfig;

  @doc("Resource requirements for the inference container.")
  resources?: ResourceRequirements;

  @doc("Environment variables to set on the inference container.")
  env?: EnvVar[];

  @doc("Tolerations that allow inference pods to be scheduled on tainted nodes.")
  @identifiers(#[])
  tolerations?: Toleration[];

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Kubernetes node selector labels are user-defined and free-form (any cluster admin can introduce new node labels). The cluster, not ARM, owns the schema for these keys. Pending review at ARM modeling office hours pre-GA."
  @doc("Kubernetes node selector labels for pod scheduling. Keys are user-defined cluster node labels.")
  nodeSelector?: Record<string>;

  @doc("External endpoint (Ingress) configuration for the deployment.")
  endpoint?: EndpointConfig;

  @doc("Observed status of the model deployment as reported by the cluster.")
  @visibility(Lifecycle.Read)
  status?: ModelDeploymentStatus;
}

@doc("A model deployment running on an Azure Arc-enabled Kubernetes cluster.")
model ModelDeployment is TrackedResource<ModelDeploymentProperties> {
  ...ResourceNameParameter<
    ModelDeployment,
    NamePattern = "^[a-z]([a-z0-9]*(-[a-z0-9]+)*)?$"
  >;
  ...RequiredExtendedLocationProperty;
}

@doc("The type used for update operations of the ModelDeployment.")
model ModelDeploymentUpdate {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Standard ARM resource tags are modeled as Record<string>."
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("The resource-specific properties for this resource.")
  properties?: ModelDeploymentUpdateProperties;
}

@doc("The updatable properties of the ModelDeployment. The model reference is immutable post-create; runtime configuration, replicas, scheduling, env, and endpoint can be updated.")
model ModelDeploymentUpdateProperties {
  @doc("Type of inference workload.")
  workloadType?: WorkloadType;

  @doc("Inference runtime engine.")
  runtime?: RuntimeType;

  @doc("Human-readable deployment name.")
  @maxLength(256)
  displayName?: string;

  @doc("Number of pod replicas.")
  @minValue(1)
  @maxValue(100)
  replicas?: int32;

  @doc("Container port the inference server listens on.")
  @minValue(1024)
  @maxValue(65535)
  port?: int32;

  @doc("Whether to skip the GPU resource limit when running on GPU compute.")
  skipGpuResource?: boolean;

  @doc("vLLM-specific runtime configuration.")
  vllmConfig?: VllmConfig;

  @doc("Resource requirements for the inference container.")
  resources?: ResourceRequirements;

  @doc("Environment variables to set on the inference container.")
  env?: EnvVar[];

  @doc("Tolerations for pod scheduling.")
  @identifiers(#[])
  tolerations?: Toleration[];

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Kubernetes node selector labels are user-defined and free-form. Pending review at ARM modeling office hours pre-GA."
  @doc("Kubernetes node selector labels for pod scheduling.")
  nodeSelector?: Record<string>;

  @doc("External endpoint (Ingress) configuration.")
  endpoint?: EndpointConfig;
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
