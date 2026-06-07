import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./WebIQAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.WebIQ;
/**
 * WebIQ Custom Search Configuration is an Azure resource representing WebIQ Custom Search configuration type, allowed domains, blocked domains and pinned domains.
 */
@parentResource(WebIQAccount)
model CustomSearchConfiguration
  is Azure.ResourceManager.ProxyResource<CustomConfigurationProperties> {
  ...ResourceNameParameter<
    Resource = CustomSearchConfiguration,
    KeyName = "customSearchConfigurationName",
    SegmentName = "customSearchConfigurations",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9_.-]*[a-zA-Z0-9])?$"
  >;
}

@armResourceOperations
interface CustomSearchConfigurations {
  /**
   * Returns an WebIQ Custom Search configuration specified by the parameters.
   */
  get is ArmResourceRead<CustomSearchConfiguration>;

  /**
   * Creates or Updates an WebIQ Custom Search configuration.
   * Uses async (LRO) because it calls an external API which takes significant time.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CustomSearchConfiguration>;

  /**
   * Deletes an WebIQ Custom Search configuration from the WebIQ account.
   */
  delete is ArmResourceDeleteSync<CustomSearchConfiguration>;

  /**
   * Returns all the WebIQ Custom Search configurations for the specified WebIQ account.
   */
  listByAccount is ArmResourceListByParent<CustomSearchConfiguration>;
}

@@maxLength(CustomSearchConfiguration.name, 50);
@@minLength(CustomSearchConfiguration.name, 2);
@@doc(
  CustomSearchConfiguration.name,
  "The name of the WebIQ custom search configuration."
);
@@doc(
  CustomSearchConfiguration.properties,
  "Properties of WebIQ Custom Search configuration."
);
@@doc(
  CustomSearchConfigurations.createOrUpdate::parameters.resource,
  "The parameters of the configuration to create or update."
);
