import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("Common API Versions for the Microsoft.Migrate Platform Landing Zones resource.")
enum ApiVersions {
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @doc("2026-02-01-preview API Version.")
  v2026_02_01_preview: "2026-02-01-preview",
}
