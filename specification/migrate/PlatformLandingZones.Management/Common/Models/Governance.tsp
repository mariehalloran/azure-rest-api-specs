import "../Enums/Enums.tsp";

namespace Microsoft.Migrate;

@doc("Governance configuration produced by the stock ALZ template.")
model Governance {
  @doc("Policy assignment baseline.")
  policyAssignmentMode?: PolicyAssignmentMode;
}
