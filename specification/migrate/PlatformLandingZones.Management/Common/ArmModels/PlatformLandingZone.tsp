import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "../Enums/Enums.tsp";
import "../Models/PlatformRegion.tsp";
import "../Models/PlatformSubscriptions.tsp";
import "../Models/Connectivity.tsp";
import "../Models/Management.tsp";
import "../Models/Security.tsp";
import "../Models/Governance.tsp";
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
  @doc("Deployment scale selected by the stock accelerator template. ManagementOnly omits connectivity.")
  scaleTier?: ScaleTier;

  @visibility(Lifecycle.Create)
  @doc("ARM resource id of the parent management group under which the ALZ management group hierarchy will be created. Create-only; cannot be changed after the landing zone is created.")
  parentManagementGroupId?: string;

  @doc("Platform subscription topology.")
  platformSubscriptions?: PlatformSubscriptions;

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

  @doc("Version control system the generator will use when materializing the landing-zone IaC and CI pipelines. When omitted, the generator service applies its default (currently GitHub).")
  versionControlSystem?: VersionControlSystem;

  @doc("Name of the organization or environment that owns this landing zone. Surfaced to the generator (maps to ENVIRONMENT_NAME). Optional.")
  @maxLength(200)
  organizationName?: string;

  @doc("Name of the service associated with this landing zone. Surfaced to the generator (maps to SERVICE_NAME). Optional.")
  @maxLength(200)
  serviceName?: string;

  @visibility(Lifecycle.Read)
  @doc("Provisioning state of the Platform Landing Zone resource.")
  provisioningState?: ResourceProvisioningState;

  @visibility(Lifecycle.Read)
  @doc("Status of the asynchronous landing-zone generation run.")
  status?: PlatformLandingZoneGenerationStatus;

  @visibility(Lifecycle.Read)
  @doc("ARM resource id of the artifact ({migrateProjectId}/artifacts/plz-{name}) under which the generated design document and IaC are committed. Read-only and deterministic (derived from the resource identity), so it is available immediately, even while provisioning.")
  artifactId?: string;
}
