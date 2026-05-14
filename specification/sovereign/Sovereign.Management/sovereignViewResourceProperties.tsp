using TypeSpec.Versioning;
using Azure.ResourceManager;
using Azure.Core;

namespace Microsoft.Sovereign;

@added(Versions.Preview20260315)
@doc("The patch model for the sovereign view resource type.")
model SovereignViewResourcePatch {
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;
  ...ManagedSystemAssignedIdentityProperty;
}

@added(Versions.Preview20260315)
@doc("The properties of the sovereign view resource type.")
model SovereignViewResourceProperties {
  @doc("The scope to apply for configuration.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  scope: SovereignViewScope;

  @doc("The policy initiatives selected for the sovereign view.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  @identifiers(#["policyInitiativeId"])
  policyInitiatives: SovereignViewPolicyInitiativeDetail[];

  @visibility(Lifecycle.Read)
  @doc("The status of a user-initiated, control-plane operation on the sovereign view resource type.")
  provisioningState?: provisioningState;
}

@added(Versions.Preview20260315)
@doc("The scope for the sovereign view in terms of the resources it would evaluate.")
model SovereignViewScope {
  @doc("The management groups in scope.")
  managementGroups?: SovereignViewManagementGroupScope[];

  @doc("The subscriptions in scope.")
  subscriptions?: SovereignViewSubscriptionScope[];
}

@added(Versions.Preview20260315)
@doc("A management group scope item for the sovereign view.")
model SovereignViewManagementGroupScope {
  @doc("The resource identifier of the management group.")
  id: armResourceIdentifier<[
    {
      type: "Microsoft.Management/managementGroups";
    }
  ]>;

  @doc("The management group name.")
  name?: string;
}

@added(Versions.Preview20260315)
@doc("A subscription scope item for the sovereign view.")
model SovereignViewSubscriptionScope {
  @doc("The subscription id.")
  id: uuid;

  @doc("The subscription name.")
  name?: string;
}

@added(Versions.Preview20260315)
@doc("The policy initiative details for the sovereign view.")
model SovereignViewPolicyInitiativeDetail {
  @doc("The fully qualified id of the policy initiative.")
  policyInitiativeId: armResourceIdentifier<[
    {
      type: "Microsoft.Authorization/policySetDefinitions";
    }
  ]>;

  @doc("The compliance dimension associated with the policy initiative.")
  dimension: ComplianceDimension;

  @doc("The policy assignment Ids generated during assignment of the policy initiative to a scope.")
  policyAssignmentIds?: armResourceIdentifier<[
    {
      type: "Microsoft.Authorization/policyAssignments";
    }
  ]>[];

  @doc("The version of the policy initiative.")
  policyVersion: string;

  #suppress "@azure-tools/typespec-azure-core/bad-record-type" "Parameters vary based on the selected policy initiatives."
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Parameters vary based on the selected policy initiatives."
  @doc("The parameters for the assignment of policy initiatives.")
  assignmentParameters: Record<unknown>;
}

@added(Versions.Preview20260315)
@doc("The compliance dimension to be associated with the policy initiative.")
union ComplianceDimension {
  @doc("Data residency compliance dimension.")
  DataResidency: "DataResidency",

  @doc("Encryption at rest compliance dimension.")
  EncryptionAtRest: "EncryptionAtRest",

  @doc("Encryption in transit compliance dimension.")
  EncryptionInTransit: "EncryptionInTransit",

  @doc("Encryption in use compliance dimension.")
  EncryptionInUse: "EncryptionInUse",

  string,
}

@added(Versions.Preview20260315)
@doc("The response for the sovereign view compliance summary action.")
model SovereignViewComplianceSummaryResponse {
  @doc("State indicating whether the data is processed or still being processed.")
  dataState: string;

  @doc("The resource identifier of the sovereign view.")
  resourceId: armResourceIdentifier<[
    {
      type: "Microsoft.Sovereign/sovereignViews";
    }
  ]>;

  @doc("The time when compliance was last evaluated, in RFC3339 format.")
  lastEvaluated: utcDateTime;

  @doc("The overall summary of compliance across all resources in scope.")
  overallSummary: SovereignViewComplianceOverallSummary;

  @doc("The list of compliance summaries for the dimensions in scope.")
  @identifiers(#["dimension"])
  dimensionSummaries: SovereignViewComplianceDimensionSummary[];
}

@added(Versions.Preview20260315)
@doc("The overall compliance summary in the sovereign view compliance summary action.")
model SovereignViewComplianceOverallSummary {
  @doc("Total number of management groups for the sovereign view.")
  @minValue(0)
  totalManagementGroups: int32;

  @doc("Total number of subscriptions for the sovereign view.")
  @minValue(0)
  totalSubscriptions: int32;

  @doc("Total number of resource groups for the sovereign view.")
  @minValue(0)
  totalResourceGroups: int32;

  @doc("Total number of resources for the sovereign view.")
  @minValue(0)
  totalResources: int32;

  @doc("Number of resources in compliant state for the sovereign view.")
  @minValue(0)
  compliantCount: int32;

  @doc("Number of resources in non-compliant state for the sovereign view.")
  @minValue(0)
  nonCompliantCount: int32;

  @doc("Number of resources in conflict state for the sovereign view.")
  @minValue(0)
  conflictCount: int32;

  @doc("Number of resources in not applicable state for the sovereign view.")
  @minValue(0)
  notApplicableCount: int32;

  @doc("Number of resources in not evaluated state for the sovereign view.")
  @minValue(0)
  notEvaluatedCount: int32;
}

@added(Versions.Preview20260315)
@doc("The compliance summary for a specific dimension in the sovereign view compliance summary action.")
model SovereignViewComplianceDimensionSummary {
  @doc("The dimension representing this summary.")
  dimension: ComplianceDimension;

  @doc("Total number of resources for the sovereign view.")
  @minValue(0)
  totalResources: int32;

  @doc("Number of resources in compliant state for the sovereign view.")
  @minValue(0)
  compliantCount: int32;

  @doc("Number of resources in non-compliant state for the sovereign view.")
  @minValue(0)
  nonCompliantCount: int32;

  @doc("Number of resources in conflict state for the sovereign view.")
  @minValue(0)
  conflictCount: int32;

  @doc("Number of resources in not applicable state for the sovereign view.")
  @minValue(0)
  notApplicableCount: int32;

  @doc("Number of resources in not evaluated state for the sovereign view.")
  @minValue(0)
  notEvaluatedCount: int32;
}

@added(Versions.Preview20260315)
@doc("The request for the sovereign view compliance details action.")
model SovereignViewComplianceDetailsRequest {
  @doc("The maximum number of resources to return. Used for pagination.")
  @minValue(1)
  top: int32;

  @doc("The resources to skip when the results are returned. Used for pagination.")
  @minValue(0)
  skip?: int32;

  @doc("The filters for compliance dimensions and their states to apply when querying for compliance details.")
  @identifiers(#["dimension"])
  complianceDimensions?: SovereignViewComplianceDetailsDimensionFilter[];

  @doc("The filters to apply when querying for compliance details.")
  @identifiers(#["field", "operator"])
  filters?: SovereignViewComplianceDetailsFilters[];

  @doc("The sorting to apply when querying for compliance details.")
  sort?: SovereignViewComplianceDetailsSort;

  @doc("The search to apply when querying for compliance details.")
  search?: SovereignViewComplianceDetailsSearch;
}

@added(Versions.Preview20260315)
@doc("The filter for compliance details based on compliance dimensions and their states.")
model SovereignViewComplianceDetailsDimensionFilter {
  @doc("The compliance dimension to filter on.")
  dimension: ComplianceDimension;

  @doc("The compliance states to optionally filter on.")
  states: PolicyComplianceState[];
}

@added(Versions.Preview20260315)
@doc("Supported compliance states for the policy initiatives.")
union PolicyComplianceState {
  @doc("The resource is compliant with respect to the given policy.")
  Compliant: "Compliant",

  @doc("The resource is not compliant with respect to the given policy.")
  NonCompliant: "NonCompliant",

  @doc("The resource is in a conflict with respect to the given policy.")
  Conflict: "Conflict",

  @doc("The resource is in a state that is not applicable to the given policy.")
  NotApplicable: "NotApplicable",

  @doc("The resource has not been evaluated for compliance with respect to the given policy.")
  NotEvaluated: "NotEvaluated",

  string,
}

@added(Versions.Preview20260315)
@doc("The filters to apply when querying for compliance details.")
model SovereignViewComplianceDetailsFilters {
  @doc("The field to filter on.")
  field: SovereignViewFilterField;

  @doc("The operator to apply for the filter.")
  operator: SovereignViewComplianceDetailsFilterOperators;

  @doc("The values to filter on.")
  value: string[];
}

@added(Versions.Preview20260315)
@doc("Supported filter fields for Sovereign View compliance details.")
union SovereignViewFilterField {
  @doc("Filter by subscription.")
  subscription: "subscription",

  @doc("Filter by resource group.")
  resourceGroup: "resourceGroup",

  @doc("Filter by resource name.")
  resourceName: "resourceName",

  @doc("Filter by resource type.")
  resourceType: "resourceType",

  @doc("Filter by region.")
  region: "region",

  @doc("Filter by Encryption In Transit compliance dimension.")
  encryptionInTransit: "encryptionInTransit",

  @doc("Filter by Data Residency compliance dimension.")
  dataResidency: "dataResidency",

  @doc("Filter by Encryption At Rest compliance dimension.")
  encryptionAtRest: "encryptionAtRest",

  @doc("Filter by Encryption In Use compliance dimension.")
  encryptionInUse: "encryptionInUse",

  string,
}

@added(Versions.Preview20260315)
@doc("Supported filter operators for Sovereign View Compliance details.")
union SovereignViewComplianceDetailsFilterOperators {
  @doc("In filter operator. Returns results where the field value is in the provided list of values.")
  In: "In",

  string,
}

@added(Versions.Preview20260315)
@doc("The sorting for compliance details.")
model SovereignViewComplianceDetailsSort {
  @doc("The field to sort on.")
  field: string;

  @doc("The direction to sort in.")
  direction: SovereignViewComplianceDetailsSortDirections;
}

@added(Versions.Preview20260315)
@doc("Supported sort directions for Sovereign View Compliance details.")
union SovereignViewComplianceDetailsSortDirections {
  @doc("Ascending sort direction.")
  Asc: "asc",

  @doc("Descending sort direction.")
  Desc: "desc",

  string,
}

@added(Versions.Preview20260315)
@doc("Search field and query for Sovereign View Compliance details.")
model SovereignViewComplianceDetailsSearch {
  @doc("The field to search on.")
  field: string;

  @doc("The value to search for in the specified field.")
  value: string;
}

@added(Versions.Preview20260315)
@doc("The response for the sovereign view compliance details action.")
model SovereignViewComplianceDetailsResponse {
  @doc("State indicating whether the data is processed or still being processed.")
  dataState: string;

  @doc("The time when compliance was last evaluated overall, in RFC3339 format.")
  lastEvaluated: utcDateTime;

  @doc("Total number of resources for the sovereign view.")
  @minValue(0)
  totalResources: int32;

  @doc("The list of compliance detail resources.")
  @identifiers(#["resourceId"])
  resources: SovereignViewComplianceDetailResource[];
}

@added(Versions.Preview20260315)
@doc("A compliance detail item for a resource.")
model SovereignViewComplianceDetailResource {
  @doc("The resource identifier.")
  resourceId: armResourceIdentifier<[]>;

  @doc("The location of the resource.")
  location: string;

  @doc("The compliance details for the resource across the dimensions.")
  @identifiers(#["dimension"])
  dimensionDetails: SovereignViewDimensionDetail[];
}

@added(Versions.Preview20260315)
@doc("A compliance detail item for a resource in the sovereign view compliance details action.")
model SovereignViewDimensionDetail {
  @doc("The compliance dimension for the compliance detail.")
  dimension: ComplianceDimension;

  @doc("The compliance state of the resource for the dimension.")
  state: PolicyComplianceState;

  @doc("The compliance details for the given dimension.")
  @identifiers(#["policyAssignmentId"])
  complianceDetails: SovereignViewComplianceDetail[];
}

@added(Versions.Preview20260315)
@doc("A compliance detail item for a resource in the sovereign view compliance details action.")
model SovereignViewComplianceDetail {
  @doc("The fully qualified id of the policy initiative associated with the compliance detail.")
  policyInitiativeId: armResourceIdentifier<[
    {
      type: "Microsoft.Authorization/policySetDefinitions";
    }
  ]>;

  @doc("The policy assignment for the compliance detail.")
  policyAssignmentId: armResourceIdentifier<[
    {
      type: "Microsoft.Authorization/policyAssignments";
    }
  ]>;

  @doc("The time when compliance was last evaluated by Azure Policy, in RFC3339 format.")
  evaluatedAt?: utcDateTime;
}

@added(Versions.Preview20260315)
@doc("The request for the sovereign view filter values action.")
model SovereignViewFilterValuesRequest {
  @doc("The filter field for which values are requested.")
  requestedFilter: SovereignViewFilterField;

  @doc("Optional filters to apply before returning filter values.")
  @identifiers(#["field", "operator"])
  filters?: SovereignViewComplianceDetailsFilters[];

  @doc("Optional search term applied to the requested filter field.")
  searchTerm?: string;
}

@added(Versions.Preview20260315)
@doc("The response for the sovereign view filter values action.")
model SovereignViewFilterValuesResponse {
  @doc("State indicating whether the data is processed or still being processed.")
  dataState: string;

  @doc("The filter field for which values are returned.")
  requestedFilter: SovereignViewFilterField;

  @doc("Total number of values available for the requested filter.")
  @minValue(0)
  totalCount: int32;

  @doc("The list of filter values and their counts.")
  @identifiers(#["value"])
  values: SovereignViewFilterValueItem[];
}

@added(Versions.Preview20260315)
@doc("A filter value item with the associated count.")
model SovereignViewFilterValueItem {
  @doc("The value for the filter.")
  value: string;

  @doc("The display name for the filter value.")
  displayName?: string;

  @doc("The count of resources that match the filter value.")
  @minValue(0)
  count: int32;
}
