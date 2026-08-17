import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./shared-models.tsp";
import "./patch-models.tsp";
import "./workspace.tsp";
import "./cluster.tsp";
import "./kubernetes-models.tsp";
import "./workload-models.tsp";

using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

@armProviderNamespace("Microsoft.SecurityBasePlatform")
@service(#{ title: "Microsoft.SecurityBasePlatform" })
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
@versioned(Microsoft.SecurityBasePlatform.Versions)
namespace Microsoft.SecurityBasePlatform;

@doc("Supported API versions for the Microsoft.SecurityBasePlatform resource provider.")
enum Versions {
  @doc("The 2025-03-01-preview version.")
  @Versioning.useDependency(Azure.ResourceManager.CommonTypes.Versions.v6)
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @previewVersion
  v2025_03_01_preview: "2025-03-01-preview",
}
