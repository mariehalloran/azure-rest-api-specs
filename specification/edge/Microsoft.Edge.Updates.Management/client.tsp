import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;

namespace Microsoft.Edge;

@@clientName(Update, "EdgeUpdate", "java");
