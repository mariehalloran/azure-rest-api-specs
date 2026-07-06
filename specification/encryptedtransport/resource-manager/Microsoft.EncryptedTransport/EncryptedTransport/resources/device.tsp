// -----------------------------------------------------------------------
// <copyright file="device.tsp" company="Microsoft Corporation">
// Copyright (c) Microsoft Corporation. All rights reserved.
// </copyright>
// -----------------------------------------------------------------------
import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-autorest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.EncryptedTransport;

@doc("Device Resource Type")
@parentResource(EncryptedTransportAccount)
model Device is TrackedResource<DeviceProperties> {
  @doc("The device name")
  @key("deviceName")
  @visibility(Lifecycle.Read)
  @segment("devices")
  @pattern("^[a-zA-Z0-9-]{3,64}$")
  @path
  name: string;
}

@doc("Device Properties")
model DeviceProperties {
  @doc("Whether or not the end-user device has been provisioned.")
  @added(Microsoft.EncryptedTransport.Versions.v2026_06_01_preview)
  @visibility(Lifecycle.Read)
  provisioned?: boolean = false;

  @doc("Whether or not the end-user device is still enabled; this is set to false when the device is soft-terminated.")
  @added(Microsoft.EncryptedTransport.Versions.v2026_06_01_preview)
  @visibility(Lifecycle.Read)
  enabled?: boolean = false;

  @doc("The serial number that identifies the end-user device. This must be unique at the account scope.")
  @added(Microsoft.EncryptedTransport.Versions.v2026_06_01_preview)
  @pattern("^[a-zA-Z0-9]{3,24}$")
  @visibility(Lifecycle.Create, Lifecycle.Read, Lifecycle.Update)
  serialNumber: string;

  // (Deprecated due to visibility change)
  @doc("The serial number that identifies the end-user device. This must be unique at the account scope.")
  @renamedFrom(
    Microsoft.EncryptedTransport.Versions.v2026_06_01_preview,
    "serialNumber"
  )
  @removed(Microsoft.EncryptedTransport.Versions.v2026_06_01_preview)
  @pattern("^[a-zA-Z0-9]{3,24}$")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  oldSerialNumber: string;

  @doc("Reference to an existing device profile.")
  @added(Microsoft.EncryptedTransport.Versions.v2026_06_01_preview)
  @visibility(Lifecycle.Create, Lifecycle.Read, Lifecycle.Update)
  deviceProfileId: DeviceProfileId;

  // (Deprecated due to visibility change)
  @doc("Reference to an existing device profile.")
  @renamedFrom(
    Microsoft.EncryptedTransport.Versions.v2026_06_01_preview,
    "deviceProfileId"
  )
  @removed(Microsoft.EncryptedTransport.Versions.v2026_06_01_preview)
  @visibility(Lifecycle.Create, Lifecycle.Read)
  oldDeviceProfileId: DeviceProfileId;

  @doc("The status of the last operation.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/* https://azure.github.io/typespec-azure/docs/howtos/ARM/resource-type#using-resource-identifiers */
@doc("The device profile resource identifier of the selected device profile")
scalar DeviceProfileId
  extends Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.EncryptedTransport/encryptedTransportAccounts/deviceProfiles",
    }
  ]>;

@armResourceOperations
interface DeviceOperations {
  get is ArmResourceRead<Device>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Device>;
  update is ArmResourcePatchSync<Device, DeviceProperties>;
  delete is ArmResourceDeleteWithoutOkAsync<Device>;
  listByEncryptedTransportAccount is ArmResourceListByParent<Device>;
  listBySubscription is ArmListBySubscription<Device>;
}
