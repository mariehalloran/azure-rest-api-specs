import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageArray.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Storage Pool Resource (PRIVATE PREVIEW) ====================
//
// `storagePools` is a proxy child of `storageArrays` representing a capacity
// source. SAN pools are discovered read-only; S2D pools carry additional settings
// in the design spec. PRIVATE PREVIEW: read-only — only GET and LIST are exposed.

/**
 * A storage pool — a capacity source on a storage array.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageArray)
model StoragePool
  is Azure.ResourceManager.ProxyResource<StoragePoolProperties> {
  ...ResourceNameParameter<
    Resource = StoragePool,
    KeyName = "storagePoolName",
    SegmentName = "storagePools",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Read-only operations for storage pools.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StoragePools {
  /** Get a storage pool. */
  get is ArmResourceRead<StoragePool>;

  /** List storage pools on a storage array. */
  list is ArmResourceListByParent<StoragePool>;
}
