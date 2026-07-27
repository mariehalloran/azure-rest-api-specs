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

@added(Versions.v2026_06_01)
@doc("The state of a Blob Access Point configuration.")
union BlobAccessPointConfigurationState {
  @doc("The Blob Access Point configuration is active.")
  Active: "Active",

  @doc("The Blob Access Point configuration is inactive.")
  Inactive: "Inactive",

  string,
}

@added(Versions.v2026_06_01)
@doc("The status of the most recent connection test.")
union BlobAccessPointConnectionTestStatus {
  @doc("The connection test succeeded.")
  Succeeded: "Succeeded",

  @doc("The connection test failed.")
  Failed: "Failed",

  string,
}

@added(Versions.v2026_06_01)
@doc("The type of source exposed through the Blob Access Point.")
union BlobAccessPointSourceType {
  @doc("A path in the storage account that owns the Blob Access Point configuration.")
  Local: "Local",

  @doc("A Blob Access Point in another storage account.")
  BlobAccessPoint: "BlobAccessPoint",

  @doc("An Azure Storage account endpoint.")
  AzureStorageAccount: "AzureStorageAccount",

  @doc("A non-Azure data source that implements the S3-compatible REST API.")
  RemoteS3Compatible: "RemoteS3Compatible",

  string,
}

@added(Versions.v2026_06_01)
@doc("The type of a non-Azure S3-compatible backing data source.")
union BlobAccessPointBackingDataSourceType {
  @doc("NetApp ONTAP.")
  NetApp_ONTAP: "NetApp_ONTAP",

  @doc("Azure NetApp Files.")
  Azure_NetApp_Files: "Azure_NetApp_Files",

  @doc("Dell OneFS.")
  Dell_OneFS: "Dell_OneFS",

  @doc("Another S3-compatible data source.")
  S3_Compatible: "S3_Compatible",

  string,
}

@added(Versions.v2026_06_01)
@doc("The connection type used to reach a non-Azure backing data source.")
union BlobAccessPointConnectionType {
  @doc("Connect directly to a public or otherwise routable endpoint.")
  Endpoint: "Endpoint",

  @doc("Connect through Azure Private Link.")
  PrivateLink: "PrivateLink",

  string,
}

@added(Versions.v2026_06_01)
@doc("The format used by a Private Link identifier.")
union BlobAccessPointPrivateLinkIdType {
  @doc("The identifier is an ARM resource ID.")
  ResourceId: "ResourceId",

  @doc("The identifier is a Private Link alias.")
  Alias: "Alias",

  string,
}

@added(Versions.v2026_06_01)
@doc("TLS certificate verification behavior.")
union BlobAccessPointTlsVerification {
  @doc("Verify the TLS certificate chain.")
  Perform: "Perform",

  @doc("Skip TLS certificate-chain verification.")
  Skip: "Skip",

  string,
}

@added(Versions.v2026_06_01)
@doc("How Azure Storage authenticates to a non-Azure S3-compatible source.")
union BlobAccessPointRemoteAuthType {
  @doc("Authenticate with an S3 access key and secret access key.")
  AccessKey: "AccessKey",

  @doc("Use a managed identity to assume an S3-compatible role.")
  AssumeRoleWithManagedIdentity: "AssumeRoleWithManagedIdentity",

  string,
}

@added(Versions.v2026_06_01)
@doc("How Azure Storage authenticates to an Azure Blob source.")
union BlobAccessPointAzureAuthType {
  @doc("Authenticate with the configured managed identity.")
  ManagedIdentity: "ManagedIdentity",

  @doc("Pass the original caller identity to the provider Blob Access Point.")
  PassThrough: "PassThrough",

  string,
}

@added(Versions.v2026_06_01)
@doc("An authentication type that can be supplied in a configuration update.")
union BlobAccessPointAuthUpdateType {
  @doc("S3 access-key authentication.")
  AccessKey: "AccessKey",

  @doc("Managed-identity role-assumption authentication.")
  AssumeRoleWithManagedIdentity: "AssumeRoleWithManagedIdentity",

  @doc("Managed-identity authentication to an Azure Blob source.")
  ManagedIdentity: "ManagedIdentity",

  @doc("Pass-through authentication to an Azure Blob source.")
  PassThrough: "PassThrough",

  string,
}

@added(Versions.v2026_06_01)
@doc("The payment model for requests to an S3-compatible backing source.")
union BlobAccessPointPaymentModel {
  @doc("Use the backing source's default payment model.")
  Unspecified: "Unspecified",

  @doc("Set the S3 requester-pays request option.")
  RequesterPays: "RequesterPays",

  string,
}

