import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./ChatAgents.tsp";

using TypeSpec.Versioning;
using Azure.ResourceManager;

@armProviderNamespace
@service(#{ title: "Microsoft Copilot Service" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
@doc("Microsoft.Copilot Resource Provider API Reference")
namespace Microsoft.Copilot;

@doc("Microsoft.Copilot API versions.")
enum Versions {
  @Azure.Core.previewVersion
  @doc("Microsoft.Copilot API version 2026-05-01-preview.")
  v2026_05_01_preview: "2026-05-01-preview",
}
