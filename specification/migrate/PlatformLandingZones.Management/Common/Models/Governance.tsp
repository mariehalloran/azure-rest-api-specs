import "@azure-tools/typespec-azure-resource-manager";
import "../Enums/Enums.tsp";

using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("Azure Policy parameter override applied to an assignment.")
model PolicyParameterOverride {
  @doc("Parameter name defined by the policy assignment.")
  name: string;

  @doc("Parameter value serialized as JSON.")
  value: string;
}

@doc("Override applied to an Azure Landing Zones policy assignment.")
model PolicyAssignmentOverride {
  @doc("Azure Landing Zones management-group scope at which the override applies.")
  scope: AlzManagementGroupScope;

  @doc("Name of the Azure Landing Zones policy assignment.")
  assignmentName: string;

  @doc("Whether the policy assignment is deployed.")
  enabled?: boolean;

  @doc("Enforcement mode applied to the policy assignment.")
  enforcementMode?: PolicyEnforcementMode;

  @doc("Effect applied to all definitions in the policy assignment.")
  effect?: PolicyEffect;

  @doc("Parameter overrides applied to the policy assignment.")
  @identifiers(#["name"])
  parameters?: PolicyParameterOverride[];
}

@doc("Governance configuration for the platform landing zone.")
model Governance {
  @doc("Policy assignment baseline.")
  policyAssignmentMode?: PolicyAssignmentMode;

  @doc("Overrides applied to policy assignments in the Azure Landing Zones baseline.")
  @identifiers(#["scope", "assignmentName"])
  policyAssignmentOverrides?: PolicyAssignmentOverride[];
}
