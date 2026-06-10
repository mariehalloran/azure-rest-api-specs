import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.CloudDevicePlatform;

// --------------------------------------------
// SandboxPartner Resource Model Definitions
// --------------------------------------------
@doc("Represents a CloudDevicePlatform sandbox partner resource.")
@added(Versions.v2026_04_01_preview)
model SandboxPartner is TrackedResource<SandboxPartnerProperties> {
  ...ResourceNameParameter<
    Resource = SandboxPartner,
    SegmentName = "sandboxPartners",
    NamePattern = "^[a-zA-Z0-9]{3,22}$"
  >;
}

@doc("Represents the properties of a CloudDevicePlatform sandbox partner resource.")
@added(Versions.v2026_04_01_preview)
model SandboxPartnerProperties {
  @doc("The status of the last provisioning operation performed on the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

@doc("Represents the properties of a SandboxPartner resource that can be updated.")
@added(Versions.v2026_04_01_preview)
model SandboxPartnerUpdate {
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;
}

@armResourceOperations
@added(Versions.v2026_04_01_preview)
interface SandboxPartners {
  createOrUpdate is ArmResourceCreateOrReplaceSync<SandboxPartner>;
  delete is ArmResourceDeleteSync<SandboxPartner>;
  get is ArmResourceRead<SandboxPartner>;
  update is ArmCustomPatchSync<SandboxPartner, SandboxPartnerUpdate>;
  listByResourceGroup is ArmResourceListByParent<SandboxPartner>;
  listBySubscription is ArmListBySubscription<SandboxPartner>;
}
