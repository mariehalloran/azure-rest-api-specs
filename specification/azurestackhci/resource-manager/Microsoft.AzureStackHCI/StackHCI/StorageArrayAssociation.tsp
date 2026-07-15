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
// PRIVATE PREVIEW: GET and LIST are read-only; PUT (createOrUpdate) is also
// exposed.

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
 * (createOrUpdate) edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Storage-array associations are discovered from the cluster and cannot be created or deleted through ARM; PUT only edits the settings of an existing storage-array association."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageArrayAssociations {
  /** Get a storage-array association. */
  get is ArmResourceRead<StorageArrayAssociation>;

  /** List storage-array associations on a cluster. */
  list is ArmResourceListByParent<StorageArrayAssociation>;

  /** Create or update a storage-array association. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<StorageArrayAssociation>;
}
