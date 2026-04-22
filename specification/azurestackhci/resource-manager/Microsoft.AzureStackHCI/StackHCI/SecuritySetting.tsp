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
 * Security settings proxy resource
 */
@parentResource(Cluster)
model SecuritySetting
  is Azure.ResourceManager.ProxyResource<SecurityProperties> {
  @path
  @key("securitySettingsName")
  @segment("securitySettings")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  name: string = "default";

  /** If eTag is provided in the response body, it may also be provided as a header per the normal etag convention. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "eTag is needed for concurrency control"
  @added(Versions.v2026_03_15_preview)
  @visibility(Lifecycle.Read)
  eTag?: string;
}

@armResourceOperations
interface SecuritySettings {
  /**
   * Get a SecuritySetting
   */
  get is ArmResourceRead<SecuritySetting>;

  /**
   * Create a security setting
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<SecuritySetting>;

  /**
   * Delete a SecuritySetting
   */
  delete is ArmResourceDeleteWithoutOkAsync<SecuritySetting>;

  /**
   * List SecuritySetting resources by Clusters
   */
  listByClusters is ArmResourceListByParent<SecuritySetting>;

  /**
   * Remediate a group of settings within SecuritySetting
   */
  @added(Versions.v2026_03_15_preview)
  remediate is ArmResourceActionNoResponseContentAsync<
    SecuritySetting,
    Recommendation
  >;
}

@@doc(SecuritySetting.name, "Name of security setting");
@@doc(SecuritySetting.properties,
  "The resource-specific properties for this resource."
);
@@visibility(SecuritySetting.properties, Lifecycle.Read, Lifecycle.Create);
