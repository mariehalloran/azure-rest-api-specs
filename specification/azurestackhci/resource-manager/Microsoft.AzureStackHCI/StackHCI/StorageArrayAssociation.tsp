import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Cluster.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Storage Array Association Resource (PRIVATE PREVIEW) ====================
//
// `storageArrayAssociations` is a proxy child of `clusters` — links a cluster to
// a storage array (the admin entry point for storage management). Supports N:N.
// PRIVATE PREVIEW: GET and LIST are read-only; PUT (createOrUpdate) and DELETE
// are also exposed.
//
// DELETE detaches the storage array from the cluster. For a Storage Spaces
// Direct (S2D) array — which has no lifecycle independent of its owning cluster
// — deleting the association also deletes the storage array itself. Directly
// deleting the association of an S2D array owned by the cluster is rejected;
// it is removed only as part of deleting the cluster.

/**
 * A storage-array association — links a cluster to a storage array.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(Cluster)
model StorageArrayAssociation
  is Azure.ResourceManager.ProxyResource<StorageArrayAssociationProperties> {
  ...ResourceNameParameter<
    Resource = StorageArrayAssociation,
    KeyName = "storageArrayAssociationName",
    SegmentName = "storageArrayAssociations",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for storage-array associations. GET and LIST are read-only; PUT
 * (createOrUpdate) edits the settings; DELETE detaches the storage array from
 * the cluster.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageArrayAssociations {
  /** Get a storage-array association. */
  get is ArmResourceRead<StorageArrayAssociation>;

  /** List storage-array associations on a cluster. */
  list is ArmResourceListByParent<StorageArrayAssociation>;

  /** Create or update a storage-array association. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<StorageArrayAssociation>;

  /**
   * Delete a storage-array association, detaching the storage array from the
   * cluster. Deleting the association of a Storage Spaces Direct (S2D) array
   * owned by this cluster also deletes that storage array; such an association
   * cannot be deleted directly and is removed only when the cluster is deleted.
   */
  delete is ArmResourceDeleteWithoutOkAsync<StorageArrayAssociation>;
}