@added(Versions.v2026_06_01)
@doc("The permission granted by a Blob Access Point access policy.")
union BlobAccessPointAccessPolicyPermission {
  @doc("Read and list data through the Blob Access Point.")
  Read: "Read",

  string,
}

@added(Versions.v2026_06_01)
@doc("The billing mode applied to a Blob Access Point access policy.")
union BlobAccessPointBillingType {
  @doc("Charge the owner of the provider Blob Access Point.")
  OwnerPay: "OwnerPay",

  @doc("Charge the requester.")
  RequesterPay: "RequesterPay",

  string,
}

@added(Versions.v2026_06_01)
@discriminator("type")
@doc("Information about the data source exposed through a Blob Access Point.")
model BlobAccessPointSourceProperties {
  @doc("The source type. This value determines the remaining shape of the source object.")
  type: BlobAccessPointSourceType;
}

@added(Versions.v2026_06_01)
@doc("A path in the storage account that owns the Blob Access Point configuration.")
model BlobAccessPointLocalSourceProperties
  extends BlobAccessPointSourceProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointSourceType.Local;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The source path, beginning with the container name, for example '/container1/directory1'.")
  @minLength(2)
  path: string;
}

@added(Versions.v2026_06_01)
@discriminator("type")
@doc("Details for connecting to a backing data source.")
model BlobAccessPointConnectionProperties {
  @doc("The connection type. This value determines the remaining shape of the connection object.")
  type: BlobAccessPointConnectionType;
}

@added(Versions.v2026_06_01)
@doc("A direct endpoint connection.")
model BlobAccessPointEndpointConnectionProperties
  extends BlobAccessPointConnectionProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointConnectionType.Endpoint;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The backing endpoint, including its protocol, host, optional port, and optional path.")
  @minLength(4)
  endpoint: url;

  @doc("TLS certificate verification behavior.")
  tlsVerification?: BlobAccessPointTlsVerification = BlobAccessPointTlsVerification.Perform;
}

@added(Versions.v2026_06_01)
@doc("A connection established through Azure Private Link.")
model BlobAccessPointPrivateLinkConnectionProperties
  extends BlobAccessPointConnectionProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointConnectionType.PrivateLink;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("Whether privateLinkId contains an ARM resource ID or a Private Link alias.")
  privateLinkIdType: BlobAccessPointPrivateLinkIdType;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The ARM resource ID or alias of the backing Private Link resource.")
  privateLinkId: string;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The Private Link group ID, when required by the backing resource.")
  privateLinkGroupId?: string;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The Azure region in which the private endpoint is provisioned.")
  privateLinkLocation: string;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The connection request message sent to the Private Link owner.")
  requestMessage: string;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The backing endpoint as seen by the target of the Private Link.")
  @minLength(4)
  endpoint: url;

  @doc("TLS certificate verification behavior.")
  tlsVerification?: BlobAccessPointTlsVerification = BlobAccessPointTlsVerification.Perform;

  @visibility(Lifecycle.Read)
  @doc("The name of the private endpoint created by Azure Storage.")
  privateEndpointName?: string;
}

@added(Versions.v2026_06_01)
@discriminator("type")
@doc("Authentication properties for a non-Azure S3-compatible source.")
model BlobAccessPointRemoteAuthProperties {
  @doc("The authentication type. This value determines the remaining shape of the authentication object.")
  type: BlobAccessPointRemoteAuthType;
}

@added(Versions.v2026_06_01)
@doc("S3 access-key authentication properties.")
model BlobAccessPointAccessKeyAuthProperties
  extends BlobAccessPointRemoteAuthProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointRemoteAuthType.AccessKey;

  @minLength(3)
  @doc("The access key ID.")
  accessKeyId: string;

  @visibility(Lifecycle.Create, Lifecycle.Update)
  @secret
  @minLength(3)
  @doc("The secret access key. This value is never returned by read or list operations.")
  secretAccessKey: string;

  @doc("The region used by the request-signing algorithm. The default is 'us-east-1'.")
  signingRegion?: string = "us-east-1";

  @doc("The host used when computing request signatures. The endpoint host is used by default.")
  hostOverride?: string;
}

@added(Versions.v2026_06_01)
@doc("Managed-identity role-assumption authentication properties.")
model BlobAccessPointAssumeRoleAuthProperties
  extends BlobAccessPointRemoteAuthProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointRemoteAuthType.AssumeRoleWithManagedIdentity;

  @doc("The ARM resource ID of the managed identity.")
  identityResourceId: string;

  @doc("The ARN of the role to assume.")
  roleArn: string;
}

