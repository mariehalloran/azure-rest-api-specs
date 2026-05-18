import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.ErrorInsights;

/** An error event associated with an Azure resource. */
model Error is ExtensionResource<ErrorProperties> {
  /** The error resource name. */
  @key("errorName")
  @segment("errors")
  @pattern("^[a-zA-Z0-9_-]{1,128}$")
  @path
  name: string;
}

/** Properties of an error event. */
model ErrorProperties {
  /** Full ARM resource ID of the resource that encountered the error. */
  @visibility(Lifecycle.Read)
  targetResourceId: Azure.Core.armResourceIdentifier;

  /** ARM resource type of the target resource (e.g., Microsoft.Sql/servers/databases). */
  @visibility(Lifecycle.Read)
  targetResourceType: string;

  /** Error details. */
  @visibility(Lifecycle.Read)
  errorAttributes: ErrorAttributes;

  /** The provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: Azure.ResourceManager.ResourceProvisioningState;
}

/** Details of the error event. */
model ErrorAttributes {
  /** Timestamp of when the error occurred. */
  eventTimestamp: utcDateTime;

  /** Error code from the Azure service (e.g., GatewayTimeout, AllocationFailed). Values are unbounded as they originate from arbitrary Azure resource providers. */
  errorCode: string;

  /** Detailed error message. */
  errorMessage?: string;

  /** Cluster identifier linking this error to a group of similar errors. */
  clusterId?: string;
}

@armResourceOperations
interface Errors {
  /** Get an error event for a resource. */
  get is ArmResourceRead<Error>;
  /** List error events for a resource. */
  list is ArmResourceListByParent<Error>;
}
