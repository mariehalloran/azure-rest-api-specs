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
// source. Pool settings are discovered and reported read-only by the service.
// PRIVATE PREVIEW: GET and LIST return the full inventory; PUT (createOrUpdate)
// is exposed for ARM lifecycle compliance but carries no client-settable fields.

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
 * Operations for storage pools. GET and LIST are read-only; PUT (createOrUpdate)
 * is exposed for ARM lifecycle compliance.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Storage pools are discovered from the storage array and cannot be created or deleted through ARM."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StoragePools {
  /** Get a storage pool. */
  get is ArmResourceRead<StoragePool>;

  /** List storage pools on a storage array. */
  list is ArmResourceListByParent<StoragePool>;

  /** Create or update a storage pool. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<StoragePool>;
}
