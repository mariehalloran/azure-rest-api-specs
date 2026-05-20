import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Cluster.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureStackHCI;

/**
 * Capacity Settings singleton child resource of a cluster. Exposes placement-oriented
 * capacity information for Azure Local clusters, including the applied capacity policy
 * and the latest reported capacity snapshot collated by the service.
 *
 * The resource is hydrated by the service during cluster deployment with the
 * conventional singleton name `default`. The v1 API supports GET (single), LIST, and
 * PATCH (for Day N policy edits). PUT and DELETE are not exposed; clients cannot
 * create or remove the resource directly.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(Cluster)
model CapacitySetting
  is Azure.ResourceManager.ProxyResource<CapacitySettingProperties> {
  @doc("Name of the Capacity Settings singleton. Always `default` in v1.")
  @path
  @key("capacitySettingsName")
  @segment("capacitySettings")
  @pattern("^default$")
  name: string = "default";
}

/**
 * Operations for Capacity Settings. v1 exposes GET (single), LIST by cluster, and
 * PATCH for Day N capacity policy edits. PUT and DELETE are intentionally omitted.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface CapacitySettings {
  /**
   * Get the Capacity Settings singleton for a cluster.
   */
  get is ArmResourceRead<CapacitySetting>;

  /**
   * List the Capacity Settings singletons under a cluster. The collection contains the
   * single `default` resource.
   */
  listByClusters is ArmResourceListByParent<CapacitySetting>;

  /**
   * Update the applied capacity policy on the Capacity Settings singleton (Day N
   * edits). Only `appliedPolicy` fields are updatable; reported capacity and
   * provisioning state remain service-owned.
   */
  update is ArmCustomPatchSync<
    CapacitySetting,
    PatchModel = CapacitySettingPatch
  >;
}

@@doc(
  CapacitySetting.name,
  "Name of the Capacity Settings singleton resource."
);
@@doc(
  CapacitySetting.properties,
  "The resource-specific properties for this resource."
);
