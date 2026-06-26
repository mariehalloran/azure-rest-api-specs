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
@added(Versions.v2024_11_01_preview)
@parentResource(ConfigurationValidationResults)
model Run is ProxyResource<RunProperties> {
  /**
   * Defines the parameters for naming the configuration validation run resource.
   */
  ...ResourceNameParameter<
    Resource = Run,
    KeyName = "runName",
    SegmentName = "runs",
    NamePattern = "^[0-9]{8}T[0-9]{6}Z$"
  >;
}

@added(Versions.v2024_11_01_preview)
@armResourceOperations
@doc("Operations related to retrieving configuration validation runs.")
interface Runs {
  /**
   * Gets a configuration validation run for a configuration validation result.
   */
  get is ArmResourceRead<Run>;

  /**
   * Gets all configuration validation runs for a configuration validation result.
   */
  listByConfigurationValidationResults is ArmResourceListByParent<Run>;
}
