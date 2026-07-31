import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-autorest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./CloudPcDelegatedMsi.tsp";
import "./ServiceConnector.tsp";
import "./client.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

@doc("Windows365 Resource Provider management API.")
@armProviderNamespace("Microsoft.Windows365")
@service(#{ title: "Windows365" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
namespace Microsoft.Windows365;

/** The available API versions. */
enum Versions {
  /** The 2026-09-01-preview API version. */
  @previewVersion
  v2026_09_01_preview: "2026-09-01-preview",
}

/** Resource provider operations. */
interface Operations {
  #suppress "@azure-tools/typespec-azure-core/no-private-usage" "For backward compatibility with the existing operations route shape."
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "For backward compatibility with the existing operations route shape."
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
