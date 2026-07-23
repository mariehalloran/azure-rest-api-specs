import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Windows365;

/** Provisioning state of the resource. */
#suppress "@azure-tools/typespec-azure-core/friendly-name" "For backward compatibility with the existing Swagger enum schema name."
@friendlyName("ProvisioningState")
union ResourceProvisioningState {
  string,

  /** The resource provisioning operation completed successfully. */
  Succeeded: "Succeeded",

  /** The resource provisioning operation was canceled. */
  Canceled: "Canceled",

  /** The resource is being deleted. */
  Deleting: "Deleting",

  /** The resource provisioning operation failed. */
  Failed: "Failed",
}

/** Properties of the cloudPcDelegatedMsi. */
model CloudPcDelegatedMsiProperties {
  /** The provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

/** An error response from the Windows 365 resource provider. */
@error
model CloudError {
  /** The error body. */
  error?: CloudErrorBody;
}

/** An error response from the Windows 365 resource provider. */
model CloudErrorBody {
  /** An invariant identifier for the error. */
  code?: string;

  /** A message describing the error. */
  message?: string;

  /** The target of the particular error. */
  target?: string;

  /** Additional details about the error. */
  @identifiers(#[])
  details?: CloudErrorBody[];
}

/** The CloudPcDelegatedMsi resource for partial updates. */
#suppress "@azure-tools/typespec-azure-resource-manager/patch-envelope" "Tags were not part of the existing PATCH contract."
model CloudPcDelegatedMsiUpdate {
  /** Managed identity properties. */
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentity;
}
