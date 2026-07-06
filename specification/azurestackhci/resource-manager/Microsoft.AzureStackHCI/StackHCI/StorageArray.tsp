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

// ==================== Storage Array Resource (PRIVATE PREVIEW) ====================
//
// `storageArrays` is the top-level (tracked) resource representing a single
// external SAN array or a local Storage Spaces Direct (S2D) pool. Controllers,
// ports, targets, subsystems, drives, and jobs are returned inline via the
// read-only `status` sub-object rather than as separate child resources.
//
// PRIVATE PREVIEW: read-only data surface. GET + LIST return data; the
// create/update/delete operations are placeholders required for ARM tracked-
// resource lifecycle (no domain properties are settable — see models.tsp).

/**
 * A storage array — an external SAN array or a local Storage Spaces Direct (S2D)
 * pool managed by Azure Local.
 */
@added(Versions.v2026_03_15_preview)
model StorageArray
  is Azure.ResourceManager.TrackedResource<StorageArrayProperties> {
  ...ResourceNameParameter<
    Resource = StorageArray,
    KeyName = "storageArrayName",
    SegmentName = "storageArrays",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for storage arrays. Data is read-only (GET/LIST); create/update/
 * delete are placeholders for ARM tracked-resource lifecycle compliance.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageArrays {
  /** Get a storage array. */
  get is ArmResourceRead<StorageArray>;

  /** Create or update a storage array (placeholder; only tags are settable). */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<StorageArray>;

  /** Update a storage array's tags (placeholder). */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<StorageArray, StorageArrayPatch>;

  /** Delete a storage array (placeholder). */
  delete is ArmResourceDeleteWithoutOkAsync<StorageArray>;

  /** List storage arrays in a resource group. */
  listByResourceGroup is ArmResourceListByParent<StorageArray>;

  /** List storage arrays in a subscription. */
  listBySubscription is ArmListBySubscription<StorageArray>;
}
