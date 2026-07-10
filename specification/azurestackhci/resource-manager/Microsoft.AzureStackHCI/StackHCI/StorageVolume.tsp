import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./VolumeGroup.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Storage Volume Resource (PRIVATE PREVIEW) ====================
//
// `volumes` is a proxy child of `volumeGroups` representing an array-side block
// volume (LUN / LDEV / VV / S2D virtual disk). PRIVATE PREVIEW: GET and LIST are
// read-only; PUT (createOrUpdate) is also exposed.

/**
 * An array-side block volume, child of a volume group.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(VolumeGroup)
model StorageVolume
  is Azure.ResourceManager.ProxyResource<StorageVolumeProperties> {
  ...ResourceNameParameter<
    Resource = StorageVolume,
    KeyName = "volumeName",
    SegmentName = "volumes",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for storage volumes. GET and LIST are read-only; PUT (createOrUpdate)
 * edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Storage volumes are discovered from the volume group and cannot be created or deleted through ARM; PUT only edits the settings of an existing storage volume."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageVolumes {
  /** Get a storage volume. */
  get is ArmResourceRead<StorageVolume>;

  /** List storage volumes in a volume group. */
  list is ArmResourceListByParent<StorageVolume>;

  /** Create or update a storage volume. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<StorageVolume>;
}
