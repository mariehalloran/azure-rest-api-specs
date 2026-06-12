import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.ApplicationMigration;

/**
 * The ContainerSite resource — top-level tracked resource for container discovery.
 * Parent for containerClusters, containerWorkloads, and containerAgents.
 */
model ContainerSite
  is Azure.ResourceManager.TrackedResource<ContainerSiteProperties, false> {
  ...ResourceNameParameter<
    Resource = ContainerSite,
    KeyName = "siteName",
    SegmentName = "containerSites",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  >;
}

/**
 * ContainerSite properties.
 */
model ContainerSiteProperties is AzureResourceProperties {
  @doc("The mapped master Site ID.")
  masterSiteId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OffAzure/masterSites";
    }
  ]>;

  @doc("The mapped migrate project ID.")
  migrateProjectId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Migrate/migrateProjects";
    }
  ]>;

  @doc("The extended location for off-azure resources.")
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface ContainerSites {
  get is ArmResourceRead<ContainerSite>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ContainerSite>;
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<ContainerSite, SiteTagsPatch>;
  delete is ArmResourceDeleteSync<ContainerSite>;
  listByResourceGroup is ArmResourceListByParent<ContainerSite>;
  listBySubscription is ArmListBySubscription<ContainerSite>;

  /**
   * Trigger Refresh action
   */
  //#suppress "@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes" ""
  @action("refresh")
  triggerRefresh is ArmResourceActionNoResponseContentAsync<
    ContainerSite,
    void
  >;
}

@@maxLength(ContainerSite.name, 63);
@@minLength(ContainerSite.name, 3);
@@doc(ContainerSite.name, "The name of the container site.");
@@doc(ContainerSite.properties, "Container site properties.");
