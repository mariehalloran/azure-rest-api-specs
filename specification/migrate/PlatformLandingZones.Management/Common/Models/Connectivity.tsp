import "../Enums/Enums.tsp";

namespace Microsoft.Migrate;

@doc("Hub firewall configuration. The deployed firewall is selected by the discriminator \"kind\".")
@discriminator("kind")
model FirewallConfig {
  @doc("Firewall kind.")
  kind: FirewallKind;
}

@doc("Azure Firewall configuration.")
model AzureFirewallConfig extends FirewallConfig {
  @doc("Discriminator value.")
  kind: FirewallKind.AzureFirewall;

  @doc("Azure Firewall SKU.")
  sku: AzureFirewallSku;

  @doc("Whether DNS Proxy is enabled on the firewall.")
  dnsProxyEnabled?: boolean;

  @doc("Whether TLS inspection is enabled. Requires the Premium SKU.")
  tlsInspectionEnabled?: boolean;

  @doc("Threat intelligence mode used by the firewall.")
  threatIntelMode?: ThreatIntelMode;

  @doc("Intrusion Detection and Prevention System mode. Requires the Premium SKU.")
  idpsMode?: IdpsMode;

  @doc("Subnet CIDR (AzureFirewallSubnet) allocated to Azure Firewall in the hub.")
  subnetAddressPrefix?: string;

  @doc("Names of regions in which the firewall is deployed. When omitted, the firewall is deployed in every region declared on the landing zone.")
  deployInRegions?: string[];
}

@doc("Third-party Network Virtual Appliance configuration. The PLZ resource records the design intent; deployment of the NVA itself is the customer's responsibility.")
model ThirdPartyNvaFirewallConfig extends FirewallConfig {
  @doc("Discriminator value.")
  kind: FirewallKind.ThirdPartyNva;

  @doc("Third-party NVA vendor recorded in the design.")
  vendor: NvaVendor;

  @doc("Subnet CIDR allocated to the NVA in the hub.")
  subnetAddressPrefix: string;
}

@doc("No platform-managed firewall.")
model NoFirewallConfig extends FirewallConfig {
  @doc("Discriminator value.")
  kind: FirewallKind.None;
}

@doc("Azure Bastion configuration.")
model BastionConfig {
  @doc("Bastion SKU.")
  sku: BastionSku;

  @doc("Number of scale units. Only valid when sku is Standard or Premium; ignored for Basic.")
  @minValue(2)
  @maxValue(50)
  scaleUnits?: int32;

  @doc("Subnet CIDR (AzureBastionSubnet) allocated to Azure Bastion in the hub.")
  subnetAddressPrefix?: string;

  @doc("Names of regions in which Bastion is deployed. When omitted, Bastion is deployed in every region declared on the landing zone.")
  deployInRegions?: string[];
}

@doc("Azure DDoS Protection configuration.")
model DdosProtectionConfig {
  @doc("DDoS protection plan tier.")
  plan: DdosProtectionPlan;
}

@doc("Private DNS configuration.")
model PrivateDnsConfig {
  @doc("Whether Azure Private DNS zones for Private Link are deployed in the connectivity subscription.")
  privateLinkZonesEnabled: boolean;

  @doc("Additional custom Private DNS zones to deploy, e.g. [\"contoso.internal\"].")
  customZones?: string[];

  @doc("Whether centralized Private DNS resolution via the connectivity subscription is enabled. When true, spoke VNets resolve Private Link records through the hub.")
  centralizedResolutionEnabled?: boolean;

  @doc("Whether a Private DNS zone is auto-registered (records for VMs in linked VNets are created automatically).")
  autoRegistrationZoneEnabled?: boolean;

  @doc("Name of the Private DNS zone used for auto-registration, e.g. 'contoso.internal'.")
  autoRegistrationZoneName?: string;

  @doc("Subnet CIDR allocated to the Private DNS Resolver inbound endpoint.")
  resolverInboundSubnetAddressPrefix?: string;

  @doc("Subnet CIDR allocated to the Private DNS Resolver outbound endpoint.")
  resolverOutboundSubnetAddressPrefix?: string;
}

