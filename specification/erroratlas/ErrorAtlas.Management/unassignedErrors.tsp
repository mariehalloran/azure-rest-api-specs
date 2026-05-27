import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.ErrorAtlas;

/** An unassigned error event pending cluster assignment (tenant-scoped, global resource). */
@tenantResource
@added(Microsoft.ErrorAtlas.Versions.v2026_06_01_preview)
model UnassignedError is ProxyResource<UnassignedErrorProperties> {
  /** The unassigned error resource name. */
  @key("unassignedErrorName")
  @segment("unassignedErrors")
  @pattern("^[a-zA-Z0-9_-]{1,128}$")
  @path
  name: string;
}

/** Properties of an unassigned error event. */
model UnassignedErrorProperties {
  /** ARM resource type of the target resource (e.g., Microsoft.Sql/servers/databases). */
  @visibility(Lifecycle.Read)
  targetResourceType: string;

  /** Error details. */
  @visibility(Lifecycle.Read)
  errorAttributes: UnassignedErrorAttributes;

  /** The provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: Azure.ResourceManager.ResourceProvisioningState;
}

/** Details of the unassigned error event. */
model UnassignedErrorAttributes {
  /** Timestamp of when the error occurred. */
  eventTimestamp: utcDateTime;

  /** Error code from the Azure service (e.g., GatewayTimeout, AllocationFailed). Values are unbounded as they originate from arbitrary Azure resource providers. */
  errorCode: string;

  /** Detailed error message. */
  errorMessage?: string;
}

@armResourceOperations
@added(Microsoft.ErrorAtlas.Versions.v2026_06_01_preview)
interface UnassignedErrors {
  /** Get an unassigned error event. */
  get is ArmResourceRead<UnassignedError>;
  /** List unassigned error events. */
  list is ArmResourceListByParent<UnassignedError>;
}
