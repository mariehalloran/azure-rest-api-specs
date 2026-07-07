import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageArray.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Consistency Group Resource (PRIVATE PREVIEW) ====================
//
// `consistencyGroups` is a proxy child of `storageArrays` — an array-scoped
// grouping of volumes for write-order-consistent snapshots and as a
// replication/failover boundary. PRIVATE PREVIEW: read-only — GET and LIST only.

/**
 * A consistency group — an array-scoped grouping of volumes for consistent
 * snapshots and replication/failover.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageArray)
model ConsistencyGroup
  is Azure.ResourceManager.ProxyResource<ConsistencyGroupProperties> {
  ...ResourceNameParameter<
    Resource = ConsistencyGroup,
    KeyName = "consistencyGroupName",
    SegmentName = "consistencyGroups",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Read-only operations for consistency groups.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ConsistencyGroups {
  /** Get a consistency group. */
  get is ArmResourceRead<ConsistencyGroup>;

  /** List consistency groups on a storage array. */
  list is ArmResourceListByParent<ConsistencyGroup>;
}
