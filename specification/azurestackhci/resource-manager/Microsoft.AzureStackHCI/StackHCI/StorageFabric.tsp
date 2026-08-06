import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "@typespec/http";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Storage Fabric Resource (PRIVATE PREVIEW) ====================
//
// `storageFabrics` is a top-level (tracked) resource — an FC fabric (Brocade
// switch/director) that contains zones and aliases (child resources).
// PRIVATE PREVIEW: read-only data (GET/LIST); create/update/delete are placeholders
// for ARM tracked-resource lifecycle compliance (only tags are settable).

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
 * Operations for storage fabrics. Data is read-only (GET/LIST); create/update/
 * delete are placeholders for ARM tracked-resource lifecycle compliance.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageFabrics {
  /** Get a storage fabric. */
  get is ArmResourceRead<StorageFabric>;

  /** Create or update a storage fabric (placeholder; only tags are settable). */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<StorageFabric>;

  /** Update a storage fabric's tags (placeholder). */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<StorageFabric, StorageFabricPatch>;

  /** Delete a storage fabric (placeholder). */
  delete is ArmResourceDeleteWithoutOkAsync<StorageFabric>;

  /** List storage fabrics in a resource group. */
  listByResourceGroup is ArmResourceListByParent<StorageFabric>;

  /** List storage fabrics in a subscription. */
  listBySubscription is ArmListBySubscription<StorageFabric>;
}
