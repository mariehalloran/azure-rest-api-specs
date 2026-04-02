import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;

@@clientName(Microsoft.Solutions, "ApplicationClient", "javascript");
@@clientLocation(Microsoft.Solutions.Operations.list,
  "Microsoft.Solutions",
  "javascript"
);
@@clientName(Microsoft.Solutions.Operations.list,
  "listOperations",
  "javascript"
);
