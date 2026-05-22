import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Credit.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.BillingBenefits;

/**
 * Transaction resource definition for Credits
 */
#suppress "@azure-tools/typespec-azure-resource-manager/empty-updateable-properties" "Admin patches properties server-side via RPaaS; public PATCH body is intentionally empty"
@added(Versions.v2026_02_01)
@parentResource(Credit)
model CreditTransaction
  is Azure.ResourceManager.ProxyResource<TransactionProperties> {
  ...ResourceNameParameter<
    Resource = CreditTransaction,
    KeyName = "transactionName",
    SegmentName = "transactions",
    NamePattern = "^[a-zA-Z0-9_\\-\\.]+$"
  >;
}

@armResourceOperations
interface CreditTransactions {
  /**
   * Get a specific transaction for a credit.
   */
  @added(Versions.v2026_02_01)
  get is ArmResourceRead<CreditTransaction>;

  /**
   * Create or replace a transaction for a credit. This operation requires administrator permissions.
   */
  @added(Versions.v2026_02_01)
  create is ArmResourceCreateOrReplaceAsync<CreditTransaction>;

  /**
   * Update a transaction for a credit, reserved for admin-only operations routed through RPaaS.
   */
  @added(Versions.v2026_02_01)
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    CreditTransaction,
    PatchModel = TransactionPatchRequest
  >;

  /**
   * Delete a transaction for a credit. This operation requires administrator permissions.
   */
  @added(Versions.v2026_02_01)
  delete is ArmResourceDeleteWithoutOkAsync<CreditTransaction>;

  /**
   * List all transactions for a credit.
   */
  @added(Versions.v2026_02_01)
  listByParent is ArmResourceListByParent<
    CreditTransaction,
    Response = ArmResponse<TransactionsList>
  >;
}

@@doc(CreditTransaction.name, "Name of the transaction");
@@doc(CreditTransaction.properties, "Transaction properties");
@@doc(
  CreditTransactions.create::parameters.resource,
  "Transaction create request"
);
@@doc(
  CreditTransactions.update::parameters.properties,
  "Transaction patch request"
);
