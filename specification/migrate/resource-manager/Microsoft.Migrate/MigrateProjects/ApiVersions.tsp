import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("Common API versions for Migrate project resources.")
enum ApiVersions {
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @doc("2026-06-01-preview API Version.")
  v2026_06_01_preview: "2026-06-01-preview",

  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @Azure.Core.previewVersion
  @doc("2026-06-15-preview API Version.")
  v2026_06_15_preview: "2026-06-15-preview",
}
