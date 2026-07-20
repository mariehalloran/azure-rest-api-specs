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
// trust/network relationship, discovered by the storage controller.
// PRIVATE PREVIEW: GET and LIST are read-only; PUT (createOrUpdate) is also
// exposed.

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
 * Operations for replication peerings. GET and LIST are read-only; PUT
 * (createOrUpdate) edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Replication peerings are discovered from the storage array and cannot be created or deleted through ARM; PUT only edits the settings of an existing replication peering."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ReplicationPeerings {
  /** Get a replication peering. */
  get is ArmResourceRead<ReplicationPeering>;

  /** List replication peerings on a storage array. */
  list is ArmResourceListByParent<ReplicationPeering>;

  /** Create or update a replication peering. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ReplicationPeering>;
}
