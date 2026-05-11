import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ConditionalCredit.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.BillingBenefits;

/**
 * Transaction resource definition for ConditionalCredits
 */
#suppress "@azure-tools/typespec-azure-resource-manager/empty-updateable-properties" "Admin patches properties server-side via RPaaS; public PATCH body is intentionally empty"
@parentResource(ConditionalCredit)
model ConditionalCreditTransaction
  is Azure.ResourceManager.ProxyResource<TransactionProperties> {
  ...ResourceNameParameter<
    Resource = ConditionalCreditTransaction,
    KeyName = "transactionName",
    SegmentName = "transactions",
    NamePattern = "^[a-zA-Z0-9_\\-\\.]+$"
  >;
}

@armResourceOperations
interface ConditionalCreditTransactions {
  /**
   * Get a specific transaction for a conditional credit.
   */
  get is ArmResourceRead<ConditionalCreditTransaction>;

  /**
   * Create or replace a transaction for a conditional credit. This operation requires administrator permissions.
   */
  create is ArmResourceCreateOrReplaceAsync<ConditionalCreditTransaction>;

  /**
   * Update a transaction for a conditional credit, reserved for admin-only operations routed through RPaaS.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    ConditionalCreditTransaction,
    PatchModel = TransactionPatchRequest
  >;

  /**
   * Delete a transaction for a conditional credit. This operation requires administrator permissions.
   */
  delete is ArmResourceDeleteWithoutOkAsync<ConditionalCreditTransaction>;

  /**
   * List all transactions for a conditional credit.
   */
  listByParent is ArmResourceListByParent<
    ConditionalCreditTransaction,
    Response = ArmResponse<ConditionalCreditTransactionsList>
  >;
}

@@doc(ConditionalCreditTransaction.name, "Name of the transaction");
@@doc(ConditionalCreditTransaction.properties, "Transaction properties");
@@doc(ConditionalCreditTransactions.create::parameters.resource,
  "Transaction create request"
);
@@doc(ConditionalCreditTransactions.update::parameters.properties,
  "Transaction patch request"
);
