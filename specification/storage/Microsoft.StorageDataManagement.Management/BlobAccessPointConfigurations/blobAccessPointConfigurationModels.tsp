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
@doc("The type of the non-Azure S3-compatible data source exposed through the Blob Access Point.")
union BlobAccessPointSourceType {
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
  @doc("The identifier is an Azure resource ID.")
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

  string,
}

@added(Versions.v2026_06_01)
@discriminator("connectionType")
@doc("Details for connecting to a backing data source.")
model BlobAccessPointConnectionProperties {
  @doc("The connection type. This value determines the remaining shape of the connection object.")
  connectionType: BlobAccessPointConnectionType;
}

@added(Versions.v2026_06_01)
@doc("A direct endpoint connection.")
model BlobAccessPointEndpointConnectionProperties
  extends BlobAccessPointConnectionProperties {
  @visibility(Lifecycle.Read)
  connectionType: BlobAccessPointConnectionType.Endpoint;

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
  connectionType: BlobAccessPointConnectionType.PrivateLink;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("Whether privateLinkId contains an Azure resource ID or a Private Link alias.")
  privateLinkIdType: BlobAccessPointPrivateLinkIdType;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The Azure resource ID or alias of the backing Private Link resource.")
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
@discriminator("authType")
@doc("Authentication properties for a non-Azure S3-compatible source.")
model BlobAccessPointRemoteAuthProperties {
  @doc("The authentication type. This value determines the remaining shape of the authentication object.")
  authType: BlobAccessPointRemoteAuthType;
}

@added(Versions.v2026_06_01)
@doc("S3 access-key authentication properties.")
model BlobAccessPointAccessKeyAuthProperties
  extends BlobAccessPointRemoteAuthProperties {
  @visibility(Lifecycle.Read)
  authType: BlobAccessPointRemoteAuthType.AccessKey;

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
@doc("Information about the non-Azure S3-compatible data source exposed through a Blob Access Point.")
model BlobAccessPointSourceProperties {
  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("The type of the backing S3-compatible data source.")
  sourceType: BlobAccessPointSourceType;

  @visibility(Lifecycle.Create, Lifecycle.Read)
  @doc("Details for connecting to the backing data source.")
  connection: BlobAccessPointConnectionProperties;

  @doc("Details for authenticating to the backing data source.")
  auth: BlobAccessPointRemoteAuthProperties;

  @doc("The expected bucket owner account ID.")
  expectedBucketOwner?: string;
}

@added(Versions.v2026_06_01)
@discriminator("authType")
@doc("Mutable authentication properties for a non-Azure S3-compatible source.")
model BlobAccessPointRemoteAuthUpdateProperties {
  @doc("The authentication type. This value determines the remaining shape of the authentication object.")
  authType: BlobAccessPointRemoteAuthType;
}

@added(Versions.v2026_06_01)
@doc("Mutable S3 access-key authentication properties.")
model BlobAccessPointAccessKeyAuthUpdateProperties
  extends BlobAccessPointRemoteAuthUpdateProperties {
  authType: BlobAccessPointRemoteAuthType.AccessKey;

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
@doc("Mutable properties of a Blob Access Point source. The source type and its connection details are fixed when the configuration is created and cannot be changed.")
model BlobAccessPointSourceUpdateProperties {
  @doc("Replacement authentication properties.")
  auth?: BlobAccessPointRemoteAuthUpdateProperties;

  @doc("The expected bucket owner account ID.")
  expectedBucketOwner?: string;
}

@added(Versions.v2026_06_01)
@doc("Properties that can be updated on a Blob Access Point configuration.")
model BlobAccessPointConfigurationUpdateProperties {
  @doc("The configuration state.")
  state?: BlobAccessPointConfigurationState;

  @maxLength(250)
  @doc("An arbitrary description of the Blob Access Point configuration.")
  description?: string;

  @doc("Mutable backing-source properties.")
  source?: BlobAccessPointSourceUpdateProperties;
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
  @doc("The system-generated unique identifier of the Blob Access Point configuration, as returned by a read operation. This value must match the configuration named in the request path, and is required so that a configuration which was deleted and recreated under the same name is not tested by mistake.")
  @pattern("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")
  uniqueId: string;
}
