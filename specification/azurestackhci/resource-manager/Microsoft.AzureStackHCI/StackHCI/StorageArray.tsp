import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
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
// PRIVATE PREVIEW: read-only surface — only GET and LIST are exposed.

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
 * Read-only operations for storage arrays.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageArrays {
  /** Get a storage array. */
  get is ArmResourceRead<StorageArray>;

  /** List storage arrays in a resource group. */
  listByResourceGroup is ArmResourceListByParent<StorageArray>;

  /** List storage arrays in a subscription. */
  listBySubscription is ArmListBySubscription<StorageArray>;
}
