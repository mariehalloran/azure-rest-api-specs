import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("Common API Versions for the Migrate Plan (Data Center Plan) resource.")
enum ApiVersions {
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @doc("2026-06-01-preview API Version.")
  v2026_06_01_preview: "2026-06-01-preview",
}
