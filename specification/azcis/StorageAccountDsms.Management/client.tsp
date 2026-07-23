import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using Microsoft.AzureCis;

// The `operator` property is an unnamed union ("==" | string) which the
// csharp-mgmt emitter renders as an extensible enum. Its only literal value
// "==" produces an empty identifier and crashes the emitter. Treat it as a
// plain string for csharp; the wire format is unchanged.
@@alternateType(BlobIndexMatch.operator, string, "csharp");
