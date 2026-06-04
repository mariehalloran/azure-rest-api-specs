import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.PortalServices;

interface Operations extends Azure.ResourceManager.Operations {}

@doc("Available values for the Multi-factor authentication enforcement behavior.")
union MfaEnforcement {
  string,

  @doc("Use the default Multi-factor authentication enforcement behavior.")
  "Default",

  @doc("This tenant is opted out of Multi-factor authentication enforcement.")
  "OptOut",

  @doc("Multi-factor authentication is required.")
  "Enforce",
}

/** The state of the Agent Mode registration for the tenant. */
union AgentModeRegisterState {
  string,

  /** This tenant is unregistered for Agent Mode. */
  "Unregistered",

  /** This tenant is registered for Agent Mode. */
  "Registered",
}

/** The state of the Agent Mode feature for the tenant. */
union AgentModeState {
  string,

  /** Agent Mode is disabled for this tenant. */
  "Disabled",

  /** Agent Mode is enabled for this tenant. */
  "Enabled",
}

/** The state of a Copilot agent. */
union CopilotAgentState {
  string,

  /** The agent is enabled. */
  "Enabled",

  /** The agent is disabled. */
  "Disabled",
}

/** Known Copilot agent identifiers. Extensible -- new agents may be added by the service without an API version bump. */
union CopilotAgentName {
  string,

  /** The troubleshooting agent. */
  TroubleshootingAgent: "TroubleshootingAgent",

  /** The deployment competency agent. */
  DeploymentCompetency: "DeploymentCompetency",

  /** The migration competency agent. */
  MigrationAgentCompetency: "MigrationAgentCompetency",

  /** The resiliency competency agent. */
  ResiliencyAgentCompetency: "ResiliencyAgentCompetency",

  /** The optimization competency agent. */
  OptimizationAgentCompetency: "OptimizationAgentCompetency",

  /** The observability agent. */
  ObservabilityAgent: "ObservabilityAgent",
}

/** Per-agent configuration override for a tenant. */
model CopilotAgentOverride {
  /** The agent identifier. */
  @key
  @visibility(Lifecycle.Create, Lifecycle.Read, Lifecycle.Update)
  name: CopilotAgentName;

  /** The state of the agent for this tenant. */
  state: CopilotAgentState;
}

/** Agent settings configuration. */
model CopilotAgentSettings {
  /** Whether tenant is opted into future GA agents for this tenant. */
  enableGa?: boolean;

  /** Whether tenant is opted into future preview agents for this tenant. */
  enablePreview?: boolean;

  /** Per-agent overrides for this tenant, identified by agent name. */
  agents?: CopilotAgentOverride[];
}

/** The agent mode configuration properties. */
model AgentModeProperties {
  /** The state of the Agent Mode registration for the tenant. */
  @visibility(Lifecycle.Create, Lifecycle.Read, Lifecycle.Update)
  registration: AgentModeRegisterState;

  /** The state of the Agent Mode feature for the tenant. */
  @visibility(Lifecycle.Read)
  state?: AgentModeState;
}

@doc("The Copilot Settings properties.")
model CopilotSettingsProperties {
  @doc("Boolean indicating if role-based access control is enabled for copilot in this tenant.")
  accessControlEnabled: boolean;

  @added(Versions.v2025_08_01_preview)
  @doc("The setting for Bring Your Own Storage (BYOS) for copilot in this tenant. If set, copilot will use specified cosmos DB account for storing copilot chat data.")
  cosmosResourceId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.DocumentDB/databaseAccounts";
    }
  ]>;

  /** Agent settings, including default feature gates and per-agent overrides. */
  @added(Versions.v2026_07_01_preview)
  @doc("Agent settings for this tenant, including GA/preview enablement and per-agent overrides.")
  agentSettings?: CopilotAgentSettings;

  @added(Versions.v2024_08_01_preview)
  @removed(Versions.v2024_09_01_preview)
  @doc("The setting for Multi-Factor Authentication enforcement when signing into this tenant in the Azure Portal.")
  portalMfaEnforcement?: MfaEnforcement;

  @added(Versions.v2024_08_01_preview)
  @removed(Versions.v2024_09_01_preview)
  @doc("Justification for the value set for portalMfaEnforcement. Required when portalMfaEnforcement is set to a value other than 'Default'. Maximum length is 500 characters.")
  portalMfaEnforcementJustification?: string;

  @doc("The status of the last provisioning operation performed on the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  /** The agent mode configuration properties. */
  @added(Versions.v2025_09_10_preview)
  agentMode?: AgentModeProperties;
}
