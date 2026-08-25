import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./commontypes.tsp";

using Azure.ResourceManager;
using TypeSpec.Versioning;
using TypeSpec.Http;

namespace Microsoft.AppLink;

@doc("AppLink resource")
model AppLink is TrackedResource<AppLinkProperties> {
  ...ResourceNameParameter<AppLink>;
  ...ManagedServiceIdentityProperty;
}

@doc("AppLink properties")
model AppLinkProperties {
  @doc("Provisioning state")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("The update-specific managed service identity (all fields optional for PATCH).")
@added(Versions.v2026_08_01_preview)
model ManagedServiceIdentityUpdate {
  @doc("The type of managed identity assigned to this resource.")
  type?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentityType;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Updating dictionary of user-assigned identities"
  @doc("The identities assigned to this resource by the user.")
  userAssignedIdentities?: Record<
    | Azure.ResourceManager.CommonTypes.UserAssignedIdentity
    | null>;
}

@doc("The type used for update operations of the AppLink.")
@added(Versions.v2026_08_01_preview)
model AppLinkUpdate {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Updating dictionary of tags"
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("The managed service identities assigned to this resource.")
  identity?: ManagedServiceIdentityUpdate;
}

@armResourceOperations
interface AppLinks {
  @doc("Get an AppLink")
  get is ArmResourceRead<AppLink>;
  @doc("Create an AppLink")
  createOrReplace is ArmResourceCreateOrReplaceAsync<AppLink>;
  @doc("Update an AppLink")
  @removed(Versions.v2026_08_01_preview)
  @renamedFrom(Versions.v2026_08_01_preview, "update")
  @sharedRoute
  @Azure.Core.useFinalStateVia("azure-async-operation")
  updateLegacy is ArmResourcePatchAsync<
    AppLink,
    AppLinkProperties,
    LroHeaders = ArmAsyncOperationHeader<FinalResult = AppLink> &
      ArmLroLocationHeader<FinalResult = AppLink> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  @doc("Update an AppLink")
  @added(Versions.v2026_08_01_preview)
  @sharedRoute
  @Azure.Core.useFinalStateVia("azure-async-operation")
  update is ArmCustomPatchAsync<
    AppLink,
    AppLinkUpdate,
    LroHeaders = ArmAsyncOperationHeader<FinalResult = AppLink> &
      ArmLroLocationHeader<FinalResult = AppLink> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
  @doc("Delete an AppLink")
  delete is ArmResourceDeleteWithoutOkAsync<AppLink>;
  listByResourceGroup is ArmResourceListByParent<AppLink>;
  listBySubscription is ArmListBySubscription<AppLink>;
}