@added(Versions.v2026_06_01)
@discriminator("type")
@doc("Authentication properties for an Azure Blob source.")
model BlobAccessPointAzureAuthProperties {
  @doc("The authentication type. This value determines the remaining shape of the authentication object.")
  type: BlobAccessPointAzureAuthType;
}

@added(Versions.v2026_06_01)
@doc("Managed-identity authentication properties for an Azure Blob source.")
model BlobAccessPointManagedIdentityAuthProperties
  extends BlobAccessPointAzureAuthProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointAzureAuthType.ManagedIdentity;

  @doc("The ARM resource ID of the managed identity.")
  identityResourceId: string;
}

@added(Versions.v2026_06_01)
@doc("Pass-through authentication properties for an Azure Blob source.")
model BlobAccessPointPassThroughAuthProperties
  extends BlobAccessPointAzureAuthProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointAzureAuthType.PassThrough;
}

@added(Versions.v2026_06_01)
@doc("A non-Azure S3-compatible backing source.")
model BlobAccessPointRemoteS3SourceProperties
  extends BlobAccessPointSourceProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointSourceType.RemoteS3Compatible;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The type of the backing S3-compatible data source.")
  backingDataSourceType: BlobAccessPointBackingDataSourceType;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("Details for connecting to the backing data source.")
  connection: BlobAccessPointConnectionProperties;

  @doc("Details for authenticating to the backing data source.")
  auth: BlobAccessPointRemoteAuthProperties;

  @doc("The expected bucket owner account ID.")
  expectedBucketOwner?: string;

  @doc("The backing source payment model.")
  paymentModel?: BlobAccessPointPaymentModel = BlobAccessPointPaymentModel.Unspecified;
}

@added(Versions.v2026_06_01)
@doc("A Blob Access Point in another Azure Storage account.")
model BlobAccessPointRemoteAccessPointSourceProperties
  extends BlobAccessPointSourceProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointSourceType.BlobAccessPoint;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The endpoint of the provider Blob Access Point.")
  endpointConnection: BlobAccessPointEndpointConnectionProperties;

  @doc("Details for authenticating to the provider Blob Access Point.")
  auth: BlobAccessPointAzureAuthProperties;
}

@added(Versions.v2026_06_01)
@doc("An Azure Storage account backing source.")
model BlobAccessPointAzureStorageAccountSourceProperties
  extends BlobAccessPointSourceProperties {
  @visibility(Lifecycle.Read)
  type: BlobAccessPointSourceType.AzureStorageAccount;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The endpoint of the Azure Storage account or container.")
  endpointConnection: BlobAccessPointEndpointConnectionProperties;

  @doc("Details for authenticating to the Azure Storage account.")
  auth: BlobAccessPointAzureAuthProperties;
}

@added(Versions.v2026_06_01)
@doc("An access policy for a Blob Access Point configuration.")
model BlobAccessPointAccessPolicy {
  @doc("The Microsoft Entra object ID of the principal.")
  @pattern("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")
  principalId: string;

  @doc("The Microsoft Entra tenant ID of the principal.")
  @pattern("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")
  tenantId: string;

  @doc("The permission granted to the principal.")
  permission?: BlobAccessPointAccessPolicyPermission = BlobAccessPointAccessPolicyPermission.Read;

  @doc("The billing mode applied to requests authorized by this policy.")
  billingType?: BlobAccessPointBillingType = BlobAccessPointBillingType.OwnerPay;
}

@added(Versions.v2026_06_01)
@discriminator("type")
@doc("Mutable authentication properties for a Blob Access Point source.")
model BlobAccessPointAuthUpdateProperties {
  @doc("The authentication type. This value determines the remaining shape of the authentication object.")
  type: BlobAccessPointAuthUpdateType;
}

@added(Versions.v2026_06_01)
@doc("Mutable S3 access-key authentication properties.")
model BlobAccessPointAccessKeyAuthUpdateProperties
  extends BlobAccessPointAuthUpdateProperties {
  type: BlobAccessPointAuthUpdateType.AccessKey;

  @minLength(3)
  @doc("The access key ID.")
  accessKeyId?: string;

  @secret
  @minLength(3)
  @doc("A replacement secret access key.")
  secretAccessKey?: string;

  @doc("The region used by the request-signing algorithm.")
  signingRegion?: string;

  @doc("The host used when computing request signatures.")
  hostOverride?: string;
}

