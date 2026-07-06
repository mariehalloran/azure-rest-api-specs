import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageArray.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Replication Peering Resource (PRIVATE PREVIEW) ====================
//
// `replicationPeerings` is a proxy child of `storageArrays` — an array-to-array
// trust/network relationship, discovered read-only by the storage controller.
// PRIVATE PREVIEW: read-only — GET and LIST only.

/**
 * A replication peering — an array-to-array trust/network relationship
 * (discovered, read-only).
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageArray)
model ReplicationPeering
  is Azure.ResourceManager.ProxyResource<ReplicationPeeringProperties> {
  ...ResourceNameParameter<
    Resource = ReplicationPeering,
    KeyName = "replicationPeeringName",
    SegmentName = "replicationPeerings",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Read-only operations for replication peerings.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ReplicationPeerings {
  /** Get a replication peering. */
  get is ArmResourceRead<ReplicationPeering>;

  /** List replication peerings on a storage array. */
  list is ArmResourceListByParent<ReplicationPeering>;
}
