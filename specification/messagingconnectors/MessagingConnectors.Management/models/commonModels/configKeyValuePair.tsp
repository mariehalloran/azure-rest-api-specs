import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

namespace Microsoft.MessagingConnectors.Models.Common;

@doc("Configuration key-value pair for additional properties.")
model ConfigKeyValuePair {
  @doc("Configuration property name.")
  key: string;

  @doc("Configuration property value.")
  value: string;
}
