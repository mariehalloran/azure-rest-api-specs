import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./AIGroundingAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AIGrounding;
/**
 * AIGrounding Custom Search Configuration is an Azure resource representing AIGrounding Custom Search configuration type, allowed domains, blocked domains and pinned domains.
 */
@parentResource(AIGroundingAccount)
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
   * Returns an AIGrounding Custom Search configuration specified by the parameters.
   */
  get is ArmResourceRead<CustomSearchConfiguration>;

  /**
   * Creates or Updates an AIGrounding Custom Search configuration.
   * Uses async (LRO) because it calls an external API which takes significant time.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CustomSearchConfiguration>;

  /**
   * Deletes an AIGrounding Custom Search configuration from the AIGrounding account.
   */
  delete is ArmResourceDeleteSync<CustomSearchConfiguration>;

  /**
   * Returns all the AIGrounding Custom Search configurations for the specified AIGrounding account.
   */
  listByAccount is ArmResourceListByParent<CustomSearchConfiguration>;
}

@@maxLength(CustomSearchConfiguration.name, 50);
@@minLength(CustomSearchConfiguration.name, 2);
@@doc(
  CustomSearchConfiguration.name,
  "The name of the AIGrounding custom search configuration."
);
@@doc(
  CustomSearchConfiguration.properties,
  "Properties of AIGrounding Custom Search configuration."
);
@@doc(
  CustomSearchConfigurations.createOrUpdate::parameters.resource,
  "The parameters of the configuration to create or update."
);
