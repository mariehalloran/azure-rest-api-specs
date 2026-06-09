import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./operation.tsp";
import "./environmentGroupRule.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

/** Microsoft.PowerPlatform Resource Provider management API. */
@armProviderNamespace
@service(#{ title: "Microsoft.PowerPlatform management service" })
@versioned(Microsoft.PowerPlatform.Versions)
namespace Microsoft.PowerPlatform;

/** The available API versions. */
enum Versions {
  /** 2026-04-01-preview version */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_04_01_preview: "2026-04-01-preview",
}
