import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

@armProviderNamespace("Microsoft.ProgramEnrollment")
@service(#{ title: "Microsoft.ProgramEnrollment" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
namespace Microsoft.ProgramEnrollment;

enum Versions {
  `2026-03-01-preview`,
}

interface Operations extends Azure.ResourceManager.Operations {}

@doc("A ProgramProviderHub resource")
model EduEnrollment is TrackedResource<EduEnrollmentProperties> {
  @doc("The name of the edu enrollment")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @key("enrollmentName")
  @segment("eduEnrollments")
  @path
  name: string;
}

@doc("The status of the current operation.")
@Azure.Core.lroStatus
union ProvisioningState {
  ResourceProvisioningState,

  @doc("Initial provisioning in progress")
  Provisioning: "Provisioning",

  @doc("Update in progress")
  Updating: "Updating",

  @doc("Deletion in progress")
  Deleting: "Deleting",

  @doc("Change accepted for processing")
  Accepted: "Accepted",
}

@doc("The assessment state of a domain group.")
union DomainGroupState {
  string,

  @doc("Assessment is pending.")
  Pending: "pending",

  @doc("Action is required to complete assessment.")
  ActionRequired: "actionRequired",

  @doc("Assessment failed.")
  Failed: "failed",

  @doc("Assessment succeeded.")
  Succeeded: "succeeded",
}

@doc("Error detail for a failed enrollment or domain group.")
model EnrollmentError {
  @doc("The error code.")
  code: string;

  @doc("A human-readable description of the error.")
  message: string;
}

@doc("A group of edu domains scoped to an Entra tenant.")
model DomainGroup {
  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The edu domain names in this group.")
  @minItems(1)
  domainNames: string[];

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The Entra tenant ID that owns these domains. Defaults to the caller's tenant if omitted.")
  tenantId?: Azure.Core.uuid;

  @visibility(Lifecycle.Read)
  @doc("The assessment state of this domain group.")
  state?: DomainGroupState;

  @visibility(Lifecycle.Read)
  @doc("Error detail when state is failed or actionRequired. Omitted otherwise.")
  error?: EnrollmentError;
}

@doc("Details of the Program EduEnrollment.")
model EduEnrollmentProperties {
  @visibility(Lifecycle.Read)
  @doc("The status of the last operation.")
  provisioningState?: ProvisioningState;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The domain groups associated with this enrollment.")
  @minItems(1)
  @identifiers(#[])
  domains: DomainGroup[];

  @visibility(Lifecycle.Read)
  @doc("Error detail when provisioningState is Failed. Omitted otherwise.")
  error?: EnrollmentError;
}

@doc("The type used for update operations of the EduEnrollment.")
model EduEnrollmentPatch {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "ARM tags are represented as a string map."
  @doc("Resource tags.")
  tags?: Record<string>;
}

@armResourceOperations(EduEnrollment)
interface EduEnrollments {
  get is ArmResourceRead<EduEnrollment>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<EduEnrollment>;
  update is ArmCustomPatchSync<EduEnrollment, EduEnrollmentPatch>;
  delete is ArmResourceDeleteSync<EduEnrollment>;
  listByResourceGroup is ArmResourceListByParent<EduEnrollment>;
  listBySubscription is ArmListBySubscription<EduEnrollment>;
}
