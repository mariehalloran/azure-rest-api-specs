import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./operation.tsp";
import "./common.tsp";
import "./securityVulnerability.tsp";
import "./internetExposure.tsp";
import "./codeWeakness.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

/** Microsoft.SecurityContext Resource Provider management API. */
@armProviderNamespace
@service(#{ title: "Microsoft.SecurityContext management service" })
@versioned(Microsoft.SecurityContext.Versions)
namespace Microsoft.SecurityContext;

/** The available API versions. */
enum Versions {
  /** 2026-06-30-preview version. */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_06_30_preview: "2026-06-30-preview",

  /** 2026-07-13-preview version. */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @Azure.Core.previewVersion
  v2026_07_13_preview: "2026-07-13-preview",
}
