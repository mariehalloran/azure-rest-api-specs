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
// PRIVATE PREVIEW: read-only — only GET and LIST are exposed.

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
 * Read-only operations for storage-array associations.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageArrayAssociations {
  /** Get a storage-array association. */
  get is ArmResourceRead<StorageArrayAssociation>;

  /** List storage-array associations on a cluster. */
  list is ArmResourceListByParent<StorageArrayAssociation>;
}
