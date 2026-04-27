import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

namespace Microsoft.InferenceService;

/** An inference service account resource for managing inference workloads. */
model InferenceAccount is TrackedResource<InferenceAccountProperties> {
  ...ResourceNameParameter<
    InferenceAccount,
    NamePattern = "^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$"
  >;
}

// Design note: this properties bag intentionally has no writable fields.
// The inference account exposes a stateless endpoint only; no per-account
// configuration is needed at preview. Tags are updated via the standard
// tags-only PATCH; future writable config would be added here.
/** Read-only properties of an inference service account. */
model InferenceAccountProperties {
  /** The REST endpoint for the inference account */
  @visibility(Lifecycle.Read)
  endpoint?: url;

  /** Provisioning state of the inference account */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** The resource provisioning state. */
union ProvisioningState {
  ResourceProvisioningState,

  /** The resource is being provisioned. */
  Provisioning: "Provisioning",

  /** The resource is updating. */
  Updating: "Updating",

  /** The resource is being deleted. */
  Deleting: "Deleting",

  string,
}

@armResourceOperations
interface InferenceAccounts {
  get is ArmResourceRead<InferenceAccount>;
  @Azure.Core.useFinalStateVia("azure-async-operation")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    InferenceAccount,
    LroHeaders = ArmCombinedLroHeaders & Azure.Core.Foundations.RetryAfterHeader
  >;
  update is ArmTagsPatchSync<InferenceAccount>;
  @Azure.Core.useFinalStateVia("azure-async-operation")
  delete is ArmResourceDeleteWithoutOkAsync<
    InferenceAccount,
    LroHeaders = ArmCombinedLroHeaders & Azure.Core.Foundations.RetryAfterHeader
  >;
  listByResourceGroup is ArmResourceListByParent<InferenceAccount>;
  listBySubscription is ArmListBySubscription<InferenceAccount>;
}
