import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageArray.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Replication Unit Resource (PRIVATE PREVIEW) ====================
//
// `replicationUnits` is a proxy child of `storageArrays` — wraps a single volume
// or a consistency group as the unit of replication. PRIVATE PREVIEW: read-only —
// GET and LIST only (DR actions are out of scope for this preview).

/**
 * A replication unit — the unit of replication (a volume or a consistency group).
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageArray)
model ReplicationUnit
  is Azure.ResourceManager.ProxyResource<ReplicationUnitProperties> {
  ...ResourceNameParameter<
    Resource = ReplicationUnit,
    KeyName = "replicationUnitName",
    SegmentName = "replicationUnits",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Read-only operations for replication units.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ReplicationUnits {
  /** Get a replication unit. */
  get is ArmResourceRead<ReplicationUnit>;

  /** List replication units on a storage array. */
  list is ArmResourceListByParent<ReplicationUnit>;
}
