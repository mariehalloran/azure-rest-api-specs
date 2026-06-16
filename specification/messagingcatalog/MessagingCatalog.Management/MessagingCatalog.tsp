import "@azure-tools/typespec-azure-core";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "@typespec/http";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.MessagingCatalog;
/**
 * A Messaging Catalog resource
 */
model MessagingCatalog
  is Azure.ResourceManager.TrackedResource<MessagingCatalogProperties> {
  /**
   * The name of the Messaging Catalog
   */
  @pattern("^[a-zA-Z0-9-]{3,60}$")
  @minLength(3)
  @maxLength(60)
  @path
  @key("catalogName")
  @segment("catalogs")
  @visibility(Lifecycle.Read)
  name: string;

  /**
   * The managed service identities assigned to this resource, used to access the
   * customer-managed key in Key Vault.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Version-gated identity must be an explicit @added property because TypeSpec spreads cannot be versioned; the emitted swagger still places identity at the resource envelope top level referencing common-types ManagedServiceIdentity."
  @added(Versions.v2026_06_01_preview)
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentity;
}

@armResourceOperations
interface MessagingCatalogs {
  /**
   * Get a messaging catalog
   */
  get is ArmResourceRead<MessagingCatalog>;

  /**
   * Create or update a messaging catalog
   */
  create is ArmResourceCreateOrReplaceAsync<MessagingCatalog>;

  /**
   * Update a messaging catalogs
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<MessagingCatalog, MessagingCatalogUpdate>;

  /**
   * Delete a messaging catalogs
   */
  delete is ArmResourceDeleteSync<MessagingCatalog>;

  /**
   * List MessagingCatalog resources by resource group
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "For backward compatibility"
  @operationId("MessagingCatalogs_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<MessagingCatalog>;

  /**
   * List MessagingCatalog resources by subscription ID
   */
  listBySubscription is ArmListBySubscription<MessagingCatalog>;

  @added(Versions.v2024_10_01_preview)
  associate is ArmResourceActionAsync<
    MessagingCatalog,
    Association,
    Association,
    BaseParameters<Association>
  >;

  @added(Versions.v2024_10_01_preview)
  listAssociations is ArmResourceActionAsync<
    MessagingCatalog,
    AssociationListRequest,
    AssociationListResponse
  >;

  @added(Versions.v2024_10_01_preview)
  removeAssociation is ArmResourceActionAsync<
    MessagingCatalog,
    AssociationRemoveRequest,
    AssociationDeleteResponse
  >;

  @added(Versions.v2025_11_01_preview)
  updateFabricPrivateLinks is ArmResourceActionAsync<
    MessagingCatalog,
    FabricPrivateLinksRequest,
    FabricPrivateLinksResponse
  >;

  /**
   * Verify that the customer-managed key encryption configured on the catalog is healthy.
   * Performs a liveness unwrap of the stored data encryption key plus a fresh wrap/unwrap
   * round-trip through the live key encryption key. Read-only and idempotent.
   */
  @added(Versions.v2026_06_01_preview)
  verifyEncryption is ArmResourceActionSync<
    MessagingCatalog,
    void,
    CmkVerifyResult
  >;
}
