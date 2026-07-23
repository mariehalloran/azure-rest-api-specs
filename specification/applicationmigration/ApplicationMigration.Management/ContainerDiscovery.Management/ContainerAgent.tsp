import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ContainerSite.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.ApplicationMigration;

/**
 * The ContainerAgent resource — proxy resource representing a deep discovery agent.
 * Child of ContainerSite. Follows the same agent pattern as MongoAgent/PgsqlAgent.
 */
@parentResource(ContainerSite)
model ContainerAgent is Azure.ResourceManager.ProxyResource<
  ContainerAgentProperties,
  false
> {
  ...ResourceNameParameter<
    Resource = ContainerAgent,
    KeyName = "agentName",
    SegmentName = "agents",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  >;
}

/**
 * ContainerAgent properties.
 */
model ContainerAgentProperties is AzureResourceProperties {
  @doc("Service principal identity details used by agent for communication.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  servicePrincipalIdentityDetails: AgentSpnProperties;

  @doc("Name of the appliance on which agent is running.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  migrateApplianceName: string;

  @doc("Health details of the agent.")
  healthDetails?: AgentHealthProperties;

  @doc("Name of the fabric site.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  fabricSiteName: string;
}

/**
 * Patch envelope for ContainerAgent.
 */
model ContainerAgentPatchProperties {
  @doc("Container agent patch properties.")
  properties?: ContainerAgentPatch;
}

/**
 * Patch properties for ContainerAgent.
 */
model ContainerAgentPatch {
  @doc("Agent health details.")
  healthDetails?: AgentHealthProperties;
}

@armResourceOperations
interface ContainerAgents {
  get is ArmResourceRead<ContainerAgent>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<ContainerAgent>;
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<ContainerAgent, ContainerAgentPatchProperties>;
  delete is ArmResourceDeleteSync<ContainerAgent>;
  listBySite is ArmResourceListByParent<
    ContainerAgent,
    Response = ArmResponse<ContainerAgentList>
  >;

  /**
   * Trigger Refresh action
   */
  //#suppress "@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes" ""
  @action("refresh")
  triggerRefresh is ArmResourceActionNoResponseContentAsync<
    ContainerAgent,
    void
  >;
}

@@maxLength(ContainerAgent.name, 63);
@@minLength(ContainerAgent.name, 3);
@@doc(ContainerAgent.name, "The agent name.");
@@doc(ContainerAgent.properties, "Container agent properties.");
@@doc(
  ContainerAgents.createOrUpdate::parameters.resource,
  "The container agent resource to create or update."
);
@@doc(
  ContainerAgents.update::parameters.properties,
  "Container agent patch payload."
);
