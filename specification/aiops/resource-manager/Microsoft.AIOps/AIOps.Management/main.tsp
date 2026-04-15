import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./service.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

/** Microsoft.AIOps Resource Provider management API. */
@armProviderNamespace
@service(#{ title: "Microsoft.AIOps management service" })
@versioned(Microsoft.AIOps.Versions)
namespace Microsoft.AIOps;

/** The available API versions. */
enum Versions {
  /** 2026-05-01-preview version */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @Azure.Core.previewVersion
  v2026_05_01_preview: "2026-05-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}
