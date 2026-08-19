import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using OpenAPI;

namespace Microsoft.AzureTerraform;

#suppress "@azure-tools/typespec-azure-resource-manager/use-operation-decorator" "FIXME: review suppression and update justification"
#suppress "@azure-tools/typespec-azure-resource-manager/use-api-version" "FIXME: review suppression and update justification"
#suppress "@azure-tools/typespec-azure-resource-manager/use-interface" "Cannot use @armResourceOperations decorator here, the auto-generated routes do not match feature requirements"
#suppress "@azure-tools/typespec-azure-core/no-openapi" "TODO: migrate to LRO concepts DO NOT USE x-ms-long-running-operation-options"
#suppress "@azure-tools/typespec-azure-core/no-openapi-client-extensions" "Existing use of the 'x-ms-long-running-operation-options' OpenAPI extension predates the no-openapi-client-extensions rule; suppressed pending migration to first-class TypeSpec constructs."
@doc("Exports the Terraform configuration of the specified resource(s).")
@route("/subscriptions/{subscriptionId}/providers/Microsoft.AzureTerraform/exportTerraform")
@post
@tag("ExportTerraform")
@extension(
  "x-ms-long-running-operation-options",
  #{
    `final-state-via`: "azure-async-operation",
    `final-state-schema`: "#/definitions/OperationStatus",
  }
)
op exportTerraform(
  ...ApiVersionParameter,
  ...SubscriptionIdParameter,

  @doc("The export parameter")
  @body
  exportParameter: BaseExportModel,
):
  | ArmAcceptedLroResponse<
      "Export request accepted.",
      ArmCombinedLroHeaders & Azure.Core.Foundations.RetryAfterHeader
    >
  | ErrorResponse;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Cannot use @armResourceOperations decorator here, the auto-generated routes do not match feature requirements"
interface OperationStatuses {
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "Body of 202 is not empty: not compatible with API requirements"
  @doc("Get the status of a long running azure asynchronous operation.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AzureTerraform/operationStatuses/{operationId}")
  @get
  @tag("OperationStatuses")
  @armResourceRead(ArmResponse<OperationStatus>)
  get(
    ...OperationIdParameter,
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): OperationStatus | InProgressOperationStatus | ErrorResponse;
}
