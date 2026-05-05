import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Macc.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.BillingBenefits;

/**
 * Transaction resource definition for Maccs
 */
#suppress "@azure-tools/typespec-azure-resource-manager/empty-updateable-properties" "Admin patches properties server-side via RPaaS; public PATCH body is intentionally empty"
@added(Versions.v2026_02_01)
@parentResource(Macc)
model MaccTransaction
  is Azure.ResourceManager.ProxyResource<TransactionProperties> {
  ...ResourceNameParameter<
    Resource = MaccTransaction,
    KeyName = "transactionName",
    SegmentName = "transactions",
    NamePattern = "^[a-zA-Z0-9_\\-\\.]+$"
  >;
}

@armResourceOperations
interface MaccTransactions {
  /**
   * Get a specific transaction for a MACC.
   */
  @added(Versions.v2026_02_01)
  get is ArmResourceRead<MaccTransaction>;

  /**
   * Create or replace a transaction for a MACC. This operation requires administrator permissions.
   */
  @added(Versions.v2026_02_01)
  create is ArmResourceCreateOrReplaceAsync<MaccTransaction>;

  /**
   * Update a transaction for a MACC, reserved for admin-only operations routed through RPaaS.
   */
  @added(Versions.v2026_02_01)
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    MaccTransaction,
    PatchModel = TransactionPatchRequest
  >;

  /**
   * Delete a transaction for a MACC. This operation requires administrator permissions.
   */
  @added(Versions.v2026_02_01)
  delete is ArmResourceDeleteWithoutOkAsync<MaccTransaction>;

  /**
   * List all transactions for a MACC.
   */
  @added(Versions.v2026_02_01)
  listByParent is ArmResourceListByParent<
    MaccTransaction,
    Response = ArmResponse<MaccTransactionsList>
  >;
}

@@doc(MaccTransaction.name, "Name of the transaction");
@@doc(MaccTransaction.properties, "Transaction properties");
@@doc(MaccTransactions.create::parameters.resource,
  "Transaction create request"
);
@@doc(MaccTransactions.update::parameters.properties,
  "Transaction patch request"
);
