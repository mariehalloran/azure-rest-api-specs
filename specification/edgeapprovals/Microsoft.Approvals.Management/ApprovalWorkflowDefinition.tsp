using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;
using OpenAPI;

namespace Microsoft.Approvals;

@doc("ApprovalWorkflowDefinition ARM resource.")
model ApprovalWorkflowDefinition
  is ExtensionResource<ApprovalWorkflowDefinitionProperties> {
  ...ResourceNameParameter<ApprovalWorkflowDefinition>;
  ...EntityTagProperty;
}

@doc("RP-specific properties of an ApprovalWorkflowDefinition resource.")
model ApprovalWorkflowDefinitionProperties {
  @doc("The status of the last operation.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @doc("The reference to a custom Logic App.")
  logicAppRef?: LogicAppRef;

  @doc("The rule about the stages, approvers and their orders for the approval workflow.")
  approvalRule: ApprovalRule;

  @doc("The hierarchical scope under which this approval workflow is assignable.")
  scope?: string;

  @doc("The settings that describe how this workflow chains to one or more upstream workflows. When not configured, the workflow behaves independently and does not depend on any upstream workflow result.")
  chainingSettings?: ChainingSettings;
}

@doc("Settings that describe how a workflow chains to one or more upstream workflows. When configured, the workflow inherits the result of any referenced upstream workflow: if one of them has a valid signed approval, VA can auto-complete this workflow. When multiple upstream workflow definition ids are configured, any one valid upstream approval satisfies the chaining requirement.")
model ChainingSettings {
  @doc("The list of upstream approval workflow definition ARM resource ids this workflow chains to. Any one valid upstream approval among these satisfies the chaining requirement.")
  workflowDefinitionIds: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Approvals/approvalWorkflowDefinitions";
    }
  ]>[];
}

@doc("Reference to a Logic App resource.")
model LogicAppRef {
  @doc("The workflow URL of the Logic App.")
  workflowUrl: string;
}

@doc("Rule rule about the stages, approvers and their orders for the approval workflow.")
model ApprovalRule {
  @doc("The definitions of all the stages in the approval workflow.")
  @identifiers(#["name"])
  stages: ApprovalStage[];

  @doc("The maximum time in minutes that the approval workflow can be executed. The min value is 1 minute. The max value is 90 days. The default value is 7 days in the backend service.")
  @minValue(1)
  @maxValue(129600)
  timeoutInMinutes?: int32;
}

@doc("Definition of an stage in an approval workflow.")
model ApprovalStage {
  @doc("The name of the stage, unique within a single approval workflow definition.")
  name: string;

  @doc("The logical representation of how the stage depends on other stages.")
  dependsOn?: ApprovalStageDependency;

  @doc("The list of identifiers of approvers in the stage.")
  approvers: string[];

  @doc("The minimal number of approvals required to complete the stage. The default value '1' means at least one approval is needed.")
  minimumApprovalsRequired: int32 = 1;

  @doc("The minimum number of rejections required to reject the stage. Default is 1. When set to 0, rejections are ignored and only the approval quorum matters. When set to N, the stage is rejected once N rejections are received.")
  minimumRejectionsRequired: int32 = 1;

  @doc("When true, all approvers must respond before the stage result is evaluated. Default is false.")
  waitForAllApproversToRespond: boolean = false;
}

@doc("Logical representation of how a stage depends on other stages. Only one of the top-level properties should be used.")
model ApprovalStageDependency {
  @doc("The list of stage names which this stage directly depends on.")
  stages?: string[];

  @doc("The list of nested dependencies which this stage depends on with a logical AND operation.")
  @identifiers(#[])
  and?: ApprovalStageDependency[];

  @doc("The list of nested dependencies which this stage depends on with a logical OR operation.")
  @identifiers(#[])
  or?: ApprovalStageDependency[];
}

@armResourceOperations(ApprovalWorkflowDefinition)
interface ApprovalWorkflowDefinitions {
  get is ArmResourceRead<ApprovalWorkflowDefinition>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ApprovalWorkflowDefinition>;
  update is ArmResourcePatchAsync<
    ApprovalWorkflowDefinition,
    ApprovalWorkflowDefinitionProperties
  >;
  delete is ArmResourceDeleteWithoutOkAsync<ApprovalWorkflowDefinition>;
  listByParent is ArmResourceListByParent<ApprovalWorkflowDefinition>;
}
