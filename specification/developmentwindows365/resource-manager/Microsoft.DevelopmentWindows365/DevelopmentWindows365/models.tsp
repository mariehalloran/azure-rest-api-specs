import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.DevelopmentWindows365;

/**
 * Provisioning state of the resource.
 */
#suppress "@azure-tools/typespec-azure-core/friendly-name" "For backward compatibility with the existing Swagger enum schema name."
@friendlyName("ProvisioningState")
union ResourceProvisioningState {
  string,

  /**
   * The resource provisioning operation completed successfully.
   */
  Succeeded: "Succeeded",

  /**
   * The resource provisioning operation was canceled.
   */
  Canceled: "Canceled",

  /**
   * The resource is being deleted.
   */
  Deleting: "Deleting",

  /**
   * The resource provisioning operation failed.
   */
  Failed: "Failed",
}

/**
 * Properties of the developmentCloudPcDelegatedMsi.
 */
model DevelopmentCloudPcDelegatedMsiProperties {
  /**
   * The provisioning state of the resource.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

/**
 * Managed service identity (system assigned and/or user assigned identities and/or delegated identities) - internal use only.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model ManagedServiceIdentityWithDelegation
  extends Azure.ResourceManager.CommonTypes.ManagedServiceIdentity {
  /**
   * The set of delegated resources. The delegated resources dictionary keys will be source resource internal ids - internal use only.
   */
  delegatedResources?: DelegatedResources;
}

/**
 * The set of delegated resources. The delegated resources dictionary keys will be source resource internal ids - internal use only.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
model DelegatedResources is Record<DelegatedResource>;

/**
 * Delegated resource properties - internal use only.
 */
model DelegatedResource {
  /**
   * The ARM resource id of the delegated resource - internal use only.
   */
  resourceId?: string;

  /**
   * The tenant id of the delegated resource - internal use only.
   */
  tenantId?: Azure.Core.uuid;

  /**
   * The delegation id of the referral delegation (optional) - internal use only.
   */
  referralResource?: string;

  /**
   * The source resource location - internal use only.
   */
  location?: string;
}

/**
 * An error response from the Windows365 RP service.
 */
@error
model CloudError {
  /**
   * Error body
   */
  error?: CloudErrorBody;
}

/**
 * An error response from the Windows365 RP service.
 */
model CloudErrorBody {
  /**
   * An identifier for the error. Codes are invariant and are intended to be consumed programmatically.
   */
  code?: string;

  /**
   * A message describing the error, intended to be suitable for display in a user interface.
   */
  message?: string;

  /**
   * The target of the particular error. For example, the name of the property in error.
   */
  target?: string;

  /**
   * A list of additional details about the error.
   */
  @identifiers(#[])
  details?: CloudErrorBody[];
}

/**
 * The DevelopmentCloudPcDelegatedMsi resource for partial updates. Properties not provided in the update request will not be changed.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/patch-envelope" "Tags were not part of the existing PATCH contract for this preview API."
model DevelopmentCloudPcDelegatedMsiUpdate {
  /**
   * Managed identity properties
   */
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentity;
}
