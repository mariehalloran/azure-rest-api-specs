import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Solutions;
/**
 * Information about managed application.
 */
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" ""
model Application
  is Azure.ResourceManager.Legacy.TrackedResourceWithOptionalLocation<
    ApplicationProperties,
    false
  > {
  ...ResourceNameParameter<
    Resource = Application,
    KeyName = "applicationName",
    SegmentName = "applications",
    NamePattern = ""
  >;

  /**
   * ID of the resource that manages this resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  managedBy?: string;

  /**
   * The SKU of the resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku?: Sku;

  /**
   * The plan information.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  plan?: Plan;

  /**
   * The kind of the managed application. Allowed values are MarketPlace and ServiceCatalog.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @pattern("^[-\\w\\._,\\(\\)]+$")
  kind: string;

  /**
   * The identity of the resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: Identity;
}

@armResourceOperations
interface Applications {
  /**
   * Gets the managed application.
   */
  get is ArmResourceRead<
    Application,
    Response = ArmResponse<Application> | NotFoundResponse
  >;

  /**
   * Creates or updates a managed application.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Application>;

  /**
   * Updates an existing managed application.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-patch" ""
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" ""
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  @patch(#{ implicitOptionality: false })
  update is Azure.ResourceManager.Legacy.CustomPatchAsync<
    Application,
    PatchModel = ApplicationPatchable,
    Response = ArmResponse<Application> | (ArmAcceptedLroResponse<LroHeaders = ArmAsyncOperationHeader<FinalResult = Application> &
      Azure.Core.Foundations.RetryAfterHeader> & {
      @bodyRoot
      _: Application;
    }),
    OptionalRequestBody = true
  >;

  /**
   * Deletes the managed application.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    Application,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse<ArmAsyncOperationHeader &
      Azure.Core.Foundations.RetryAfterHeader> | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all the applications within a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<Application>;

  /**
   * Lists all the applications within a subscription.
   */
  listBySubscription is ArmListBySubscription<Application>;

  /**
   * Refresh Permissions for application.
   */
  refreshPermissions is ArmResourceActionAsyncBase<
    Application,
    void,
    OkResponse | ArmAcceptedLroResponse<LroHeaders = ArmLroLocationHeader>,
    Azure.ResourceManager.Foundations.BaseParameters<Application>
  >;

  /**
   * List allowed upgrade plans for application.
   */
  @list
  listAllowedUpgradePlans is ArmResourceActionSync<
    Application,
    void,
    ArmResponse<AllowedUpgradePlansResult>
  >;

  /**
   * Update access for application.
   */
  updateAccess is ArmResourceActionAsyncBase<
    Application,
    UpdateAccessDefinition,
    OkResponse | ArmAcceptedLroResponse<
      "Resource operation accepted.",
      ArmLroLocationHeader & Body<UpdateAccessDefinition>
    >,
    BaseParameters = Azure.ResourceManager.Foundations.BaseParameters<Application>
  >;

  /**
   * List tokens for application.
   */
  @list
  listTokens is ArmResourceActionSync<
    Application,
    ListTokenRequest,
    ArmResponse<ManagedIdentityTokenResult>
  >;
}

@@maxLength(Application.name, 64);
@@minLength(Application.name, 3);
@@doc(Application.name, "The name of the managed application.");
@@doc(Application.properties, "The managed application properties.");
@@doc(Applications.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update a managed application."
);
@@doc(Applications.update::parameters.properties,
  "Parameters supplied to update an existing managed application."
);
@@doc(Applications.updateAccess::parameters.body,
  "Request body parameters to update access."
);
@@doc(Applications.listTokens::parameters.body,
  "Request body parameters to list tokens."
);
