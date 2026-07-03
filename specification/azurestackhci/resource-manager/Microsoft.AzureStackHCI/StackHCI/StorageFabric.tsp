import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Storage Fabric Resource (PRIVATE PREVIEW) ====================
//
// `storageFabrics` is a top-level (tracked) resource — an FC fabric (Brocade
// switch/director) that contains zones and aliases (child resources).
// PRIVATE PREVIEW: read-only — only GET and LIST are exposed.

/**
 * A storage fabric — an FC fabric (Brocade switch or director).
 */
@added(Versions.v2026_03_15_preview)
model StorageFabric
  is Azure.ResourceManager.TrackedResource<StorageFabricProperties> {
  ...ResourceNameParameter<
    Resource = StorageFabric,
    KeyName = "storageFabricName",
    SegmentName = "storageFabrics",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Read-only operations for storage fabrics.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageFabrics {
  /** Get a storage fabric. */
  get is ArmResourceRead<StorageFabric>;

  /** List storage fabrics in a resource group. */
  listByResourceGroup is ArmResourceListByParent<StorageFabric>;

  /** List storage fabrics in a subscription. */
  listBySubscription is ArmListBySubscription<StorageFabric>;
}
