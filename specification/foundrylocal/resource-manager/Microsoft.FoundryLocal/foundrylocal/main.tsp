import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-resource-manager";

import "./modelDeployment.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

@armProviderNamespace
@service(#{ title: "Microsoft.FoundryLocal management service" })
@doc("Microsoft.FoundryLocal Resource Provider management API.")
@versioned(Versions)
namespace Microsoft.FoundryLocal;

@doc("Microsoft.FoundryLocal Resource Provider supported API versions.")
enum Versions {
  @doc("Microsoft.FoundryLocal Resource Provider management API version 2026-05-01-preview.")
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_05_01_preview: "2026-05-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}
