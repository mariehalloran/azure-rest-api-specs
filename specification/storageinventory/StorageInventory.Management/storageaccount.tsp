import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.StorageInventory;

/** Properties published for an internal storage account. */
@added(Versions.v2026_07_01_preview)
model StorageAccountProperties {
  /** Specifies the type of DNS endpoint used by the storage account. */
  @visibility(Lifecycle.Read)
  dnsEndpointType?: string;

  /** Indicates whether the storage account only supports HTTPS traffic. */
  @visibility(Lifecycle.Read)
  supportsHttpsTrafficOnly?: boolean;

  /** The status of the last operation. */
  @visibility(Lifecycle.Read)
  provisioningState?: Azure.ResourceManager.ResourceProvisioningState;

  /** The creation date and time of the storage account. */
  @visibility(Lifecycle.Read)
  creationTime?: utcDateTime;
}

/** An internal storage account represented in storage inventory. */
@added(Versions.v2026_07_01_preview)
model StorageAccount is ProxyResource<StorageAccountProperties> {
  ...ResourceNameParameter<
    Resource = StorageAccount,
    KeyName = "storageAccountName",
    SegmentName = "storageAccounts"
  >;
}

@added(Versions.v2026_07_01_preview)
@armResourceOperations
interface StorageAccounts {
  get is ArmResourceRead<StorageAccount>;
  listByResourceGroup is ArmResourceListByParent<StorageAccount>;
}
