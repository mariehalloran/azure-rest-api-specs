import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";
import "@typespec/versioning";

using Azure.ClientGenerator.Core;
using Microsoft.ComputeSchedule;
using Azure.ResourceManager;
using TypeSpec.Versioning;

@@clientName(Microsoft.ComputeSchedule, "ComputeScheduleMgmtClient", "python");
@@clientName(Microsoft.ComputeSchedule, "ComputeScheduleMgmtClient", "java");
@@clientNamespace(
  Microsoft.ComputeSchedule,
  "com.azure.resourcemanager.computeschedule",
  "java"
);

@@clientName(CancelOccurrenceRequest, "OccurrenceCancelContent", "csharp");
@@clientName(DelayRequest, "OccurrenceDelayContent", "csharp");
@@clientName(Language, "NotificationLanguage", "csharp");
@@clientName(Month, "ScheduledActionsScheduleMonth", "csharp");
@@clientName(WeekDay, "ScheduledActionsScheduleWeekDay", "csharp");
@@clientName(NotificationProperties, "NotificationSettings", "csharp");
@@clientName(NotificationProperties.disabled, "IsDisabled", "csharp");

@@clientName(
  ScheduledActions.virtualMachinesSubmitDeallocate,
  "SubmitVirtualMachineDeallocate",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesSubmitHibernate,
  "SubmitVirtualMachineHibernate",
  "csharp"
);

@@clientName(
  ScheduledActions.virtualMachinesSubmitStart,
  "SubmitVirtualMachineStart",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesExecuteDeallocate,
  "ExecuteVirtualMachineDeallocate",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesExecuteHibernate,
  "ExecuteVirtualMachineHibernate",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesExecuteStart,
  "ExecuteVirtualMachineStart",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesGetOperationStatus,
  "GetVirtualMachineOperationStatus",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesCancelOperations,
  "CancelVirtualMachineOperations",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesGetOperationErrors,
  "GetVirtualMachineOperationErrors",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesExecuteCreate,
  "ExecuteVirtualMachineCreateOperation",
  "csharp"
);
@@clientName(
  ScheduledActions.virtualMachinesExecuteDelete,
  "ExecuteVirtualMachineDeleteOperation",
  "csharp"
);

