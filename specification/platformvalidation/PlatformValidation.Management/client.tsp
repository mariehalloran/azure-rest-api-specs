import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using Microsoft.PlatformValidation;

// ============================================================================
// SDK client customization overlay
//
// The SDK name is kept identical to the ARM resource provider
// (`Microsoft.PlatformValidation` -> `Azure.ResourceManager.PlatformValidation` /
// `azure-mgmt-platformvalidation`), so the generated client defaults to
// `PlatformValidationClient`. This overlay only
// assigns friendly operation-group (client accessor) names, without touching
// the canonical API spec (main.tsp / *.tsp).
// ============================================================================

// Operation groups (client accessors)
@@clientName(ValidationExecutionPlans, "ExecutionPlans", "csharp,python");
@@clientName(ValidationExecutionPlanRuns, "ExecutionRuns", "csharp,python");
@@clientName(ValidationTestRuns, "TestRuns", "csharp,python");
@@clientName(ValidationTests, "Tests", "csharp,python");
@@clientName(ValidationTestVersions, "TestVersions", "csharp,python");
@@clientName(ValidationTestCategories, "TestCategories", "csharp,python");
