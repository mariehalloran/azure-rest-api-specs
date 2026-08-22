import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Storage;

@@clientName(
  BlobAccessPointConnectionTestResponse,
  "BlobAccessPointConnectionTestResult",
  "csharp"
);

@@clientName(
  BlobAccessPointProposedConnectionTestRequest,
  "BlobAccessPointProposedConnectionTestContent",
  "csharp"
);

@@clientName(
  BlobAccessPointConnectionTestRequest,
  "BlobAccessPointConnectionTestContent",
  "csharp"
);