@added(Versions.v2026_06_01)
@doc("Mutable managed-identity role-assumption authentication properties.")
model BlobAccessPointAssumeRoleAuthUpdateProperties
  extends BlobAccessPointAuthUpdateProperties {
  type: BlobAccessPointAuthUpdateType.AssumeRoleWithManagedIdentity;

  @doc("The ARM resource ID of the managed identity.")
  identityResourceId?: string;

  @doc("The ARN of the role to assume.")
  roleArn?: string;
}

@added(Versions.v2026_06_01)
@doc("Mutable managed-identity authentication properties for an Azure Blob source.")
model BlobAccessPointManagedIdentityAuthUpdateProperties
  extends BlobAccessPointAuthUpdateProperties {
  type: BlobAccessPointAuthUpdateType.ManagedIdentity;

  @doc("The ARM resource ID of the managed identity.")
  identityResourceId?: string;
}

@added(Versions.v2026_06_01)
@doc("Pass-through authentication update properties.")
model BlobAccessPointPassThroughAuthUpdateProperties
  extends BlobAccessPointAuthUpdateProperties {
  type: BlobAccessPointAuthUpdateType.PassThrough;
}

@added(Versions.v2026_06_01)
@doc("Mutable properties of a Blob Access Point source.")
model BlobAccessPointSourceUpdateProperties {
  @doc("Replacement authentication properties.")
  auth?: BlobAccessPointAuthUpdateProperties;

  @doc("The expected bucket owner account ID.")
  expectedBucketOwner?: string;

  @doc("The backing source payment model.")
  paymentModel?: BlobAccessPointPaymentModel;
}

@added(Versions.v2026_06_01)
@doc("Properties that can be updated on a Blob Access Point configuration.")
model BlobAccessPointConfigurationMutableProperties {
  @doc("The configuration state.")
  state?: BlobAccessPointConfigurationState;

  @maxLength(250)
  @doc("An arbitrary description of the Blob Access Point configuration.")
  description?: string;

  @doc("Mutable backing-source properties.")
  source?: BlobAccessPointSourceUpdateProperties;

  @doc("Access policies used for Blob Access Point data-sharing scenarios.")
  @Azure.ResourceManager.identifiers(#["principalId", "tenantId"])
  accessPolicies?: BlobAccessPointAccessPolicy[];
}

@added(Versions.v2026_06_01)
@doc("Details of a Blob Access Point configuration.")
model BlobAccessPointConfigurationProperties {
  @visibility(Lifecycle.Read)
  @doc("The system-generated unique identifier of the configuration.")
  @pattern("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")
  uniqueId?: string;

  @doc("The configuration state.")
  state?: BlobAccessPointConfigurationState = BlobAccessPointConfigurationState.Active;

  @visibility(Lifecycle.Read)
  @doc("The system-generated creation time.")
  creationTime?: utcDateTime;

  @maxLength(250)
  @doc("An arbitrary description of the Blob Access Point configuration.")
  description?: string;

  @visibility(Lifecycle.Read)
  @doc("The status of the most recent connection test.")
  lastConnectionTestStatus?: BlobAccessPointConnectionTestStatus;

  @visibility(Lifecycle.Read)
  @doc("The timestamp of the most recent connection test.")
  lastConnectionTestTimestamp?: utcDateTime;

  @visibility(Lifecycle.Read)
  @doc("The normalized and redacted error from the most recent failed connection test.")
  lastConnectionTestErrorMessage?: string;

  @doc("Information about the backing data source.")
  source: BlobAccessPointSourceProperties;

  @doc("Access policies used for Blob Access Point data-sharing scenarios.")
  @Azure.ResourceManager.identifiers(#["principalId", "tenantId"])
  accessPolicies?: BlobAccessPointAccessPolicy[];

  @visibility(Lifecycle.Read)
  @doc("The status of the last operation.")
  provisioningState?: ProvisioningState;
}

@added(Versions.v2026_06_01)
@doc("The result of testing a Blob Access Point configuration connection.")
model BlobAccessPointConnectionTestResponse {
  @doc("The request attempted against the backing source. Valid values include 'List' and 'GetBlob'.")
  methodName?: string;

  @doc("A normalized and redacted backing-source error message.")
  errorMessage?: string;

  @doc("The request ID returned by the backing source, when available.")
  requestId?: string;
}

@added(Versions.v2026_06_01)
@withVisibility(Lifecycle.Create)
@doc("The request used to test a proposed Blob Access Point configuration.")
model BlobAccessPointProposedConnectionTestRequest {
  ...BlobAccessPointConfigurationProperties;
}

@added(Versions.v2026_06_01)
@doc("The request used to test an existing Blob Access Point configuration.")
model BlobAccessPointConnectionTestRequest {
  @doc("The unique identifier of the Blob Access Point configuration.")
  @pattern("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")
  uniqueId: string;
}
