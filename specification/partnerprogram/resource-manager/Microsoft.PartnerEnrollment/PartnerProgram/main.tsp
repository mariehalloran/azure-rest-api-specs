import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

@armProviderNamespace("Microsoft.PartnerEnrollment")
@service(#{ title: "Microsoft.PartnerEnrollment" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
namespace Microsoft.PartnerEnrollment;

enum Versions {
  `2026-05-25-preview`,
}

interface Operations extends Azure.ResourceManager.Operations {}

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

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-path-segment-invalid-chars" "Existing Template"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-key-invalid-chars" "Existing template"
@doc("A MaicppProgram resource representing a Microsoft AI Cloud Partner Program registration.")
model MaicppProgram is ProxyResource<MaicppProgramProperties> {
  @doc("The name of the MaicppProgram resource.")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @key("maicppProgramName")
  @segment("maicppprograms")
  @path
  name: string;
}

@doc("Details of the MaicppProgram.")
model MaicppProgramProperties {
  @doc("Identifier of the partner program.")
  programId: string;

  @visibility(Lifecycle.Read)
  @doc("The status of the last operation.")
  provisioningState?: ProvisioningState;

  @visibility(Lifecycle.Read)
  @doc("Identifier returned by the Enrollment State service for this enrollment.")
  enrollmentId?: string;

  @visibility(Lifecycle.Read)
  @doc("Current status of the enrollment as reported by the Enrollment State service.")
  status?: string;
}

@armResourceOperations(MaicppProgram)
interface MaicppPrograms {
  get is ArmResourceRead<MaicppProgram>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<MaicppProgram>;
  delete is ArmResourceDeleteSync<MaicppProgram>;
  listByResourceGroup is ArmResourceListByParent<MaicppProgram>;
  listBySubscription is ArmListBySubscription<MaicppProgram>;
}
