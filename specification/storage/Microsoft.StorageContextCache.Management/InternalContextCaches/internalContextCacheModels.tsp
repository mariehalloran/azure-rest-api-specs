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

namespace Microsoft.Storage;

/** The internal identity properties for an internal Azure Context Cache resource. */
alias InternalContextCacheResourceIdentityProperties = {
  /** The principal ID of the identity. */
  principalId?: string;

  /** The tenant ID of the identity. */
  tenantId?: string;

  /** The client ID of the identity. */
  clientId?: string;

  /** The internal Managed Identity Resource Provider assigned unique identifier for the identity. */
  internalId?: string;
};

/** User-Assigned Identity information for the backing resource for an internal Azure Context Cache resource. */
@added(Versions.v2026_03_01_preview)
model InternalContextCacheUserAssignedIdentity {
  /** The fully qualified ARM resource ID of the user-assigned identity. */
  @pattern("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.ManagedIdentity/userAssignedIdentities/[^/]+$")
  resourceId?: string;

  ...InternalContextCacheResourceIdentityProperties;
}

/** The managed identity associated with the internal context cache resource, populated by the system. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheResourceIdentity {
  /** The type of the identity (e.g. SystemAssigned, UserAssigned). */
  type?: string;

  ...InternalContextCacheResourceIdentityProperties;

  /** The list of User-assigned identities to be associated with the backing resource. Only supported from 2026-07-01-preview. */
  @added(Versions.v2026_03_01_preview)
  @identifiers(#["resourceId"])
  userAssignedIdentities?: InternalContextCacheUserAssignedIdentity[];
}

/** Properties linking the internal location-based resource back to the originating customer-facing Context Cache resource. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheResourceProperties {
  /** The ARM resource ID of the customer-facing Context Cache resource. */
  resourceId?: string;

  /** The resource type of the customer-facing resource (e.g., Microsoft.Storage/contextCaches). */
  resourceType?: string;

  /** The base location (region) where the customer-facing resource resides. */
  baseLocation?: string;

  /** The account kind of the customer-facing Context Cache resource. */
  baseAccountKind?: AccountKind;

  /** The name of the backing storage account for this regional resource. Populated by the internal creation flow; response-only. */
  storageAccountName?: string;

  /** The managed identity for this internal resource. */
  identity?: InternalContextCacheResourceIdentity;

  ...Azure.ResourceManager.Foundations.ArmTagsProperty;
}

/** Details of an internal Azure Context Cache Service Account. This resource is hidden from end users via AFEC and is managed internally by the resource provider. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheProperties {
  /** The kind of account determining storage topology. */
  accountKind: AccountKind;

  /** Account description. */
  @maxLength(250)
  description?: string;

  /** Encryption settings for the account. */
  encryption?: Azure.ResourceManager.CommonTypes.Encryption;

  /** The status of the last operation. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** Properties linking this internal resource to the originating customer-facing Context Cache resource. */
  resourceProperties: InternalContextCacheResourceProperties;
}

/** The updatable properties of an internal Azure Context Cache resource. */
@added(Versions.v2026_02_01_preview)
model InternalContextCachePropertiesUpdate {
  /** Account description. */
  @maxLength(250)
  description?: string;

  /** Encryption settings for the account. */
  encryption?: Azure.ResourceManager.CommonTypes.Encryption;

  /** Properties linking this internal resource to the originating customer-facing Context Cache resource. */
  resourceProperties?: InternalContextCacheResourceProperties;
}

/** The type used for update operations of an internal Azure Context Cache resource. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheUpdate {
  /** The updatable properties of the internal Azure Context Cache resource. */
  properties?: InternalContextCachePropertiesUpdate;
}
