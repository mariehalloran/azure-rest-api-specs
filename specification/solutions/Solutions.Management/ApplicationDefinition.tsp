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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" ""
model ApplicationDefinition
  is Azure.ResourceManager.Legacy.TrackedResourceWithOptionalLocation<
    ApplicationDefinitionProperties,
    false
  > {
  ...ResourceNameParameter<
    Resource = ApplicationDefinition,
    KeyName = "applicationDefinitionName",
    SegmentName = "applicationDefinitions",
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
