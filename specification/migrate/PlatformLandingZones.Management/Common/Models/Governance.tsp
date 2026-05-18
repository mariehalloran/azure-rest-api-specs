import "@azure-tools/typespec-azure-resource-manager";
import "../Enums/Enums.tsp";

using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("Required tag definition enforced via policy.")
model RequiredTag {
  @doc("Tag name.")
  name: string;

  @doc("Default value to apply when the tag is missing. Omit to require explicit specification on each resource.")
  defaultValue?: string;
}

@doc("Override of a single ALZ policy assignment at a specific management-group scope.")
model PolicyAssignmentOverride {
  @doc("ALZ management-group scope at which this override applies. The same assignment may be overridden differently at different scopes.")
  scope: AlzManagementGroupScope;

  @doc("Display name of the ALZ policy assignment being overridden.")
  assignmentName: string;

  @doc("Enforcement mode to apply for this assignment at the chosen scope. Omit to inherit the baseline.")
  enforcementMode?: PolicyEnforcementMode;

  @doc("Policy effect to apply for this assignment at the chosen scope. Omit to inherit the baseline.")
  effect?: PolicyEffect;

  @doc("Parameter overrides applied to the assignment. Omit to inherit the baseline.")
  @identifiers(#["name"])
  parameters?: PolicyParameterOverride[];
}

@doc("Single Azure Policy parameter override applied to an assignment.")
model PolicyParameterOverride {
  @doc("Parameter name as defined on the policy assignment.")
  name: string;

  @doc("Parameter value, serialized as a string.")
  value: string;
}

@doc("Resource Manager lock applied at an ALZ management group scope.")
model ResourceLockPolicy {
  @doc("Management group scope the lock applies to.")
  scope: AlzManagementGroupScope;

  @doc("Lock level.")
  level: ResourceLockLevel;

  @doc("Reason for the lock, surfaced to users attempting a denied operation.")
  notes?: string;
}

@doc("Governance configuration for the landing zone.")
model Governance {
  @doc("Policy assignment baseline mode.")
  policyAssignmentMode: PolicyAssignmentMode;

  @doc("Required tags enforced via policy.")
  @identifiers(#["name"])
  requiredTags?: RequiredTag[];

  @doc("Per-assignment overrides applied on top of the ALZ baseline. Only relevant when policyAssignmentMode is AlzDefaults.")
  @identifiers(#["scope", "assignmentName"])
  policyAssignmentOverrides?: PolicyAssignmentOverride[];

  @doc("Resource Manager locks applied at ALZ management group scopes.")
  @identifiers(#["scope"])
  resourceLocks?: ResourceLockPolicy[];

  @doc("Allowed Azure regions enforced via policy at the landing-zone scope.")
  allowedLocations?: string[];

  @doc("Resource types denied via policy at the landing-zone scope (e.g. \"Microsoft.ClassicCompute/virtualMachines\").")
  deniedResourceTypes?: string[];
}
