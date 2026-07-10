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

/** Properties of an inference service account. */
model InferenceAccountProperties {
  /** The REST endpoint for the inference account */
  @visibility(Lifecycle.Read)
  endpoint?: url;

  /** Provisioning state of the inference account */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** Whether key-based authentication is enabled for the inference account. */
  @visibility(Lifecycle.Read, Lifecycle.Update)
  enableKeyBasedAuthentication?: boolean;

  /** Metadata about the inference account's API keys, such as last-usage timestamps. */
  @visibility(Lifecycle.Read)
  keysMetadata?: KeysMetadata;
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

/** The type of API key to regenerate. */
union KeyType {
  /** The primary API key. */
  Primary: "Primary",

  /** The secondary API key. */
  Secondary: "Secondary",

  string,
}

/** Metadata about the API keys of an inference account. */
model KeysMetadata {
  /** The UTC timestamp of the last time the primary key was used. */
  @visibility(Lifecycle.Read)
  primaryKeyLastUsage?: utcDateTime;

  /** The UTC timestamp of the last time the secondary key was used. */
  @visibility(Lifecycle.Read)
  secondaryKeyLastUsage?: utcDateTime;
}

/** The API keys of an inference account. */
model AccountKeysResult {
  /** The primary API key for the inference account. */
  @secret
  @visibility(Lifecycle.Read)
  primaryKey?: string;

  /** The secondary API key for the inference account. */
  @secret
  @visibility(Lifecycle.Read)
  secondaryKey?: string;
}

/** The request body for regenerating an inference account API key. */
model RegenerateApiKeyRequest {
  /** The type of API key to regenerate. */
  keyType: KeyType;
}

@armResourceOperations
interface InferenceAccounts {
  get is ArmResourceRead<InferenceAccount>;
  @Azure.Core.useFinalStateVia("azure-async-operation")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    InferenceAccount,
    LroHeaders = ArmCombinedLroHeaders & Azure.Core.Foundations.RetryAfterHeader
  >;
  update is ArmResourcePatchSync<InferenceAccount, InferenceAccountProperties>;
  @Azure.Core.useFinalStateVia("azure-async-operation")
  delete is ArmResourceDeleteWithoutOkAsync<
    InferenceAccount,
    LroHeaders = ArmCombinedLroHeaders & Azure.Core.Foundations.RetryAfterHeader
  >;
  listByResourceGroup is ArmResourceListByParent<InferenceAccount>;
  listBySubscription is ArmListBySubscription<InferenceAccount>;

  /** List the API keys for an inference account. */
  listApiKeys is ArmResourceActionSync<
    InferenceAccount,
    void,
    AccountKeysResult
  >;

  /** Regenerate an API key for an inference account. */
  regenerateApiKey is ArmResourceActionSync<
    InferenceAccount,
    RegenerateApiKeyRequest,
    InferenceAccount
  >;
}
