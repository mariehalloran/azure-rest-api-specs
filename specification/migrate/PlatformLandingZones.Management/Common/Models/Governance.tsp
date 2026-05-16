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

@doc("Override of a single ALZ policy assignment.")
model PolicyAssignmentOverride {
  @doc("Display name of the ALZ policy assignment being overridden.")
  assignmentName: string;

  @doc("Enforcement mode for this assignment.")
  enforcementMode: PolicyEnforcementMode;
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
  @identifiers(#["assignmentName"])
  policyAssignmentOverrides?: PolicyAssignmentOverride[];

  @doc("Resource Manager locks applied at ALZ management group scopes.")
  @identifiers(#["scope"])
  resourceLocks?: ResourceLockPolicy[];
}
