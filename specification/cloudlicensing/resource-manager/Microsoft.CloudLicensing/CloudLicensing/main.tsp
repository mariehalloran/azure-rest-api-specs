import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Allotment.tsp";
import "./Assignment.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;

/**
 * Microsoft Cloud Licensing Resource Provider for managing license allotments and assignments.
 */
@armProviderNamespace
@service(#{ title: "CloudLicensingManagementClient" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
namespace Microsoft.CloudLicensing;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2025-07-01-preview API version.
   */
  v2025_07_01_preview: "2025-07-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}
