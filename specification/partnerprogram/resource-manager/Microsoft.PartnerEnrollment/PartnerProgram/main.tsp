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
  @visibility(Lifecycle.Read)
  @doc("Identifier of the partner program. Populated by the service on create.")
  programId?: string;

  @visibility(Lifecycle.Read)
  @doc("Billing account identifier associated with this enrollment. Populated by the service on create.")
  billingAccountId?: string;

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
  createOrUpdate is ArmResourceCreateOrReplaceSync<MaicppProgram>;
  delete is ArmResourceDeleteSync<MaicppProgram>;
  listByResourceGroup is ArmResourceListByParent<MaicppProgram>;
  listBySubscription is ArmListBySubscription<MaicppProgram>;
}
