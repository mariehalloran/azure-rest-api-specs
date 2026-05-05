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
@added(Versions.v2026_02_01)
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
  @added(Versions.v2026_02_01)
  get is ArmResourceRead<ConditionalCreditTransaction>;

  /**
   * Create or replace a transaction for a conditional credit. This operation requires administrator permissions.
   */
  @added(Versions.v2026_02_01)
  create is ArmResourceCreateOrReplaceAsync<ConditionalCreditTransaction>;

  /**
   * Update a transaction for a conditional credit, reserved for admin-only operations routed through RPaaS.
   */
  @added(Versions.v2026_02_01)
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    ConditionalCreditTransaction,
    PatchModel = TransactionPatchRequest
  >;

  /**
   * Delete a transaction for a conditional credit. This operation requires administrator permissions.
   */
  @added(Versions.v2026_02_01)
  delete is ArmResourceDeleteWithoutOkAsync<ConditionalCreditTransaction>;

  /**
   * List all transactions for a conditional credit.
   */
  @added(Versions.v2026_02_01)
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
