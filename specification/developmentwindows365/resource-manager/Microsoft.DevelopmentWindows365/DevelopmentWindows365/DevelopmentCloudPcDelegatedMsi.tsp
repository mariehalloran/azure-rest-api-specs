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
 * Resource group scope parameters for DevelopmentWindows365 operations.
 */
model DevelopmentWindows365ResourceGroupScopeParameters {
  ...Azure.ResourceManager.CommonTypes.ApiVersionParameter;

  /**
   * The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
   */
  @path
  @segment("subscriptions")
  subscriptionId: string;

  /**
   * The name of the resource group.
   */
  @path
  @segment("resourceGroups")
  resourceGroupName: string;
}

/**
 * Subscription scope parameters for DevelopmentWindows365 operations.
 */
model DevelopmentWindows365SubscriptionScopeParameters {
  ...Azure.ResourceManager.CommonTypes.ApiVersionParameter;

  /**
   * The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
   */
  @path
  @segment("subscriptions")
  subscriptionId: string;
}

/**
 * Result of the list developmentCloudPcDelegatedMsis operation.
 */
model DevelopmentCloudPcDelegatedMsiListResult {
  /**
   * Current page of results.
   */
  @pageItems
  @visibility(Lifecycle.Read)
  value?: DevelopmentCloudPcDelegatedMsi[];

  /**
   * URL to get the next set of results if there are any.
   */
  @nextLink
  @visibility(Lifecycle.Read)
  nextLink?: string;
}
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
  get is ArmResourceRead<
    DevelopmentCloudPcDelegatedMsi,
    BaseParameters = DevelopmentWindows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /**
   * Creates or updates a DevelopmentCloudPcDelegatedMsi resource
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DevelopmentCloudPcDelegatedMsi,
    BaseParameters = DevelopmentWindows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /**
   * Partially updates a DevelopmentCloudPcDelegatedMsi.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_Update")
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    DevelopmentCloudPcDelegatedMsi,
    PatchModel = DevelopmentCloudPcDelegatedMsiUpdate,
    BaseParameters = DevelopmentWindows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /**
   * Deletes a DevelopmentCloudPcDelegatedMsi
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_Delete")
  delete is ArmResourceDeleteSync<
    DevelopmentCloudPcDelegatedMsi,
    BaseParameters = DevelopmentWindows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /**
   * Lists all DevelopmentCloudPcDelegatedMsi in a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DevelopmentCloudPcDelegatedMsi_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    DevelopmentCloudPcDelegatedMsi,
    BaseParameters = DevelopmentWindows365ResourceGroupScopeParameters,
    Parameters = {
      /**
       * The maximum number of resources to return from the operation. Example: '$top=10'.
       */
      @query("$top")
      $top?: int32;
    },
    Response = ArmResponse<DevelopmentCloudPcDelegatedMsiListResult>
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
    },
    Response = ArmResponse<DevelopmentCloudPcDelegatedMsiListResult>,
    Error = CloudError
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
#suppress "@azure-tools/typespec-azure-core/no-openapi" "For backward compatibility with the existing Swagger x-ms-client-flatten extension."
@@extension(
  DevelopmentCloudPcDelegatedMsi.properties,
  "x-ms-client-flatten",
  true
);
#suppress "@azure-tools/typespec-azure-core/no-openapi" "For backward compatibility with the existing Swagger readOnly enum extension."
@@extension(ResourceProvisioningState, "readOnly", true);
@@doc(
  DevelopmentCloudPcDelegatedMsis.createOrUpdate::parameters.resource,
  "Represents a DevelopmentCloudPcDelegatedMsi."
);
@@doc(
  DevelopmentCloudPcDelegatedMsis.update::parameters.properties,
  "Updatable DevelopmentCloudPcDelegatedMsi properties."
);
#suppress "deprecated" "For backward compatibility with the existing Swagger body parameter name."
@@encodedName(
  DevelopmentCloudPcDelegatedMsis.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
#suppress "deprecated" "For backward compatibility with the existing Swagger body parameter name."
@@encodedName(
  DevelopmentCloudPcDelegatedMsis.update::parameters.properties,
  "application/json",
  "body"
);
