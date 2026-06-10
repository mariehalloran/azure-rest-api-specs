import "@typespec/versioning";

using TypeSpec.Versioning;

namespace Microsoft.Bami;

@doc("Supported API versions.")
enum Versions {
  @doc("API version 2026-06-01-preview")
  v2026_06_01_preview: "2026-06-01-preview",
}
