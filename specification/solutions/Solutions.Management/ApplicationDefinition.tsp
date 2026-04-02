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
 * Information about managed application definition.
 */
#suppress "@azure-tools/typespec-azure-core/no-private-usage" "FIXME: Update justification, follow aka.ms/tsp/conversion-fix for details"
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "FIXME: Update justification, follow aka.ms/tsp/conversion-fix for details"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-custom-resource-usage-discourage" "FIXME: Update justification, follow aka.ms/tsp/conversion-fix for details"
@Http.Private.includeInapplicableMetadataInPayload(false)
model ApplicationDefinition extends GenericResource {
  @visibility(Lifecycle.Read)
  @path
  @key("applicationDefinitionName")
  @minLength(2)
  @maxLength(10)
  @segment("applicationDefinitions")
  name: string;

  /**
   * The managed application definition properties that can be updated.
   */
  properties: ApplicationDefinitionProperties;
}

@armResourceOperations(#{ allowStaticRoutes: true, omitTags: true })
interface ApplicationDefinitionOpsById {
  /**
   * Gets the managed application definition.
   */
  @tag("ApplicationDefinitions")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions/{applicationDefinitionName}?disambiguation_dummy")
  getById(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the managed application definition.
     */
    @minLength(3)
    @maxLength(64)
    @path
    applicationDefinitionName: string,
  ): ArmResponse<ApplicationDefinition> | NotFoundResponse | ErrorResponse;

  /**
   * Creates or updates a managed application definition.
   */
  @tag("ApplicationDefinitions")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions/{applicationDefinitionName}?disambiguation_dummy")
  @put
  createOrUpdateById(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the managed application definition.
     */
    @minLength(3)
    @maxLength(64)
    @path
    applicationDefinitionName: string,

    /**
     * Parameters supplied to the create or update a managed application definition.
     */
    @bodyRoot
    parameters: ApplicationDefinition,
  ): ArmResponse<ApplicationDefinition> | ArmCreatedResponse<ApplicationDefinition> | ErrorResponse;

  /**
   * Updates the managed application definition.
   */
  @tag("ApplicationDefinitions")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions/{applicationDefinitionName}?disambiguation_dummy")
  @patch(#{ implicitOptionality: false })
  updateById(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the managed application definition.
     */
    @minLength(3)
    @maxLength(64)
    @path
    applicationDefinitionName: string,

    /**
     * Parameters supplied to the update a managed application definition.
     */
    @bodyRoot
    parameters: ApplicationDefinitionPatchable,
  ): ArmResponse<ApplicationDefinition> | ErrorResponse;

  /**
   * Deletes the managed application definition.
   */
  @tag("ApplicationDefinitions")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions/{applicationDefinitionName}?disambiguation_dummy")
  @delete
  deleteById(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the managed application definition.
     */
    @minLength(3)
    @maxLength(64)
    @path
    applicationDefinitionName: string,
  ): OkResponse | NoContentResponse | ErrorResponse;
}

@armResourceOperations
interface ApplicationDefinitions {
  /**
   * Gets the managed application definition.
   */
  get is ArmResourceRead<
    ApplicationDefinition,
    Response = ArmResponse<ApplicationDefinition> | NotFoundResponse
  >;

  /**
   * Creates or updates a managed application definition.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<ApplicationDefinition>;

  /**
   * Updates the managed application definition.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    ApplicationDefinition,
    PatchModel = ApplicationDefinitionPatchable
  >;

  /**
   * Deletes the managed application definition.
   */
  delete is ArmResourceDeleteSync<ApplicationDefinition>;

  /**
   * Lists the managed application definitions in a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<ApplicationDefinition>;

  /**
   * Lists all the application definitions within a subscription.
   */
  listBySubscription is ArmListBySubscription<ApplicationDefinition>;
}

@@maxLength(ApplicationDefinition.name, 64);
@@minLength(ApplicationDefinition.name, 3);
@@doc(ApplicationDefinition.name,
  "The name of the managed application definition."
);
@@doc(ApplicationDefinition.properties,
  "The managed application definition properties."
);
@@doc(ApplicationDefinitions.createOrUpdate::parameters.resource,
  "Parameters supplied to the create or update an managed application definition."
);
@@doc(ApplicationDefinitions.update::parameters.properties,
  "Parameters supplied to the update a managed application definition."
);
