import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AIGrounding;
/**
 * AIGrounding Account is an Azure resource representing the provisioned account, its type, location and SKU.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in AIGrounding"
model AIGroundingAccount is TrackedResource<AIGroundingAccountProperties> {
  ...ResourceNameParameter<
    Resource = AIGroundingAccount,
    KeyName = "accountName",
    SegmentName = "accounts",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9_.-]*[a-zA-Z0-9])?$"
  >;
  ...EntityTagProperty;
  ...ResourceKindProperty;
  ...ResourceSkuProperty;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in AIGrounding"
@armResourceOperations
interface AIGroundingAccounts {
  /**
   * Returns an AIGrounding account specified by the parameters.
   */
  get is ArmResourceRead<AIGroundingAccount>;

  /**
   * Create an AIGrounding account. Accounts is a resource group-wide resource type. It is the resource type for accessing AIGrounding APIs and billing.
   */
  create is ArmResourceCreateOrReplaceAsync<AIGroundingAccount>;

  /**
   * Updates an AIGrounding account
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Required for custom PATCH LRO operation"
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "Location header is included via ArmLroLocationHeader"
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    AIGroundingAccount,
    PatchModel = AIGroundingAccountUpdate,
    LroHeaders = ArmLroLocationHeader<FinalResult = AIGroundingAccount> &
      ArmAsyncOperationHeader<FinalResult = AIGroundingAccount> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Deletes an AIGrounding account from the resource group.
   */
  delete is ArmResourceDeleteWithoutOkAsync<AIGroundingAccount>;

  /**
   * Returns all the resources of a particular type belonging to a resource group
   */
  listByResourceGroup is ArmResourceListByParent<AIGroundingAccount>;

  /**
   * Returns all the resources of a particular type belonging to a subscription.
   */
  list is ArmListBySubscription<AIGroundingAccount>;

  /**
   * List available SKUs for the requested AIGrounding account
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Required for x-ms-pageable extension on custom action"
  @get
  @action("skus")
  @extension("x-ms-pageable", #{ nextLinkName: "nextLink" })
  listSkus is ArmResourceActionSync<
    AIGroundingAccount,
    void,
    AIGroundingAccountEnumerateSkusResult
  >;

  /**
   * List usages for the requested AIGrounding account
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Required for x-ms-pageable extension on custom action"
  @get
  @action("usages")
  @extension("x-ms-pageable", #{ nextLinkName: "nextLink" })
  listUsages is ArmResourceActionSync<
    AIGroundingAccount,
    void,
    UsagesResult,
    Parameters = {
      /**
       * An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@maxLength(AIGroundingAccount.name, 64);
@@minLength(AIGroundingAccount.name, 2);
@@doc(AIGroundingAccount.name, "The name of the AIGrounding account.");
@@doc(AIGroundingAccount.properties, "Properties of AIGrounding account.");
@@doc(
  AIGroundingAccounts.create::parameters.resource,
  "The parameters of the account to create."
);
@@doc(
  AIGroundingAccounts.update::parameters.properties,
  "The parameters to update in the account."
);
