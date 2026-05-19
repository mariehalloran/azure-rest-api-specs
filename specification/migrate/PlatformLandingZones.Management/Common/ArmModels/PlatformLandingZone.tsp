import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "../Enums/Enums.tsp";
import "../Models/PlatformRegion.tsp";
import "../Models/PlatformSubscriptions.tsp";
import "../Models/IdentityConfig.tsp";
import "../Models/Connectivity.tsp";
import "../Models/Management.tsp";
import "../Models/Security.tsp";
import "../Models/Governance.tsp";
import "../Models/CostManagement.tsp";
import "./MigrateProject.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

@parentResource(MigrateProject)
@doc("Platform Landing Zone resource. Captures the architectural intent for an Azure Landing Zone deployment associated with a migrate project.")
model PlatformLandingZone is ProxyResource<PlatformLandingZoneProperties> {
  @doc("Platform Landing Zone name.")
  @segment("platformLandingZones")
  @key("platformLandingZoneName")
  @path
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-_]{1,61}[a-zA-Z0-9]$")
  name: string;
}

@doc("Properties of a Platform Landing Zone. This envelope is grown incrementally as sub-blocks are introduced.")
model PlatformLandingZoneProperties {
  @doc("Platform subscription topology.")
  platformSubscriptions?: PlatformSubscriptions;

  @doc("Identity configuration for the landing zone.")
  identity?: IdentityConfig;

  @doc("Azure regions included in the landing zone design.")
  @identifiers(#["name"])
  regions?: PlatformRegion[];

  @doc("Network connectivity configuration.")
  connectivity?: Connectivity;

  @doc("Management plane configuration.")
  management?: Management;

  @doc("Security configuration.")
  security?: Security;

  @doc("Governance configuration.")
  governance?: Governance;

  @doc("Cost management configuration.")
  costManagement?: CostManagement;

  @doc("Version control system the generator will use when materializing the landing-zone IaC and CI pipelines. When omitted, the generator service applies its default (currently GitHub).")
  versionControlSystem?: VersionControlSystem;

  @visibility(Lifecycle.Read)
  @doc("Provisioning state of the Platform Landing Zone resource.")
  provisioningState?: ResourceProvisioningState;
}
