import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

// Common list of supported API versions.
import "./ApiVersions.tsp";

// All service routes.
import "./routes.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using OpenAPI;

@armProviderNamespace
@service(#{ title: "Azure Migrate Platform Landing Zones Service" })
@versioned(ApiVersions)
@doc("Azure Migrate Platform Landing Zones management API. Captures the architectural intent for an Azure Landing Zone deployment associated with a migrate project.")
namespace Microsoft.Migrate;

interface Operations extends Azure.ResourceManager.Operations {}
