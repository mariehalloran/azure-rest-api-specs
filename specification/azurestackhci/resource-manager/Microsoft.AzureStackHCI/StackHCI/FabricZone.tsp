import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageFabric.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Fabric Zone Resource (PRIVATE PREVIEW) ====================
//
// `fabricZones` is a proxy child of `storageFabrics` — a zone on the fabric switch.
// PRIVATE PREVIEW: read-only — only GET and LIST are exposed.

/**
 * A fabric zone — a zone defined on the fabric switch.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageFabric)
model FabricZone is Azure.ResourceManager.ProxyResource<FabricZoneProperties> {
  ...ResourceNameParameter<
    Resource = FabricZone,
    KeyName = "fabricZoneName",
    SegmentName = "fabricZones",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Read-only operations for fabric zones.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface FabricZones {
  /** Get a fabric zone. */
  get is ArmResourceRead<FabricZone>;

  /** List fabric zones on a storage fabric. */
  list is ArmResourceListByParent<FabricZone>;
}
