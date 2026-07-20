import "./common.tsp";

using TypeSpec.Versioning;

namespace Microsoft.ManagedNetworkFabric;

@doc("Management mode for the Fabric.")
@added(Versions.v2026_01_15_preview)
union ManagementMode {
  string,

  @doc("Customer manages devices.")
  unmanaged: "unmanaged",

  @doc("RP manages devices.")
  managed: "managed",
}

@doc("Controller type for device interaction.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
union ControllerType {
  string,

  @doc("Cisco ACI APIC REST API.")
  ciscoAci: "ciscoAci",

  @doc("Arista CloudVision API.")
  aristaCloudVision: "aristaCloudVision",

  @doc("Direct gNMI/SSH.")
  direct: "direct",
}

@doc("Operation policy for device interaction.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
union OperationPolicy {
  string,

  @doc("Read device state and report drift.")
  validateOnly: "validateOnly",

  @doc("Read, write, and remediate drift.")
  fullControl: "fullControl",
}

@doc("Infrastructure network definition.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model InfraNetwork {
  @doc("802.1Q VLAN ID.")
  @minValue(1)
  @maxValue(4094)
  vlanId: int32;

  @doc("IPv4 subnet in CIDR notation.")
  ipv4Subnet: string;

  @doc("Default gateway IP.")
  ipv4Gateway: string;

  @doc("Start of allocatable IP range.")
  ipv4StartAddr: string;

  @doc("End of allocatable IP range.")
  ipv4EndAddr: string;

  @doc("Maximum Transmission Unit.")
  mtu?: int32;
}

@doc("Infrastructure network with optional IP fields.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model InfraNetworkOptionalIp {
  @doc("802.1Q VLAN ID.")
  @minValue(1)
  @maxValue(4094)
  vlanId: int32;

  @doc("IPv4 subnet in CIDR notation.")
  ipv4Subnet?: string;

  @doc("Default gateway IP.")
  ipv4Gateway?: string;

  @doc("Start of allocatable IP range.")
  ipv4StartAddr?: string;

  @doc("End of allocatable IP range.")
  ipv4EndAddr?: string;

  @doc("Maximum Transmission Unit.")
  mtu?: int32;
}

@doc("Named infrastructure network definitions.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model InfrastructureNetworks {
  @doc("OAM management network. Typical VLAN: 39.")
  management: InfraNetwork;

  @doc("PXE boot network. Typical VLAN: 40.")
  pxe: InfraNetwork;

  @doc("BMC/iDRAC network. Typical VLAN: 41.")
  bmc: InfraNetwork;

  @doc("Storage data plane network. Typical VLAN: 42.")
  storage: InfraNetwork;

  @doc("Storage management plane network. Typical VLAN: 37.")
  storageMgmt?: InfraNetworkOptionalIp;

  @doc("PDU management network. Typical VLAN: 43.")
  pdu?: InfraNetwork;
}

@doc("Platform proxy configuration.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model PlatformProxy {
  @doc("HTTP proxy endpoint URL.")
  httpProxy: string;

  @doc("HTTPS proxy endpoint URL.")
  httpsProxy: string;

  @doc("CIDRs, hostnames, and domain suffixes that bypass the proxy.")
  noProxy: string[];
}

@doc("Infrastructure service endpoints.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model InfrastructureServices {
  @doc("Platform proxy configuration.")
  platformProxy: PlatformProxy;

  @doc("NTP server IPs or hostnames.")
  @minItems(1)
  ntpServers: string[];

  @doc("DNS server IPs.")
  @minItems(1)
  dnsServers: string[];
}

@doc("Extensible network purpose identifier. Known values: management, pxe, bmc, pdu, storage, storageMgmt, ovn, vmLiveMigration.")
@added(Versions.v2026_07_15_preview)
union NetworkPurpose {
  string,

  @doc("OAM / out-of-band management network (VRF: INFRA-MGMT).")
  management: "management",

  @doc("PXE boot provisioning network (VRF: INFRA-MGMT).")
  pxe: "pxe",

  @doc("BMC / iDRAC management network (VRF: INFRA-MGMT).")
  bmc: "bmc",

  @doc("PDU power management network (VRF: INFRA-MGMT).")
  pdu: "pdu",

  @doc("Storage data-plane network (VRF: STORAGE-DATA).")
  storage: "storage",

  @doc("Storage management-plane network (VRF: STORAGE-MGMT).")
  storageMgmt: "storageMgmt",

  @doc("OVN virtual networking management network.")
  ovn: "ovn",

  @doc("VM live-migration data-plane network.")
  vmLiveMigration: "vmLiveMigration",
}

@doc("Extensible proxy config purpose identifier.")
@added(Versions.v2026_07_15_preview)
union ProxyConfigPurpose {
  string,

  @doc("Infrastructure-plane proxy for platform services.")
  platformProxy: "platformProxy",
}

@doc("Network definition for an infrastructure network.")
@added(Versions.v2026_07_15_preview)
model NetworkDefinition {
  @doc("Extensible network role identifier.")
  purpose: NetworkPurpose;

  @doc("Human-readable immutable correlation key.")
  @minLength(1)
  @maxLength(253)
  name: string;

  @doc("VLAN identifier (1-4094). Must be unique across all networks.")
  @minValue(1)
  @maxValue(4094)
  vlanId: int32;

  @doc("IPv4 subnet in CIDR notation (e.g. '10.49.6.0/24'). At least one of ipv4Subnet or ipv6Subnet must be provided.")
  ipv4Subnet?: string;

  @doc("IPv4 default gateway address.")
  ipv4Gateway?: string;

  @doc("First usable IPv4 address in the pool.")
  ipv4StartAddr?: string;

  @doc("Last usable IPv4 address in the pool.")
  ipv4EndAddr?: string;

  @doc("IPv6 subnet in CIDR notation. At least one of ipv4Subnet or ipv6Subnet must be provided.")
  ipv6Subnet?: string;

  @doc("IPv6 default gateway address.")
  ipv6Gateway?: string;

  @doc("First usable IPv6 address in the pool.")
  ipv6StartAddr?: string;

  @doc("Last usable IPv6 address in the pool.")
  ipv6EndAddr?: string;

  @doc("IPv4 maximum transmission unit (68-9216). Default: 1500.")
  @minValue(68)
  @maxValue(9216)
  ipv4Mtu?: int32 = 1500;

  @doc("IPv6 maximum transmission unit (1280-9216). Default: 1500.")
  @minValue(1280)
  @maxValue(9216)
  ipv6Mtu?: int32 = 1500;

  @doc("Enables DHCP addressing. Valid only for management purpose.")
  useDhcp?: boolean = false;
}

@doc("Proxy configuration for a traffic scope.")
@added(Versions.v2026_07_15_preview)
model ProxyConfigEntry {
  @doc("Extensible traffic scope identifier. Known values: platformProxy.")
  purpose: ProxyConfigPurpose;

  @doc("HTTP proxy endpoint. IPv4 address with port (e.g. 'http://172.16.1.10:3128').")
  httpProxy?: string;

  @doc("HTTPS proxy endpoint. Same format as httpProxy.")
  httpsProxy?: string;

  @doc("Destinations that bypass the proxy. Each entry is a CIDR, hostname suffix, or IP address.")
  noProxy?: string[];
}

@doc("Proxy configuration for tenant traffic scope.")
@added(Versions.v2026_07_15_preview)
model TenantProxyConfig {
  @doc("HTTP proxy endpoint. IPv4 address with port. Can be the same as infrastructure platformProxy.")
  httpProxy?: string;

  @doc("HTTPS proxy endpoint. Same format as httpProxy.")
  httpsProxy?: string;

  @doc("Destinations that bypass the proxy.")
  noProxy?: string[];
}

@doc("Tenant network definition for workload proxy networking.")
@added(Versions.v2026_07_15_preview)
model TenantNetworkDefinition {
  @doc("Human-readable immutable correlation key.")
  @minLength(1)
  @maxLength(253)
  name: string;

  @doc("VLAN identifier (1-4094).")
  @minValue(1)
  @maxValue(4094)
  vlanId: int32;

  @doc("IPv4 subnet in CIDR notation.")
  ipv4Subnet?: string;

  @doc("IPv4 default gateway address.")
  ipv4Gateway?: string;

  @doc("First usable IPv4 address in the pool.")
  ipv4StartAddr?: string;

  @doc("Last usable IPv4 address in the pool.")
  ipv4EndAddr?: string;

  @doc("IPv6 subnet in CIDR notation.")
  ipv6Subnet?: string;

  @doc("IPv6 default gateway address.")
  ipv6Gateway?: string;

  @doc("First usable IPv6 address in the pool.")
  ipv6StartAddr?: string;

  @doc("Last usable IPv6 address in the pool.")
  ipv6EndAddr?: string;

  @doc("IPv4 maximum transmission unit (68-9216). Default: 1500.")
  @minValue(68)
  @maxValue(9216)
  ipv4Mtu?: int32 = 1500;

  @doc("IPv6 maximum transmission unit (1280-9216). Default: 1500.")
  @minValue(1280)
  @maxValue(9216)
  ipv6Mtu?: int32 = 1500;
}

@doc("Infrastructure configuration: networks, proxy, DNS, and NTP.")
@added(Versions.v2026_07_15_preview)
model InfrastructureConfig {
  @doc("Infrastructure networks. Flat array with extensible purpose.")
  @minItems(1)
  @Azure.ResourceManager.identifiers(#["purpose"])
  networks: NetworkDefinition[];

  @doc("Proxy configurations. At least one entry with purpose 'platformProxy' required.")
  @minItems(1)
  @Azure.ResourceManager.identifiers(#["purpose"])
  proxyConfigs: ProxyConfigEntry[];

  @doc("Infrastructure DNS resolver IPv4 addresses.")
  dnsServers?: string[];

  @doc("Infrastructure NTP server IPv4 addresses.")
  ntpServers?: string[];
}

@doc("Tenant/workload configuration: proxy network and proxy endpoint.")
@added(Versions.v2026_07_15_preview)
model TenantConfig {
  @doc("Tenant proxy network definition. Typically VLAN 50, VRF WORKLOAD-MGMT.")
  network?: TenantNetworkDefinition;

  @doc("Tenant proxy endpoint configuration. Consumed by CSN as upstream proxy peer.")
  proxyConfig?: TenantProxyConfig;
}

// --- Patch variants (all fields optional for PATCH operations) ---

@doc("Infrastructure network definition for PATCH. All fields optional.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model PatchInfraNetwork {
  @doc("802.1Q VLAN ID.")
  @minValue(1)
  @maxValue(4094)
  vlanId?: int32;

  @doc("IPv4 subnet in CIDR notation.")
  ipv4Subnet?: string;

  @doc("Default gateway IP.")
  ipv4Gateway?: string;

  @doc("Start of allocatable IP range.")
  ipv4StartAddr?: string;

  @doc("End of allocatable IP range.")
  ipv4EndAddr?: string;

  @doc("Maximum Transmission Unit.")
  mtu?: int32;
}

@doc("Infrastructure network definitions for PATCH. No networks required.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model PatchInfrastructureNetworks {
  @doc("OAM management network.")
  management?: PatchInfraNetwork;

  @doc("PXE boot network.")
  pxe?: PatchInfraNetwork;

  @doc("BMC/iDRAC network.")
  bmc?: PatchInfraNetwork;

  @doc("Storage data plane network.")
  storage?: PatchInfraNetwork;

  @doc("Storage management plane network.")
  storageMgmt?: PatchInfraNetwork;

  @doc("PDU management network.")
  pdu?: PatchInfraNetwork;
}

@doc("Platform proxy configuration for PATCH. All fields optional.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model PatchPlatformProxy {
  @doc("HTTP proxy endpoint URL.")
  httpProxy?: string;

  @doc("HTTPS proxy endpoint URL.")
  httpsProxy?: string;

  @doc("CIDRs, hostnames, and domain suffixes that bypass the proxy.")
  noProxy?: string[];
}

@doc("Infrastructure service endpoints for PATCH. All fields optional.")
@added(Versions.v2026_01_15_preview)
@removed(Versions.v2026_07_15_preview)
model PatchInfrastructureServices {
  @doc("Platform proxy configuration.")
  platformProxy?: PatchPlatformProxy;

  @doc("NTP server IPs or hostnames.")
  ntpServers?: string[];

  @doc("DNS server IPs.")
  dnsServers?: string[];
}

@doc("Network definition for PATCH. All fields optional.")
@added(Versions.v2026_07_15_preview)
model PatchNetworkDefinition {
  @doc("Extensible network role identifier.")
  purpose?: NetworkPurpose;

  @doc("Human-readable immutable correlation key.")
  @minLength(1)
  @maxLength(253)
  name?: string;

  @doc("VLAN identifier (1-4094).")
  @minValue(1)
  @maxValue(4094)
  vlanId?: int32;

  @doc("IPv4 subnet in CIDR notation.")
  ipv4Subnet?: string;

  @doc("IPv4 default gateway address.")
  ipv4Gateway?: string;

  @doc("First usable IPv4 address in the pool.")
  ipv4StartAddr?: string;

  @doc("Last usable IPv4 address in the pool.")
  ipv4EndAddr?: string;

  @doc("IPv6 subnet in CIDR notation.")
  ipv6Subnet?: string;

  @doc("IPv6 default gateway address.")
  ipv6Gateway?: string;

  @doc("First usable IPv6 address in the pool.")
  ipv6StartAddr?: string;

  @doc("Last usable IPv6 address in the pool.")
  ipv6EndAddr?: string;

  @doc("IPv4 MTU (68-9216).")
  @minValue(68)
  @maxValue(9216)
  ipv4Mtu?: int32;

  @doc("IPv6 MTU (1280-9216).")
  @minValue(1280)
  @maxValue(9216)
  ipv6Mtu?: int32;

  @doc("Enables DHCP addressing. Valid only for management purpose.")
  useDhcp?: boolean;
}

@doc("Proxy config entry for PATCH. All fields optional.")
@added(Versions.v2026_07_15_preview)
model PatchProxyConfigEntry {
  @doc("Extensible traffic scope identifier.")
  purpose?: ProxyConfigPurpose;

  @doc("HTTP proxy endpoint.")
  httpProxy?: string;

  @doc("HTTPS proxy endpoint.")
  httpsProxy?: string;

  @doc("Destinations that bypass the proxy.")
  noProxy?: string[];
}

@doc("Infrastructure configuration for PATCH. All fields optional.")
@added(Versions.v2026_07_15_preview)
model PatchInfrastructureConfig {
  @doc("Infrastructure networks.")
  @Azure.ResourceManager.identifiers(#["purpose"])
  networks?: PatchNetworkDefinition[];

  @doc("Proxy configurations.")
  @Azure.ResourceManager.identifiers(#["purpose"])
  proxyConfigs?: PatchProxyConfigEntry[];

  @doc("DNS resolver IPv4 addresses.")
  dnsServers?: string[];

  @doc("NTP server IPv4 addresses.")
  ntpServers?: string[];
}

@doc("Tenant network definition for PATCH. All fields optional.")
@added(Versions.v2026_07_15_preview)
model PatchTenantNetworkDefinition {
  @doc("Human-readable immutable correlation key.")
  @minLength(1)
  @maxLength(253)
  name?: string;

  @doc("VLAN identifier (1-4094).")
  @minValue(1)
  @maxValue(4094)
  vlanId?: int32;

  @doc("IPv4 subnet in CIDR notation.")
  ipv4Subnet?: string;

  @doc("IPv4 default gateway address.")
  ipv4Gateway?: string;

  @doc("First usable IPv4 address in the pool.")
  ipv4StartAddr?: string;

  @doc("Last usable IPv4 address in the pool.")
  ipv4EndAddr?: string;

  @doc("IPv6 subnet in CIDR notation.")
  ipv6Subnet?: string;

  @doc("IPv6 default gateway address.")
  ipv6Gateway?: string;

  @doc("First usable IPv6 address in the pool.")
  ipv6StartAddr?: string;

  @doc("Last usable IPv6 address in the pool.")
  ipv6EndAddr?: string;

  @doc("IPv4 MTU (68-9216).")
  @minValue(68)
  @maxValue(9216)
  ipv4Mtu?: int32;

  @doc("IPv6 MTU (1280-9216).")
  @minValue(1280)
  @maxValue(9216)
  ipv6Mtu?: int32;
}

@doc("Tenant proxy config for PATCH. All fields optional.")
@added(Versions.v2026_07_15_preview)
model PatchTenantProxyConfig {
  @doc("HTTP proxy endpoint.")
  httpProxy?: string;

  @doc("HTTPS proxy endpoint.")
  httpsProxy?: string;

  @doc("Destinations that bypass the proxy.")
  noProxy?: string[];
}

@doc("Tenant configuration for PATCH. All fields optional.")
@added(Versions.v2026_07_15_preview)
model PatchTenantConfig {
  @doc("Tenant proxy network definition.")
  network?: PatchTenantNetworkDefinition;

  @doc("Tenant proxy endpoint configuration.")
  proxyConfig?: PatchTenantProxyConfig;
}

@doc("Fabric patchable properties.")
@added(Versions.v2026_01_15_preview)
model FabricPatchableProperties {
  @doc("Infrastructure network definitions.")
  @removed(Versions.v2026_07_15_preview)
  infrastructureNetworks?: PatchInfrastructureNetworks;

  @doc("Infrastructure service endpoints.")
  @removed(Versions.v2026_07_15_preview)
  infrastructureServices?: PatchInfrastructureServices;

  @doc("Operation policy for device interaction.")
  @removed(Versions.v2026_07_15_preview)
  operationPolicy?: OperationPolicy;

  @doc("URL of the SDN controller API endpoint.")
  @removed(Versions.v2026_07_15_preview)
  controllerEndpoint?: string;

  @doc("ARM resource ID of the Key Vault secret for controller credentials.")
  @removed(Versions.v2026_07_15_preview)
  controllerCredentialRef?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.KeyVault/vaults/secrets";
    }
  ]>;

  @doc("Infrastructure configuration.")
  @added(Versions.v2026_07_15_preview)
  infrastructure?: PatchInfrastructureConfig;

  @doc("Tenant/workload configuration.")
  @added(Versions.v2026_07_15_preview)
  tenant?: PatchTenantConfig;
}

@doc("Fabric patch body.")
@added(Versions.v2026_01_15_preview)
model FabricPatch {
  ...TagsUpdate;

  @doc("Resource properties.")
  properties?: FabricPatchableProperties;
}

@doc("FabricProperties defines the resource properties.")
@added(Versions.v2026_01_15_preview)
model FabricProperties {
  @doc("Infrastructure network definitions.")
  @removed(Versions.v2026_07_15_preview)
  infrastructureNetworks?: InfrastructureNetworks;

  @doc("Infrastructure service endpoints.")
  @removed(Versions.v2026_07_15_preview)
  infrastructureServices?: InfrastructureServices;

  @doc("Operation policy for device interaction.")
  @removed(Versions.v2026_07_15_preview)
  operationPolicy?: OperationPolicy;

  @doc("URL of the SDN controller API endpoint.")
  @removed(Versions.v2026_07_15_preview)
  controllerEndpoint?: string;

  @doc("ARM resource ID of the Key Vault secret for controller credentials.")
  @removed(Versions.v2026_07_15_preview)
  controllerCredentialRef?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.KeyVault/vaults/secrets";
    }
  ]>;

  @doc("ARM resource ID of the EdgeConnector.")
  @removed(Versions.v2026_07_15_preview)
  @visibility(Lifecycle.Read, Lifecycle.Create)
  edgeConnectorId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ManagedNetworkFabric/edgeConnectors";
    }
  ]>;

  @doc("Management mode.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  managementMode: ManagementMode;

  @doc("Controller type for device interaction.")
  @removed(Versions.v2026_07_15_preview)
  controllerType?: ControllerType;

  @doc("Number of physical racks.")
  @removed(Versions.v2026_07_15_preview)
  rackCount?: int32;

  @doc("Infrastructure configuration: networks, proxy, DNS, and NTP.")
  @added(Versions.v2026_07_15_preview)
  infrastructure?: InfrastructureConfig;

  @doc("Tenant/workload configuration: proxy network and proxy endpoint.")
  @added(Versions.v2026_07_15_preview)
  tenant?: TenantConfig;

  @doc("Predefined topology identifier.")
  fabricSku?: string;

  @doc("ARM ID of the customer's Azure VNet.")
  @removed(Versions.v2026_07_15_preview)
  customerVnetId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Network/virtualNetworks";
    }
  ]>;

  @doc("ARM ID of the customer's subnet.")
  @removed(Versions.v2026_07_15_preview)
  customerSubnetId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Network/virtualNetworks/subnets";
    }
  ]>;

  @doc("Provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}
