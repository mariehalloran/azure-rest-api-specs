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

  // `identity` is an ARM envelope property that is normally contributed by the resource
  // base template, which would trigger arm-resource-invalid-envelope-property if declared
  // inline. We must declare it inline here because it is only introduced in
  // 2026-06-01-preview (@added) and TypeSpec's template/spread-based envelope cannot be
  // version-gated. The emitter still places it at the resource envelope top level
  // referencing common-types ManagedServiceIdentity, so the suppression is safe.
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Version-gated identity must be an explicit @added property because TypeSpec spreads cannot be versioned; the emitted swagger still places identity at the resource envelope top level referencing common-types ManagedServiceIdentity."
  @doc("The managed service identities assigned to this resource, used to access the customer-managed key in Key Vault.")
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
  @doc("A long-running resource action.")
  associate is ArmResourceActionAsync<
    MessagingCatalog,
    Association,
    Association,
    BaseParameters<Association>
  >;

  @added(Versions.v2024_10_01_preview)
  @doc("A long-running resource action.")
  listAssociations is ArmResourceActionAsync<
    MessagingCatalog,
    AssociationListRequest,
    AssociationListResponse
  >;

  @added(Versions.v2024_10_01_preview)
  @doc("A long-running resource action.")
  removeAssociation is ArmResourceActionAsync<
    MessagingCatalog,
    AssociationRemoveRequest,
    AssociationDeleteResponse
  >;

  @added(Versions.v2025_11_01_preview)
  @doc("A long-running resource action.")
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

  /**
   * Disable customer-managed key encryption on the catalog and revert to a
   * platform-managed key. The stored data encryption key is re-wrapped with the platform
   * key; catalog data itself is not re-encrypted. Returns no content on success; issue a
   * GET to observe the updated encryption status.
   */
  @added(Versions.v2026_06_01_preview)
  disableEncryption is ArmResourceActionNoContentSync<MessagingCatalog, void>;
}
