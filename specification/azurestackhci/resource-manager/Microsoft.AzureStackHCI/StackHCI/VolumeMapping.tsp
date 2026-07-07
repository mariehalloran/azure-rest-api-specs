import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./VolumeGroup.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Volume Mapping Resource (PRIVATE PREVIEW) ====================
//
// `volumeMappings` is a proxy child of `volumeGroups` representing the access
// mapping between a volume and an initiator group. PRIVATE PREVIEW: read-only —
// only GET and LIST are exposed.

/**
 * The access mapping between a volume and an initiator group.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(VolumeGroup)
model VolumeMapping
  is Azure.ResourceManager.ProxyResource<VolumeMappingProperties> {
  ...ResourceNameParameter<
    Resource = VolumeMapping,
    KeyName = "volumeMappingName",
    SegmentName = "volumeMappings",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Read-only operations for volume mappings.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface VolumeMappings {
  /** Get a volume mapping. */
  get is ArmResourceRead<VolumeMapping>;

  /** List volume mappings in a volume group. */
  list is ArmResourceListByParent<VolumeMapping>;
}
