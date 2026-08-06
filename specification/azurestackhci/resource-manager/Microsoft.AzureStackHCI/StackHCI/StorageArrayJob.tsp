import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageArray.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Storage Array Jobs Resource ====================
//
// `jobs` is a proxy child of `storageArrays` representing a long running,
// actionable operation on a storage array (e.g. forcing an inventory sync).
// The job resource is created via ARM, dispatched to the owning device by the
// resource provider, and its terminal state is driven by the device-reported
// status update. This mirrors the clusters/volumes/jobs pattern (see
// ClusterVolumeJob.tsp).

/**
 * Job for a Storage Array.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" ""
@added(Versions.v2026_03_15_preview)
@parentResource(StorageArray)
model StorageArrayJob
  is Azure.ResourceManager.ProxyResource<StorageArrayJobProperties> {
  ...ResourceNameParameter<
    Resource = StorageArrayJob,
    KeyName = "jobName",
    SegmentName = "jobs",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for Storage Array Jobs.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface StorageArrayJobs {
  /** Get a specific storage array job. */
  get is ArmResourceRead<StorageArrayJob>;

  /** List all jobs for a storage array. */
  list is ArmResourceListByParent<StorageArrayJob>;

  /** Create or update a storage array job. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<StorageArrayJob>;

  /** Delete a storage array job. */
  delete is ArmResourceDeleteWithoutOkAsync<StorageArrayJob>;
}
