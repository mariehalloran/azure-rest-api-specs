import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ClusterVolume.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Cluster Volume Jobs Resource ====================

/**
 * Job for a Cluster Volume.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" ""
@added(Versions.v2026_03_15_preview)
@parentResource(ClusterVolume)
model ClusterVolumeJob
  is Azure.ResourceManager.ProxyResource<ClusterVolumeJobProperties> {
  ...ResourceNameParameter<
    Resource = ClusterVolumeJob,
    KeyName = "jobName",
    SegmentName = "jobs",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for Cluster Volume Jobs.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface ClusterVolumeJobs {
  /** Get a specific cluster volume job. */
  get is ArmResourceRead<ClusterVolumeJob>;

  /** List all jobs for a cluster volume. */
  list is ArmResourceListByParent<ClusterVolumeJob>;

  /** Create or update a cluster volume job. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ClusterVolumeJob>;

  /** Delete a cluster volume job. */
  delete is ArmResourceDeleteWithoutOkAsync<ClusterVolumeJob>;
}
