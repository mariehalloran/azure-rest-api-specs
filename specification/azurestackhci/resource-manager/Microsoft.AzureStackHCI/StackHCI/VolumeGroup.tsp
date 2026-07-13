import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageArray.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Volume Group Resource (PRIVATE PREVIEW) ====================
//
// `volumeGroups` is a proxy child of `storageArrays` — the administrative scope
// for naming, RBAC, quota, and multi-tenancy. Volumes and volume mappings are its
// children. PRIVATE PREVIEW: GET and LIST are read-only; PUT (createOrUpdate) is
// also exposed.

/**
 * A volume group — the administrative scope for volumes on a storage array.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageArray)
model VolumeGroup
  is Azure.ResourceManager.ProxyResource<VolumeGroupProperties> {
  ...ResourceNameParameter<
    Resource = VolumeGroup,
    KeyName = "volumeGroupName",
    SegmentName = "volumeGroups",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for volume groups. GET and LIST are read-only; PUT (createOrUpdate)
 * edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Volume groups are discovered from the storage array and cannot be created or deleted through ARM; PUT only edits the settings of an existing volume group."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface VolumeGroups {
  /** Get a volume group. */
  get is ArmResourceRead<VolumeGroup>;

  /** List volume groups on a storage array. */
  list is ArmResourceListByParent<VolumeGroup>;

  /** Create or update a volume group. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<VolumeGroup>;
}
