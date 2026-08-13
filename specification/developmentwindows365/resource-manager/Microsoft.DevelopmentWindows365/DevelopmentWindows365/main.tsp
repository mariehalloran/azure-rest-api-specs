import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./DevelopmentCloudPcDelegatedMsi.tsp";
import "./client.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
/**
 * Windows365 Resource Provider management API for Development purpose, Dont use for production.
 */
@armProviderNamespace
@service(#{ title: "DevelopmentWindows365" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v3)
namespace Microsoft.DevelopmentWindows365;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2023-11-01-preview API version.
   */
  v2023_11_01_preview: "2023-11-01-preview",
}

interface Operations {
  #suppress "@azure-tools/typespec-azure-core/no-private-usage" "For backward compatibility with the existing operations route shape."
  #suppress "@azure-tools/typespec-azure-resource-manager/use-operation-decorator" "FIXME: review suppression and update justification"
  #suppress "@azure-tools/typespec-azure-resource-manager/use-api-version" "FIXME: review suppression and update justification"
  #suppress "@azure-tools/typespec-azure-resource-manager/use-interface" "For backward compatibility with the existing operations route shape."
  @tag("Operations")
  @autoRoute
  @doc("Lists all of the available resource provider operations.")
  @segment("operations")
  @get
  @list
  list(
    ...Azure.ResourceManager.CommonTypes.ApiVersionParameter,
    ...Azure.ResourceManager.Legacy.Provider,
  ): ArmResponse<OperationListResult> | CloudError;
}
