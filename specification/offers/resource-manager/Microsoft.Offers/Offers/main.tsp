import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./valueExchanges.tsp";
import "./enumerations.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

/** Microsoft.Offers Resource Provider management API. */
@armProviderNamespace("Microsoft.Offers")
@service(#{ title: "Microsoft Offers" })
@versioned(Microsoft.Offers.Versions)
namespace Microsoft.Offers;

/** The available API versions for the Offers service. */
enum Versions {
  /** The 2026-04-24-preview API version. */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @previewVersion
  v2026_04_24_preview: "2026-04-24-preview",
}

/** The operations supported by the Microsoft.Offers resource provider. */
interface Operations extends Azure.ResourceManager.Operations {}

@@doc(
  Operations.list,
  "List the operations for the Microsoft.Offers resource provider."
);
