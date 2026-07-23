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
// or a consistency group as the unit of replication. PRIVATE PREVIEW: GET and
// LIST are read-only; PUT (createOrUpdate) is also exposed (DR actions are out of
// scope for this preview).

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
 * Operations for replication units. GET and LIST are read-only; PUT
 * (createOrUpdate) edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Replication units are discovered from the storage array and cannot be created or deleted through ARM; PUT only edits the settings of an existing replication unit."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ReplicationUnits {
  /** Get a replication unit. */
  get is ArmResourceRead<ReplicationUnit>;

  /** List replication units on a storage array. */
  list is ArmResourceListByParent<ReplicationUnit>;

  /** Create or update a replication unit. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ReplicationUnit>;
}