@@clientName(CancelOperationsResponse, "CancelOperationsResult", "csharp");
@@clientName(DeadlineType, "ScheduledActionDeadlineType", "csharp");
@@clientName(
  DeallocateResourceOperationResponse,
  "DeallocateResourceOperationResult",
  "csharp"
);
@@clientName(
  DeallocateResourceOperationResponse.type,
  "ResourceType",
  "csharp"
);
@@clientName(
  ExecutionParameters,
  "ScheduledActionExecutionParameterDetail",
  "csharp"
);
@@clientName(GetOperationErrorsResponse, "GetOperationErrorsResult", "csharp");
@@clientName(GetOperationStatusResponse, "GetOperationStatusResult", "csharp");
@@clientName(
  HibernateResourceOperationResponse,
  "HibernateResourceOperationResult",
  "csharp"
);
@@clientName(HibernateResourceOperationResponse.type, "ResourceType", "csharp");
@@clientName(OperationState, "ScheduledActionOperationState", "csharp");
@@clientName(
  OptimizationPreference,
  "ScheduledActionOptimizationPreference",
  "csharp"
);
@@clientName(ResourceOperation, "ResourceOperationResult", "csharp");
@@clientName(Resources, "UserRequestResources", "csharp");
@@clientName(RetryPolicy, "UserRequestRetryPolicy", "csharp");
@@clientName(Schedule, "UserRequestSchedule", "csharp");
@@clientName(
  StartResourceOperationResponse,
  "StartResourceOperationResult",
  "csharp"
);
@@clientName(StartResourceOperationResponse.type, "ResourceType", "csharp");
@@clientName(
  ExecuteDeleteRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(ExecuteDeleteRequest.forceDeletion, "IsForceDeletion", "csharp");
@@clientName(
  ExecuteCreateRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  SubmitDeallocateRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  SubmitStartRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  SubmitHibernateRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  ExecuteDeallocateRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  ExecuteHibernateRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  ExecuteStartRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  GetOperationStatusRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(
  CancelOperationsRequest.correlationid,
  "correlationId",
  "csharp,javascript"
);
@@clientName(Schedule.deadLine, "userRequestDeadline", "csharp,javascript");
@@clientName(Schedule.timeZone, "userRequestTimezone", "csharp,javascript");
@@clientName(
  ResourceOperationDetails.timeZone,
  "operationTimezone",
  "csharp,javascript"
);
@@clientName(
  OperationErrorDetails.timeStamp,
  "errorDetailsTimestamp",
  "csharp,javascript"
);

@@clientName(
  DeleteResourceOperationResponse,
  "DeleteResourceOperationResult",
  "csharp"
);
@@clientName(
  CreateResourceOperationResponse,
  "CreateResourceOperationResult",
  "csharp"
);
@@clientName(ScheduledActionResource, "ScheduledActionResourceData", "csharp");
@@clientName(OccurrenceResource, "OccurrenceResourceData", "csharp");
@@clientName(
  OccurrenceExtensionResource,
  "OccurrenceExtensionResourceData",
  "csharp"
);
@@clientName(
  ResourceOperationResponse,
  "ScheduledActionResourceOperationResult",
  "csharp"
);
@@clientName(
  ResourceProvisioningState,
  "OccurrenceResourceProvisioningState",
  "csharp"
);
@@clientName(
  ProvisioningState,
  "ScheduledActionResourceProvisioningState",
  "csharp"
);
@@clientName(Occurrence, "ScheduledActionOccurrence", "csharp");
@@clientName(
  OccurrenceProperties,
  "ScheduledActionOccurrenceProperties",
  "csharp"
);
@@clientName(OccurrenceState, "ScheduledActionOccurrenceState", "csharp");
@@clientName(
  ResourceAttachRequest,
  "ScheduledActionResourceAttachContent",
  "csharp"
);
@@clientName(
  ResourceDetachRequest,
  "ScheduledActionResourceDetachContent",
  "csharp"
);
@@clientName(
  ResourcePatchRequest,
  "ScheduledActionResourcePatchContent",
  "csharp"
);
@@clientName(ResourceStatus, "ScheduledActionResourceStatus", "csharp");
@@clientName(
  ResourceOperationStatus,
  "ScheduledActionResourceOperationStatus",
  "csharp"
);
@@clientName(ResourceType, "ScheduledActionResourceType", "csharp");

@@clientName(
  OccurrenceExtension.listOccurrenceByVms,
  "GetAssociatedOccurrences",
  "csharp"
);
@@clientName(ScheduledActions.listResources, "GetAttachedResources", "csharp");
@@clientName(Occurrences.listResources, "GetAttachedResources", "csharp");
@@clientName(
  ScheduledActionExtension.listByVms,
  "GetAssociatedScheduledActions",
  "csharp"
);

@@clientName(
  ResourceOperationResponse,
  "RecurringActionsResourceOperationResult",
  "javascript,go,python,java"
);

@@clientName(
  Microsoft.ComputeSchedule.ActionType,
  "ScheduledActionType",
  "!autorest"
);

@@clientName(SubmitDeallocateRequest, "SubmitDeallocateContent", "!autorest");
@@clientName(ExecuteHibernateRequest, "ExecuteHibernateContent", "!autorest");
@@clientName(CancelOperationsRequest, "CancelOperationsContent", "!autorest");
@@clientName(ExecuteCreateRequest, "ExecuteCreateContent", "!autorest");
@@clientName(ExecuteDeallocateRequest, "ExecuteDeallocateContent", "!autorest");
@@clientName(ExecuteDeleteRequest, "ExecuteDeleteContent", "!autorest");
@@clientName(ExecuteStartRequest, "ExecuteStartContent", "!autorest");
@@clientName(
  GetOperationErrorsRequest,
  "GetOperationErrorsContent",
  "!autorest"
);
@@clientName(
  GetOperationStatusRequest,
  "GetOperationStatusContent",
  "!autorest"
);
@@clientName(SubmitStartRequest, "SubmitStartContent", "!autorest");
@@clientName(SubmitHibernateRequest, "SubmitHibernateContent", "!autorest");
@@clientName(
  ScheduledActionsExtensionProperties,
  "ScheduledActionsExtensionProperties",
  "!autorest"
);

// JavaScript SDK visibility workaround:
// 1. ScheduledActionResource has 'name' and 'id' fields that are both required and
//    read-only (server-computed). JS SDK users should not be forced to supply those
//    values when calling write operations (attachResources, patchResources).
// 2. ScheduledAction update body includes server-side read-only fields (provisioningState).
//    Provide write-specific models that omit those fields and wire them in via @@alternateType.
// Pattern: https://github.com/Azure/azure-rest-api-specs/pull/43744
//          https://github.com/Azure/azure-rest-api-specs/pull/42196
namespace ComputeScheduleCustomizations {
  using Microsoft.ComputeSchedule;

  @added(Microsoft.ComputeSchedule.Versions.`2025-04-15-preview`)
  @doc("Scheduled action resource item for write operations, omitting server-side read-only fields (name and id are required+read-only in the canonical model).")
  model ScheduledActionResourceWrite {
    @doc("""
      The ARM Id of the resource.
      "subscriptions/{subId}/resourceGroups/{rgName}/providers/Microsoft.Compute/virtualMachines/{vmName}"
      """)
    resourceId: ValidScheduledActionResourceId;

    @doc("The desired notification settings for the specified resource.")
    @identifiers(#["destination"])
    notificationSettings?: Array<NotificationProperties>;
  }

  @added(Microsoft.ComputeSchedule.Versions.`2025-04-15-preview`)
  @doc("Request model to attach a list of scheduled action resources for write operations.")
  model ResourceAttachRequestWrite {
    @doc("List of resources to be attached")
    @identifiers(#["resourceId"])
    resources: Array<ScheduledActionResourceWrite>;
  }

  @added(Microsoft.ComputeSchedule.Versions.`2025-04-15-preview`)
  @doc("Request model to patch a list of scheduled action resources for write operations.")
  model ResourcePatchRequestWrite {
    @doc("The list of resources to patch")
    @identifiers(#["resourceId"])
    resources: Array<ScheduledActionResourceWrite>;
  }

  @added(Microsoft.ComputeSchedule.Versions.`2025-04-15-preview`)
  @doc("Writable properties of ScheduledAction for update operations, excluding server-side read-only fields (e.g. provisioningState).")
  model ScheduledActionPropertiesForUpdate {
    @doc("The type of resource the scheduled action is targeting")
    resourceType?: ResourceType;

    @doc("The action the scheduled action should perform in the resources")
    actionType?: ActionType;

    #suppress "@azure-tools/typespec-azure-core/no-offsetdatetime" "Prefer using `utcDateTime` when representing a datetime unless an offset is necessary."
    @doc("The time which the scheduled action is supposed to start running")
    startTime?: offsetDateTime;

    #suppress "@azure-tools/typespec-azure-core/no-offsetdatetime" "Prefer using `utcDateTime` when representing a datetime unless an offset is necessary."
    @doc("The time when the scheduled action is supposed to stop scheduling")
    endTime?: offsetDateTime;

    @doc("The schedule the scheduled action is supposed to follow")
    schedule?: ScheduledActionsSchedule;

    @doc("The notification settings for the scheduled action")
    @Azure.ResourceManager.identifiers(#["destination"])
    notificationSettings?: Array<NotificationProperties>;

    @doc("Tell if the scheduled action is disabled or not")
    disabled?: boolean;
  }

  @added(Microsoft.ComputeSchedule.Versions.`2025-04-15-preview`)
  @doc("Update model for ScheduledAction for JavaScript SDK, omitting server-side read-only fields.")
  model ScheduledActionForUpdate {
    #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Required for tags field in update model"
    @doc("Resource tags.")
    tags?: Record<string>;

    @doc("The resource-specific properties for this resource.")
    properties?: ScheduledActionPropertiesForUpdate;
  }
}

@@alternateType(
  ScheduledActions.attachResources::parameters.body,
  ComputeScheduleCustomizations.ResourceAttachRequestWrite,
  "javascript"
);
@@alternateType(
  ScheduledActions.patchResources::parameters.body,
  ComputeScheduleCustomizations.ResourcePatchRequestWrite,
  "javascript"
);
@@alternateType(
  ScheduledActions.update::parameters.properties,
  ComputeScheduleCustomizations.ScheduledActionForUpdate,
  "javascript"
);
