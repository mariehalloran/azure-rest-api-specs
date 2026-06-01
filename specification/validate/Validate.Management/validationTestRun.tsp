import "./common.tsp";
import "./validationExecutionPlan.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.Validate;

@doc("Validation Test Run represents execution instance(s) of a Validation Test instance under execution plan.")
@parentResource(ExecutionPlanRun)
model ValidationTestRun is ProxyResource<ValidationTestRunProperties> {
  ...ResourceNameParameter<ValidationTestRun>;
}

@doc("Validation Test Run represents execution instance(s) of a Validation Test instance under execution plan.")
model ValidationTestRunDetails {
  @doc("The unique identifier for the test run.")
  @visibility(Lifecycle.Read)
  id?: string;

  @doc("The name of the test run.")
  name?: string;

  @doc("The properties of the test run.")
  properties?: ValidationTestRunProperties;
}

@doc("Validation Test Run properties.")
model ValidationTestRunProperties {
  @doc("The overall status of the test run.")
  @visibility(Lifecycle.Read)
  status?: ValidationTestRunStatus;

  @doc("The state of the test run.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("The start timestamp of the test run.")
  @visibility(Lifecycle.Read)
  startTimestampInUtc?: utcDateTime;

  @doc("The reported timestamp of the test run.")
  @visibility(Lifecycle.Read)
  reportedTimestampInUtc?: utcDateTime;

  @doc("The end timestamp of the test run.")
  @visibility(Lifecycle.Read)
  endTimestampInUtc?: utcDateTime;

  @doc("The test id in the validation test catalog.")
  testId?: string;

  @doc("The validation test category id.")
  testCategoryId?: string;

  @doc("Validation test run inputs json")
  inputsJson?: string;

  @doc("Detailed pass information when the test passes.")
  @visibility(Lifecycle.Read)
  @identifiers(#[])
  @maxItems(100)
  passDetails?: ValidationTestPassDetails[];

  @doc("Detailed failure information when the test fails.")
  @visibility(Lifecycle.Read)
  @identifiers(#[])
  @maxItems(100)
  failureDetails?: ValidationTestFailureDetails[];
}

@doc("The overall status of the test run.")
union ValidationTestRunStatus {
  @doc("The test run is not running.")
  NotRunning: "NotRunning",

  @doc("The test run is scheduled.")
  Scheduled: "Scheduled",

  @doc("The test run is ready.")
  Ready: "Ready",

  @doc("The test run is running.")
  Running: "Running",

  @doc("The test run is completed.")
  Completed: "Completed",

  @doc("The test run is stopped.")
  Stopped: "Stopped",

  @doc("The test run is errored out.")
  Error: "Error",

  string,
}

@doc("Detailed information about test pass.")
model ValidationTestPassDetails {
  @doc("Result code categorizing the type of pass.")
  @visibility(Lifecycle.Read)
  resultCode?: string;

  @doc("test name which passed.")
  @visibility(Lifecycle.Read)
  testName?: string;

  @doc("Detailed information about the passed test.")
  @visibility(Lifecycle.Read)
  resultDetails?: string;
}

@doc("Detailed information about test failure.")
model ValidationTestFailureDetails {
  @doc("Error code categorizing the type of failure.")
  @visibility(Lifecycle.Read)
  errorCode?: string;

  @doc("Human-readable error message describing the failure.")
  @visibility(Lifecycle.Read)
  errorMessage?: string;

  @doc("Detailed information about the failure.")
  @visibility(Lifecycle.Read)
  details?: string;

  @doc("Additional diagnostic information.")
  @visibility(Lifecycle.Read)
  diagnosticInfo?: string;

  @doc("Suggested remediation steps for the customer.")
  @visibility(Lifecycle.Read)
  recommendedActions?: string[];
}

@armResourceOperations
@tag("Validation Test Run Interfaces")
interface ValidationTestRuns {
  @doc("Get a validation test run details")
  get is ArmResourceRead<ValidationTestRun>;

  @doc("List validation test runs for an execution plan run")
  listByExecutionPlanRun is ArmResourceListByParent<ValidationTestRun>;
}
