import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.WebIQ;
/**
 * WebIQ Account is an Azure resource representing the provisioned account, its type, location and SKU.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
model WebIQAccount is TrackedResource<WebIQAccountProperties> {
  ...ResourceNameParameter<
    Resource = WebIQAccount,
    KeyName = "accountName",
    SegmentName = "accounts",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9_.-]*[a-zA-Z0-9])?$"
  >;
  ...EntityTagProperty;
  ...ResourceKindProperty;
  ...ResourceSkuProperty;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "AI is a valid acronym in WebIQ"
@armResourceOperations
interface WebIQAccounts {
  /**
   * Returns an WebIQ account specified by the parameters.
   */
  get is ArmResourceRead<WebIQAccount>;

  /**
   * Create an WebIQ account. Accounts is a resource group-wide resource type. It is the resource type for accessing WebIQ APIs and billing.
   */
  create is ArmResourceCreateOrReplaceAsync<WebIQAccount>;

  /**
   * Updates an WebIQ account
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Required for custom PATCH LRO operation"
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "Location header is included via ArmLroLocationHeader"
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    WebIQAccount,
    PatchModel = WebIQAccountUpdate,
    LroHeaders = ArmLroLocationHeader<FinalResult = WebIQAccount> &
      ArmAsyncOperationHeader<FinalResult = WebIQAccount> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Deletes an WebIQ account from the resource group.
   */
  delete is ArmResourceDeleteWithoutOkAsync<WebIQAccount>;

  /**
   * Returns all the resources of a particular type belonging to a resource group
   */
  listByResourceGroup is ArmResourceListByParent<WebIQAccount>;

  /**
   * Returns all the resources of a particular type belonging to a subscription.
   */
  list is ArmListBySubscription<WebIQAccount>;

  /**
   * List available SKUs for the requested WebIQ account
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Required for x-ms-pageable extension on custom action"
  @get
  @action("skus")
  @extension("x-ms-pageable", #{ nextLinkName: "nextLink" })
  listSkus is ArmResourceActionSync<
    WebIQAccount,
    void,
    WebIQAccountEnumerateSkusResult
  >;

  /**
   * List usages for the requested WebIQ account
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Required for x-ms-pageable extension on custom action"
  @get
  @action("usages")
  @extension("x-ms-pageable", #{ nextLinkName: "nextLink" })
  listUsages is ArmResourceActionSync<
    WebIQAccount,
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

@@maxLength(WebIQAccount.name, 64);
@@minLength(WebIQAccount.name, 2);
@@doc(WebIQAccount.name, "The name of the WebIQ account.");
@@doc(WebIQAccount.properties, "Properties of WebIQ account.");
@@doc(
  WebIQAccounts.create::parameters.resource,
  "The parameters of the account to create."
);
@@doc(
  WebIQAccounts.update::parameters.properties,
  "The parameters to update in the account."
);
