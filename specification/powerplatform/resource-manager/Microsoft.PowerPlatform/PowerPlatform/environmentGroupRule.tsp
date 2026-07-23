import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";

using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace Microsoft.PowerPlatform;

/** An environment group resource (parent resource for rules). */
model EnvironmentGroup is ProxyResource<EnvironmentGroupProperties> {
  ...ResourceNameParameter<
    Resource = EnvironmentGroup,
    KeyName = "environmentGroupId",
    SegmentName = "environmentGroups",
    NamePattern = "^[a-zA-Z0-9-]{1,128}$"
  >;
}

/** Properties of an environment group. */
model EnvironmentGroupProperties {
  /** The provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: Azure.ResourceManager.ResourceProvisioningState;
}

/** A governance rule assigned to an environment group. */
@parentResource(EnvironmentGroup)
model EnvironmentGroupRule is ProxyResource<EnvironmentGroupRuleProperties> {
  ...ResourceNameParameter<
    Resource = EnvironmentGroupRule,
    KeyName = "ruleSetId",
    SegmentName = "rules",
    NamePattern = "^[a-zA-Z0-9_]{1,256}$"
  >;
}

/** Properties of an environment group rule. */
model EnvironmentGroupRuleProperties {
  /** The environment group identifier. */
  environmentGroupId: string;

  /** The tenant identifier. */
  tenantId: string;

  /** The RuleBasedPolicy identifier that contains this rule. */
  policyId: string;

  /** The rule set identifier (e.g., ConnectorManagement, IPFirewallSettings). */
  ruleSetId: string;

  /** The rule set version (e.g., 1.0). */
  ruleSetVersion: string;

  /** The type of the rule set — Governing for enforcement, Configuration for property propagation. */
  ruleSetType: RuleSetType;

  /** Indicates whether the rule is present in the group's policy. */
  configured: boolean;

  /** Indicates whether the rule's primary toggle is on. */
  enabled: boolean;

  /** The source type of the rule assignment. */
  sourceType: SourceType;

  /** The last time this rule configuration was modified. */
  lastModified: utcDateTime;

  /** Count of items in rule inputs — connectors, IP ranges, URL rules, etc. */
  @minValue(0)
  inputSize: int32;

  /** A human-readable summary of the rule configuration. */
  @maxLength(1024)
  inputSummary: string;

  /** The provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: Azure.ResourceManager.ResourceProvisioningState;
}

/** The type of the rule set. */
union RuleSetType {
  /** Governing rules that enforce policies through dynamic evaluation. */
  Governing: "Governing",

  /** Configuration rules that propagate settings to environments. */
  Configuration: "Configuration",

  string,
}

/** The source type of the rule assignment. */
union SourceType {
  /** Rule is assigned at the environment group level. */
  EnvironmentGroup: "EnvironmentGroup",

  /** Rule is assigned at the tenant level. */
  Tenant: "Tenant",

  string,
}

@armResourceOperations
interface EnvironmentGroupRules {
  /** Get a specific rule for an environment group. */
  get is ArmResourceRead<EnvironmentGroupRule>;
  /** List all rules for an environment group. */
  listByEnvironmentGroup is ArmResourceListByParent<EnvironmentGroupRule>;
}

@@doc(EnvironmentGroupRule.name, "The rule set identifier.");
@@doc(
  EnvironmentGroupRule.properties,
  "The properties of the environment group rule."
);
@@doc(EnvironmentGroup.name, "The environment group identifier.");
@@doc(EnvironmentGroup.properties, "The properties of the environment group.");