@doc("VPN Gateway configuration. Available shapes are selected by the topology discriminator and gated by Connectivity.topology.")
@discriminator("topology")
model VpnGatewayConfig {
  @doc("Topology this VPN configuration applies to.")
  topology: ConnectivityTopology;

  @doc("Names of regions in which a VPN Gateway is deployed. When omitted, a VPN Gateway is deployed in every region declared on the landing zone.")
  deployInRegions?: string[];
}

@doc("VPN Gateway configuration for hub-and-spoke topology (deploys an Azure VPN Gateway in the hub).")
model HubAndSpokeVpnGatewayConfig extends VpnGatewayConfig {
  @doc("Discriminator value.")
  topology: ConnectivityTopology.HubAndSpoke;

  @doc("VPN Gateway SKU.")
  sku: VpnGatewaySku;

  @doc("VPN Gateway generation.")
  generation: VpnGatewayGeneration;

  @doc("Whether the VPN Gateway is active-active.")
  activeActive?: boolean;

  @doc("Whether BGP is enabled.")
  enableBgp?: boolean;
}

@doc("VPN Gateway configuration for Virtual WAN topology (deploys a vWAN VPN Gateway in the virtual hub).")
model VirtualWanVpnGatewayConfig extends VpnGatewayConfig {
  @doc("Discriminator value.")
  topology: ConnectivityTopology.VirtualWan;

  @doc("Scale units for the vWAN VPN Gateway.")
  @minValue(1)
  @maxValue(20)
  scaleUnits: int32;
}

@doc("ExpressRoute configuration. Available shapes are selected by the topology discriminator and gated by Connectivity.topology.")
@discriminator("topology")
model ExpressRouteConfig {
  @doc("Topology this ExpressRoute configuration applies to.")
  topology: ConnectivityTopology;

  @doc("Names of regions in which an ExpressRoute Gateway is deployed. When omitted, an ExpressRoute Gateway is deployed in every region declared on the landing zone.")
  deployInRegions?: string[];
}

@doc("ExpressRoute Gateway configuration for hub-and-spoke topology.")
model HubAndSpokeExpressRouteConfig extends ExpressRouteConfig {
  @doc("Discriminator value.")
  topology: ConnectivityTopology.HubAndSpoke;

  @doc("ExpressRoute Gateway SKU.")
  sku: ExpressRouteGatewaySku;

  @doc("Whether FastPath is enabled. Requires the UltraPerformance SKU or higher.")
  fastPathEnabled?: boolean;
}

@doc("ExpressRoute configuration for Virtual WAN topology.")
model VirtualWanExpressRouteConfig extends ExpressRouteConfig {
  @doc("Discriminator value.")
  topology: ConnectivityTopology.VirtualWan;

  @doc("Scale units for the vWAN ExpressRoute Gateway.")
  @minValue(1)
  @maxValue(20)
  scaleUnits: int32;
}

@doc("Network connectivity configuration for the landing zone.")
model Connectivity {
  @doc("Connectivity topology. When ManagementOnly is selected, per-service sub-blocks (firewall, bastion, ddosProtection, privateDns, vpnGateway, expressRoute) should be omitted.")
  topology: ConnectivityTopology;

  @doc("Internet egress model for spoke traffic.")
  internetEgress: InternetEgressModel;

  @doc("Hub firewall configuration.")
  firewall?: FirewallConfig;

  @doc("Azure Bastion configuration.")
  bastion?: BastionConfig;

  @doc("Azure DDoS Protection configuration.")
  ddosProtection?: DdosProtectionConfig;

  @doc("Private DNS configuration.")
  privateDns?: PrivateDnsConfig;

  @doc("VPN Gateway configuration. Discriminator value must equal Connectivity.topology.")
  vpnGateway?: VpnGatewayConfig;

  @doc("ExpressRoute configuration. Discriminator value must equal Connectivity.topology.")
  expressRoute?: ExpressRouteConfig;

  @doc("Subnet CIDR (GatewaySubnet) allocated to VPN and ExpressRoute gateways in the hub. Hoisted here because the GatewaySubnet is shared by both gateway types.")
  gatewaySubnetAddressPrefix?: string;
}
