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
@service(#{ title: "PartnerEnrollmentClient" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
namespace Microsoft.PartnerEnrollment;

enum Versions {
  `2026-05-25-preview`,
}

interface Operations extends Azure.ResourceManager.Operations {}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-path-segment-invalid-chars" "Existing Template"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-key-invalid-chars" "Existing template"
@doc("A MaicppProgram resource representing a Microsoft AI Cloud Partner Program registration. This is a singleton resource: at most one instance with the fixed name `default` can exist per resource group.")
@singleton("default")
model MaicppProgram is ProxyResource<MaicppProgramProperties> {
  @doc("The name of the MaicppProgram resource. Always `default` because this is a singleton resource.")
  @key("maicppProgramName")
  @segment("maicppprograms")
  @path
  name: string;
}

@doc("Current status of the partner enrollment as reported by the Enrollment State service.")
union EnrollmentStatus {
  string,

  @doc("The enrollment has been submitted but is not yet registered with the Enrollment State service.")
  NotRegistered: "notRegistered",

  @doc("The enrollment has been initialized and acknowledged by the Enrollment State service.")
  Initialized: "initialized",

  @doc("The enrollment status could not be determined or has not yet been reported by the Enrollment State service.")
  Unknown: "unknown",
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
  status?: EnrollmentStatus;
}

@armResourceOperations(MaicppProgram)
interface MaicppPrograms {
  get is ArmResourceRead<MaicppProgram>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<MaicppProgram>;
  delete is ArmResourceDeleteSync<MaicppProgram>;
  listByResourceGroup is ArmResourceListByParent<MaicppProgram>;
  listBySubscription is ArmListBySubscription<MaicppProgram>;
}
