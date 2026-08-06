using Azure.ResourceManager;
using TypeSpec.Versioning;

namespace Microsoft.Migrate;

@added(ApiVersions.v2026_06_15_preview)
@doc("The type of a Migrate artifact. The type is extensible so additional artifact kinds can be introduced in future versions.")
union ArtifactType {
  @doc("A wave report artifact.")
  WaveReport: "WaveReport",

  @doc("A wave plan artifact.")
  WavePlan: "WavePlan",

  @doc("A data center plan artifact.")
  DCPlan: "DCPlan",

  @doc("A current target design (CTD) artifact.")
  CTD: "CTD",

  string,
}

@added(ApiVersions.v2026_06_15_preview)
@doc("The mode used when generating a download URL for an artifact. The mode is extensible so additional download modes can be introduced in future versions.")
union DownloadMode {
  @doc("Download a single file within the artifact.")
  File: "file",

  @doc("Download a directory within the artifact.")
  Directory: "directory",

  string,
}
