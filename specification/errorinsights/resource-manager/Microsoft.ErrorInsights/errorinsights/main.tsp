import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./errors.tsp";
import "./errorClusters.tsp";

using Http;
using Rest;
using Versioning;
using Azure.Core;
using Azure.ResourceManager;

/** Microsoft.ErrorInsights Resource Provider management API. */
@armProviderNamespace
@service(#{ title: "Microsoft.ErrorInsights management service" })
@versioned(Microsoft.ErrorInsights.Versions)
namespace Microsoft.ErrorInsights;

/** The available API versions. */
enum Versions {
  /** 2026-05-01-preview version */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  v2026_05_01_preview: "2026-05-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}
