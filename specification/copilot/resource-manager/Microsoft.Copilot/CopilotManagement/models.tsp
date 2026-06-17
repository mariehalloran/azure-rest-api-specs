import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

namespace Microsoft.Copilot;

interface Operations extends Azure.ResourceManager.Operations {}

// Defined here until we get definition from ARM side
@doc("The properties of ARM baseType")
model BaseTypeEntry {
  @doc("The base type for this resource.")
  baseType: string;

  @doc("The version of the base type for this resource.")
  version: string;
}

@doc("The chat agent resource properties. All properties are read-only and defined by the resource provider.")
model ChatAgentProperties {
  @doc("The display name of the chat agent.")
  @visibility(Lifecycle.Read)
  displayName?: string;

  @doc("[Agent Base Type] A description of what this chat agent does.")
  @visibility(Lifecycle.Read)
  description?: string;

  @doc("[Agent Base Type] The base types that classify this resource's capabilities. Always includes 'agent'. Set by the service for ARM Agent Base Type cross-RP policy targeting.")
  @visibility(Lifecycle.Read)
  @identifiers(#[])
  baseTypes?: BaseTypeEntry[];

  @doc("[Agent Base Type] Declarative list of tools and capabilities enabled for the chat agent.")
  @visibility(Lifecycle.Read)
  tools?: string[];

  @doc("[Agent Base Type] The LLM or model identifier used by the chat agent.")
  @visibility(Lifecycle.Read)
  `model`?: string;

  @doc("The status of the last provisioning operation performed on the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("The Entra Agent Identity configuration for this chat agent. Provisioned by the service from the agent blueprint during resource creation.")
  @visibility(Lifecycle.Read)
  agentIdentity?: AgentIdentityConfiguration;
}

@doc("Read-only identity references provisioned by the service from the agent blueprint. Links the chat agent's managed identity to an Entra Agent Identity.")
model AgentIdentityConfiguration {
  @doc("The Entra Agent Identity ID.")
  @visibility(Lifecycle.Read)
  agentIdentityId?: string;

  @doc("The blueprint app registration ID that this agent identity was created from.")
  @visibility(Lifecycle.Read)
  agentIdentityBlueprintId?: string;

  @doc("The service principal ID for the blueprint. Same value across all chat agents within a tenant.")
  @visibility(Lifecycle.Read)
  agentIdentityBlueprintObjectId?: string;
}

alias ManagedServiceIdentityUpdate = OptionalProperties<UpdateableProperties<Azure.ResourceManager.CommonTypes.ManagedServiceIdentity>>;

@doc("make sure service identity properties can be updated")
model ManagedServiceIdentityUpdateProperty {
  @doc("The managed service identities assigned to this resource.")
  identity?: ManagedServiceIdentityUpdate;
}

@doc("The properties of a chat agent that can be updated. Only tags and identity are mutable; all resource properties are read-only.")
model ChatAgentUpdate {
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;
  ...ManagedServiceIdentityUpdateProperty;
}
