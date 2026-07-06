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
// `replicationPolicies` is a proxy child of `storageArrays` — a discovered,
// read-only vendor replication policy. PRIVATE PREVIEW: read-only — GET and LIST
// only.

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
 * Read-only operations for replication policies.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ReplicationPolicies {
  /** Get a replication policy. */
  get is ArmResourceRead<ReplicationPolicy>;

  /** List replication policies on a storage array. */
  list is ArmResourceListByParent<ReplicationPolicy>;
}
