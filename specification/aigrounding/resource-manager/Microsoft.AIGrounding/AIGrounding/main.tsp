import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./client.tsp";
import "./CustomSearchConfiguration.tsp";
import "./AIGroundingAccount.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
/**
 * Microsoft.AIGrounding Resource Provider
 */
@armProviderNamespace
@service(#{ title: "Azure AIGrounding Resources" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
namespace Microsoft.AIGrounding;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2026-06-01-preview API version.
   */
  @previewVersion
  v2026_06_01_preview: "2026-06-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}
