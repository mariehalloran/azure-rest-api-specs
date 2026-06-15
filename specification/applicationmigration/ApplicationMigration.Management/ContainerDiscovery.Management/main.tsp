/**
 * Azure Migrate Container Workload Discovery TypeSpec definition.
 * Defines ARM resources for container cluster, node, and workload discovery.
 */
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./ContainerSite.tsp";
import "./ContainerCluster.tsp";
import "./ContainerNode.tsp";
import "./ContainerWorkload.tsp";
import "./ContainerAgent.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;

/**
 * The Microsoft.ApplicationMigration Rest API spec for Container Discovery.
 */
@armProviderNamespace
@service(#{ title: "Microsoft.ApplicationMigration management service" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
namespace Microsoft.ApplicationMigration;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2026-06-01-preview API version.
   */
  v2026_06_01_preview: "2026-06-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}
