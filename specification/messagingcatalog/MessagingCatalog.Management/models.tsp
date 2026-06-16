import "@typespec/rest";
import "@typespec/http";
import "@typespec/openapi";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.MessagingCatalog;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * The available API versions.
 */
enum Versions {
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  @doc("The 2024-06-01-preview API version.")
  v2024_06_01_preview: "2024-06-01-preview",

  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  @doc("The 2024-10-01-preview API version.")
  v2024_10_01_preview: "2024-10-01-preview",

  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  @doc("The 2025-11-01-preview API version.")
  v2025_11_01_preview: "2025-11-01-preview",

  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @doc("The 2026-06-01-preview API version.")
  v2026_06_01_preview: "2026-06-01-preview",
}

@doc("Provisioning State")
@Azure.Core.lroStatus
union ProvisioningState {
  string,
  ResourceProvisioningState,

  @doc("Resource is updating.")
  Updating: "Updating",

  @doc("Resource is deleting.")
  Deleting: "Deleting",
}

@doc("Fabric Private Links Actions")
@added(Versions.v2025_11_01_preview)
union FabricPrivateLinksAction {
  string,

  @doc("Enable private link.")
  Enable: "Enable",

  @doc("Disable private link.")
  Disable: "Disable",
}

/** State of the public network access. */
@added(Versions.v2025_11_01_preview)
union PublicNetworkAccess {
  string,

  /** The public network access is enabled. */
  Enabled: "Enabled",

  /** The public network access is disabled. */
  Disabled: "Disabled",
}

