import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ReplicationUnit.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Replication Session Resource (PRIVATE PREVIEW) ====================
//
// `replicationSessions` is a proxy child of `replicationUnits` — an active,
// dual-homed replication relationship. PRIVATE PREVIEW: GET and LIST are
// read-only; PUT (createOrUpdate) is also exposed.

/**
 * A replication session — an active replication relationship for a replication
 * unit.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(ReplicationUnit)
model ReplicationSession
  is Azure.ResourceManager.ProxyResource<ReplicationSessionProperties> {
  ...ResourceNameParameter<
    Resource = ReplicationSession,
    KeyName = "replicationSessionName",
    SegmentName = "replicationSessions",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for replication sessions. GET and LIST are read-only; PUT
 * (createOrUpdate) edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Replication sessions are discovered from the replication unit and cannot be created or deleted through ARM; PUT only edits the settings of an existing replication session."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ReplicationSessions {
  /** Get a replication session. */
  get is ArmResourceRead<ReplicationSession>;

  /** List replication sessions on a replication unit. */
  list is ArmResourceListByParent<ReplicationSession>;

  /** Create or update a replication session. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ReplicationSession>;
}
