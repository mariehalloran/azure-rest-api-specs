import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./ConfigurationValidationResults.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Workloads;

@doc("Configuration validation run. A run represents the complete, immutable results of a single configuration validation execution for a configuration validation result.")
@added(Versions.v2026_07_01_preview)
@parentResource(ConfigurationValidationResults)
model ConfigurationValidationRun
  is ProxyResource<ConfigurationValidationRunProperties> {
  /**
   * Defines the parameters for naming the configuration validation run resource.
   */
  ...ResourceNameParameter<
    Resource = ConfigurationValidationRun,
    KeyName = "runName",
    SegmentName = "runs",
    NamePattern = "^[a-zA-Z][a-zA-Z0-9_-]{2,80}"
  >;
}

@added(Versions.v2026_07_01_preview)
@armResourceOperations
@doc("Operations related to retrieving configuration validation runs.")
interface ConfigurationValidationRunsOperations {
  /**
   * Gets a configuration validation run for a configuration validation result.
   */
  get is ArmResourceRead<ConfigurationValidationRun>;

  /**
   * Gets all configuration validation runs for a configuration validation result.
   */
  listByConfigurationValidationResults is ArmResourceListByParent<ConfigurationValidationRun>;
}
