import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;

@@clientName(
  Azure.ResourceManager.CommonTypes.CheckNameAvailabilityResponse,
  "CheckNameAvailabilityResult",
  "csharp"
);

@@clientName(
  Azure.ResourceManager.CommonTypes.CheckNameAvailabilityResponse.nameAvailable,
  "IsNameAvailable",
  "csharp"
);