@doc("Details of the Message Catalog.")
model MessagingCatalogProperties {
  @doc("A unique absolute URL for an catalog.")
  @visibility(Lifecycle.Read)
  self?: string;

  @doc("A summary of the purpose of the catalog.")
  description?: string;

  @doc("A URL to additional information about this catalog.")
  documentation?: string;

  @doc("An array of additional metadata about the catalog.")
  @identifiers(#["name"])
  labels?: ResourceLabel[];

  @doc("A unique absolute URL for the list of endpoints for this catalog.")
  @visibility(Lifecycle.Read)
  endpointsUrl?: string;

  @doc("A count of the amount of endpoints in this catalog.")
  @visibility(Lifecycle.Read)
  endpointsCount?: int32;

  @doc("A unique absolute URL for the list of message groups for this catalog.")
  @visibility(Lifecycle.Read)
  messageGroupsUrl?: string;

  @doc("A count of the amount of message groups in this catalog.")
  @visibility(Lifecycle.Read)
  messageGroupsCount?: int32;

  @doc("A unique absolute URL for the list of schema groups for this catalog.")
  @visibility(Lifecycle.Read)
  schemaGroupsUrl?: string;

  @doc("A count of the amount of schema groups in this catalog.")
  @visibility(Lifecycle.Read)
  schemaGroupsCount?: int32;

  @doc("The provisioning state of the application rule collection resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** List of private endpoint connections. */
  @visibility(Lifecycle.Read)
  @added(Versions.v2025_11_01_preview)
  privateEndpointConnections?: PrivateEndpointConnection[];

  /** Gets or sets allow or disallow public network access to resource. */
  @added(Versions.v2025_11_01_preview)
  publicNetworkAccess?: PublicNetworkAccess;

  @doc("The customer-managed key encryption settings for the catalog.")
  @added(Versions.v2026_06_01_preview)
  encryption?: EncryptionSettings;
}

@doc("Additional metadata about the entity.")
model ResourceLabel {
  @doc("The name of the metadata label.")
  name?: string;

  @doc("The value of the metadata label.")
  value?: string;
}

@doc("The type used for update operations of the Messaging Catalog.")
model MessagingCatalogUpdate {
  ...Azure.ResourceManager.Foundations.ArmTagsProperty;

  @doc("The managed service identities assigned to this resource, used to access the customer-managed key in Key Vault.")
  @added(Versions.v2026_06_01_preview)
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentity;

  @doc("The updatable properties of the Messaging Catalog.")
  properties?: MessagingCatalogUpdateProperties;
}

@doc("The updatable properties of the Messaging Catalog.")
model MessagingCatalogUpdateProperties {
  @doc("A summary of the purpose of the catalog.")
  description?: string;

  @doc("A URL to additional information about this catalog.")
  documentation?: string;

  @doc("An array of additional metadata about the catalog.")
  @identifiers(#["name"])
  labels?: ResourceLabel[];

  @doc("The customer-managed key encryption settings for the catalog. Supplying this on update enables or updates customer-managed key encryption on an existing catalog.")
  @added(Versions.v2026_06_01_preview)
  encryption?: EncryptionSettings;
}

@doc("Details about the error result.")
model ProblemDetails {
  @doc("Type of issue encountered.")
  type?: string;

  @doc("Title of issue encountered.")
  title?: string;

  @doc("Status code of issue encountered.")
  status?: int32;

  @doc("Brief description of issue encountered.")
  detail?: string;

  @doc("Details about the error result.")
  instance?: string;
}

@doc("An association between external entities and catalog resources.")
@added(Versions.v2024_10_01_preview)
model Association {
  @doc("Id of the association.")
  id?: string;

  @doc("Type of association.")
  associationType: string;

  @doc("Details about the Association.")
  definition: AssociationDefinition;
}

@doc("Details about the catalog association.")
@added(Versions.v2024_10_01_preview)
model AssociationDefinition {
  @doc("The tenant id to associate.")
  tenantId?: string;

  @doc("The workspace id to associate.")
  workspaceId?: string;

  @doc("The artifact id to associate.")
  artifactId?: string;

  @doc("The message group id to associate.")
  messageGroupId?: string;

  @doc("The schema group id to associate.")
  schemaGroupId?: string;
}

@doc("An request to remove an association.")
@added(Versions.v2024_10_01_preview)
model AssociationRemoveRequest {
  @doc("Id of the association, which by default is a guid.")
  associationId: string;
}

@doc("An request to paginate a list of result.")
@added(Versions.v2024_10_01_preview)
model AssociationListRequest {
  @doc("Controls how many results to skip.")
  skip?: int32;

  @doc("Controls how many results to retrieve.")
  top?: int32;
}

@doc("An response of paginated associations.")
@added(Versions.v2024_10_01_preview)
model AssociationListResponse {
  @doc("List of associations.")
  associations: Association[];
}

@doc("An response of a association deletion.")
@added(Versions.v2024_10_01_preview)
model AssociationDeleteResponse {
  @doc("A string detailing the result of the operation.")
  status: ProvisioningState;
}

@doc("A request to update Fabric Private Links on a Catalog.")
@added(Versions.v2025_11_01_preview)
model FabricPrivateLinksRequest {
  @doc("The action to perform on the Fabric Private Links.")
  action: FabricPrivateLinksAction;

  @doc("The fully qualified domain name of the fabric dataplane endpoint.")
  fabricFqdn: string;
}

@doc("An response of a Fabric Private Links request.")
@added(Versions.v2025_11_01_preview)
model FabricPrivateLinksResponse {
  @doc("The status of the Fabric Private Links request.")
  status: string;

  @doc("The private FQDN of the messaging catalog is redirecting to.")
  privateFqdn: string;
}

@doc("The current status of customer-managed key encryption on the catalog.")
@added(Versions.v2026_06_01_preview)
union EncryptionStatus {
  string,

  @doc("Customer-managed key encryption is disabled.")
  Disabled: "Disabled",

  @doc("Customer-managed key encryption is enabled.")
  Enabled: "Enabled",
}

@doc("The type of identity used to access the key encryption key in Key Vault.")
@added(Versions.v2026_06_01_preview)
union CmkIdentityType {
  string,

  @doc("A user-assigned managed identity is used to access the key. This is the only supported value in this preview.")
  userAssignedIdentity: "userAssignedIdentity",
}

@doc("The identity used to access the customer-managed key in Key Vault.")
@added(Versions.v2026_06_01_preview)
model KeyEncryptionKeyIdentity {
  @doc("The type of identity used to access the key. Only 'userAssignedIdentity' is supported.")
  identityType: CmkIdentityType;

  @doc("The ARM resource id of the user-assigned managed identity used to access the key. It must be one of the identities assigned to the resource.")
  userAssignedIdentityResourceId: string;
}

@doc("Customer-managed key encryption properties for the catalog.")
@added(Versions.v2026_06_01_preview)
model CustomerManagedKeyEncryption {
  @doc("The identity used to access the key encryption key in Key Vault.")
  keyEncryptionKeyIdentity: KeyEncryptionKeyIdentity;

  @doc("The Key Vault key URL used to encrypt the catalog. A versionless URL (.../keys/{name}) or a versioned URL (.../keys/{name}/{version}) is accepted.")
  keyEncryptionKeyUrl: string;
}

@doc("Encryption settings for the catalog.")
@added(Versions.v2026_06_01_preview)
model EncryptionSettings {
  @doc("All customer-managed key encryption properties for the catalog.")
  customerManagedKeyEncryption: CustomerManagedKeyEncryption;

  @doc("The current status of customer-managed key encryption. This property is read-only and is computed by the service.")
  @visibility(Lifecycle.Read)
  encryptionStatus?: EncryptionStatus;
}

@doc("The outcome of a customer-managed key encryption verification.")
@added(Versions.v2026_06_01_preview)
union CmkVerifyStatus {
  string,

  @doc("Both the liveness check and the fresh wrap/unwrap round-trip succeeded.")
  Passed: "Passed",

  @doc("One or more verification checks failed.")
  Failed: "Failed",
}

@doc("The result of a customer-managed key encryption verification action.")
@added(Versions.v2026_06_01_preview)
model CmkVerifyResult {
  @doc("'Passed' when both the liveness and round-trip checks succeed; otherwise 'Failed'.")
  status: CmkVerifyStatus;

  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "keyVaultKey is the versioned Key Vault key identifier (URL), not secret key material; it is intentionally returned to the operator in the verify result."
  @doc("The versioned Key Vault key URI that was exercised during verification.")
  keyVaultKey?: string;

  @doc("The UTC time at which the verification ran.")
  checkedAt: utcDateTime;
}
