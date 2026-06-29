import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./DevelopmentCloudPcDelegatedMsi.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
/**
 * Windows365 Resource Provider management API for Development purpose, Dont use for production.
 */
@armProviderNamespace
@service(#{ title: "DevelopmentWindows365" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v3)
namespace Microsoft.DevelopmentWindows365;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2023-11-01-preview API version.
   */
  v2023_11_01_preview: "2023-11-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}
