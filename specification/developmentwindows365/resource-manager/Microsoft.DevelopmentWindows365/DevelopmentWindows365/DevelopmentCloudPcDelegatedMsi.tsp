import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.DevelopmentWindows365;
/**
 * Represents a developmentCloudPcDelegatedMsi resource.
 */
model DevelopmentCloudPcDelegatedMsi
  is Azure.ResourceManager.TrackedResource<DevelopmentCloudPcDelegatedMsiProperties> {
  ...ResourceNameParameter<
    Resource = DevelopmentCloudPcDelegatedMsi,
    KeyName = "developmentCloudPcDelegatedMsiName",
    SegmentName = "developmentCloudPcDelegatedMsis",
    NamePattern = "^[a-zA-Z][A-Za-z0-9]*$"
  >;

  /**
   * Delegated Managed identity properties
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: ManagedServiceIdentityWithDelegation;
}

@armResourceOperations
interface DevelopmentCloudPcDelegatedMsis {
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_Get")
  get is ArmResourceRead<DevelopmentCloudPcDelegatedMsi>;

  /**
   * Creates or updates a DevelopmentCloudPcDelegatedMsi resource
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<DevelopmentCloudPcDelegatedMsi>;

  /**
   * Partially updates a DevelopmentCloudPcDelegatedMsi.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_Update")
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    DevelopmentCloudPcDelegatedMsi,
    PatchModel = DevelopmentCloudPcDelegatedMsiUpdate
  >;

  /**
   * Deletes a DevelopmentCloudPcDelegatedMsi
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_Delete")
  delete is ArmResourceDeleteSync<DevelopmentCloudPcDelegatedMsi>;

  /**
   * Lists all DevelopmentCloudPcDelegatedMsi in a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    DevelopmentCloudPcDelegatedMsi,
    Parameters = {
      /**
       * The maximum number of resources to return from the operation. Example: '$top=10'.
       */
      @query("$top")
      $top?: int32;
    }
  >;

  /**
   * Lists all DevelopmentCloudPcDelegatedMsi in a subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_ListBySubscription")
  listBySubscription is ArmListBySubscription<
    DevelopmentCloudPcDelegatedMsi,
    Parameters = {
      /**
       * The maximum number of resources to return from the operation. Example: '$top=10'.
       */
      @query("$top")
      $top?: int32;
    }
  >;
}

@@doc(
  DevelopmentCloudPcDelegatedMsi.name,
  "The name of the developmentCloudPcDelegatedMsi."
);
@@doc(
  DevelopmentCloudPcDelegatedMsi.properties,
  "DevelopmentCloudPcDelegatedMsi properties"
);
@@doc(
  DevelopmentCloudPcDelegatedMsis.createOrUpdate::parameters.resource,
  "Represents a DevelopmentCloudPcDelegatedMsi."
);
@@doc(
  DevelopmentCloudPcDelegatedMsis.update::parameters.properties,
  "Updatable DevelopmentCloudPcDelegatedMsi properties."
);
