import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

// Common list of supported API versions.
import "./ApiVersions.tsp";

// Migrate project resource.
import "./MigrateProjects/MigrateProject.tsp";

// Migrate plan (Data Center Plan) routes.
import "./MigratePlans/routes.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using OpenAPI;

#suppress "@azure-tools/typespec-azure-resource-manager/missing-operations-endpoint" "Operations API is centrally implemented at the AssessmentProjects level and intentionally excluded from individual Migrate service specifications to avoid duplication across SDKs."
@armProviderNamespace
@service(#{ title: "Azure Migrate Projects Service" })
@versioned(ApiVersions)
@doc("Azure Migrate Resource Provider management API for Migrate projects and their child resources.")
namespace Microsoft.Migrate;
