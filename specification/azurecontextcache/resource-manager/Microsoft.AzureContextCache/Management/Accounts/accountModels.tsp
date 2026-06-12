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

  /** Encryption settings for the account. */
  @added(Versions.v2026_06_01_preview)
  encryption?: Azure.ResourceManager.CommonTypes.Encryption;
}

/** Updatable properties of a Prompt Service Account. */
model AccountPropertiesUpdate {
  /** Account description. */
  @maxLength(250)
  description?: string;

  /** Encryption settings for the account. */
  @added(Versions.v2026_06_01_preview)
  encryption?: Azure.ResourceManager.CommonTypes.Encryption;
}

/** The type used for update operations of the Account. */
model AccountUpdate {
  /** Resource tags. */
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;

  /** The managed service identity. */
  @added(Versions.v2026_06_01_preview)
  identity?: Azure.ResourceManager.CommonTypes.SystemAssignedServiceIdentity;

  /** The updatable properties of the Account. */
  properties?: AccountPropertiesUpdate;
}
