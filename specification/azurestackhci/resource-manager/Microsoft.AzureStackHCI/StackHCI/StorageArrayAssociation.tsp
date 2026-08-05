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
// DELETE is driven by cluster deletion. Deleting a cluster cascades to its child
// associations, and each association is torn down in order: the deletion is
// validated, the referenced Storage Spaces Direct (S2D) storage array is
// deleted, and the association is then removed. A storage array is a top-level
// tracked resource rather than an ARM child of the cluster, so the association is
// the last record of which array belonged to the cluster and the only point at
// which an S2D array can be reclaimed.
//
// SAN arrays are never deleted by this operation. They represent external
// hardware that may be shared by several clusters, so only the association is
// removed. A direct request to delete an association that references an S2D array
// owned by the cluster is rejected; such associations are removed only as part of
// deleting their cluster.

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
 * (createOrUpdate) edits the settings; DELETE removes the association and, for a
 * Storage Spaces Direct (S2D) array, the storage array it references.
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
   * Delete a storage-array association. Associations are removed as part of
   * deleting their owning cluster, which cascades the deletion to its children:
   * the request is validated, the referenced Storage Spaces Direct (S2D) storage
   * array is deleted, and the association is then removed. SAN arrays are not
   * deleted, as they may be shared by several clusters; only the association is
   * removed. A direct request to delete an association that references an S2D
   * array owned by the cluster is rejected.
   */
  delete is ArmResourceDeleteWithoutOkAsync<StorageArrayAssociation>;
}
