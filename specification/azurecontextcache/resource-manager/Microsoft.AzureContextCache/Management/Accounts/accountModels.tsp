import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "../common.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureContextCache;

/** Details of the Context Cache Account. */
model AccountProperties {
  /** The kind of account determining storage topology. */
  @visibility(Lifecycle.Create, Lifecycle.Read)
  accountKind: AccountKind;

  /** Account description. */
  @maxLength(250)
  description?: string;

  /** The status of the last operation. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}
