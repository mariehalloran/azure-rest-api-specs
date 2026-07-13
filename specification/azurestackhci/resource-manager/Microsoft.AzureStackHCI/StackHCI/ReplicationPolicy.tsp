import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageArray.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Replication Policy Resource (PRIVATE PREVIEW) ====================
//
// `replicationPolicies` is a proxy child of `storageArrays` — a discovered
// vendor replication policy. PRIVATE PREVIEW: GET and LIST are read-only; PUT
// (createOrUpdate) is also exposed.

/**
 * A replication policy — a discovered vendor policy defining RPO, schedule, and
 * retention (read-only).
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageArray)
model ReplicationPolicy
  is Azure.ResourceManager.ProxyResource<ReplicationPolicyProperties> {
  ...ResourceNameParameter<
    Resource = ReplicationPolicy,
    KeyName = "replicationPolicyName",
    SegmentName = "replicationPolicies",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for replication policies. GET and LIST are read-only; PUT
 * (createOrUpdate) edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Replication policies are discovered from the storage array and cannot be created or deleted through ARM; PUT only edits the settings of an existing replication policy."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ReplicationPolicies {
  /** Get a replication policy. */
  get is ArmResourceRead<ReplicationPolicy>;

  /** List replication policies on a storage array. */
  list is ArmResourceListByParent<ReplicationPolicy>;

  /** Create or update a replication policy. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ReplicationPolicy>;
}
