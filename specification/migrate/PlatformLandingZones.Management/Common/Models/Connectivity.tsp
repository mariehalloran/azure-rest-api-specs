import "../Enums/Enums.tsp";
import "./NetworkTypes.tsp";

namespace Microsoft.Migrate;

@doc("Hub firewall configuration.")
@discriminator("kind")
model FirewallConfig {
  kind: FirewallKind;
}

@doc("Azure Firewall configuration.")
model AzureFirewallConfig extends FirewallConfig {
  kind: FirewallKind.AzureFirewall;
  sku?: AzureFirewallSku;
  dnsProxyEnabled?: boolean;
  threatIntelMode?: ThreatIntelMode;
  idpsMode?: IdpsMode;
  subnetAddressPrefix?: Ipv4CidrPrefix;
  deployInRegions?: string[];
}

@doc("Generic third-party NVA configuration.")
model ThirdPartyNvaFirewallConfig extends FirewallConfig {
  kind: FirewallKind.ThirdPartyNva;
  vendor?: NvaVendor;
  subnetAddressPrefix?: Ipv4CidrPrefix;
}

@doc("Azure Bastion configuration.")
model BastionConfig {
  @doc("Bastion SKU.")
  sku?: BastionSku;

  @doc("Number of Bastion scale units.")
  @minValue(2)
  @maxValue(50)
  scaleUnits?: int32;

  @doc("Bastion subnet address prefix.")
  subnetAddressPrefix?: Ipv4CidrPrefix;

  @doc("Regions where Bastion is deployed.")
  deployInRegions?: string[];
}

@doc("Azure DDoS Protection configuration.")
model DdosProtectionConfig {
  @doc("DDoS protection plan.")
  plan?: DdosProtectionPlan;
}

@doc("Private DNS configuration.")
model PrivateDnsConfig {
  @doc("Whether Azure Private Link private DNS zones are deployed.")
  privateLinkZonesEnabled?: boolean;

  @doc("Whether centralized DNS resolution is enabled.")
  centralizedResolutionEnabled?: boolean;

  @doc("Whether the auto-registration private DNS zone is enabled.")
  autoRegistrationZoneEnabled?: boolean;

  @doc("Name of the auto-registration private DNS zone.")
  autoRegistrationZoneName?: string;

  @doc("DNS resolver subnet address prefix.")
  resolverSubnetAddressPrefix?: Ipv4CidrPrefix;
}

@doc("VPN Gateway configuration.")
@discriminator("topology")
model VpnGatewayConfig {
  topology: ConnectivityTopology;
  deployInRegions?: string[];
}

@doc("Hub-and-spoke VPN Gateway configuration.")
model HubAndSpokeVpnGatewayConfig extends VpnGatewayConfig {
  topology: ConnectivityTopology.HubAndSpoke;
  sku?: VpnGatewaySku;
  activeActive?: boolean;
  enableBgp?: boolean;
}

@doc("Virtual WAN VPN Gateway configuration.")
model VirtualWanVpnGatewayConfig extends VpnGatewayConfig {
  topology: ConnectivityTopology.VirtualWan;

  @minValue(1)
  @maxValue(20)
  scaleUnits?: int32;
}

@doc("ExpressRoute Gateway configuration.")
@discriminator("topology")
model ExpressRouteConfig {
  topology: ConnectivityTopology;
  deployInRegions?: string[];
}

@doc("Hub-and-spoke ExpressRoute Gateway configuration.")
model HubAndSpokeExpressRouteConfig extends ExpressRouteConfig {
  topology: ConnectivityTopology.HubAndSpoke;
  sku?: ExpressRouteGatewaySku;
  fastPathEnabled?: boolean;
}

@doc("Virtual WAN ExpressRoute Gateway configuration.")
model VirtualWanExpressRouteConfig extends ExpressRouteConfig {
  topology: ConnectivityTopology.VirtualWan;

  @minValue(1)
  @maxValue(20)
  scaleUnits?: int32;
}

@doc("Network connectivity configuration for a full landing zone.")
model Connectivity {
  @doc("Connectivity topology.")
  topology: ConnectivityTopology;

  @doc("Internet egress model.")
  internetEgress?: InternetEgressModel;

  @doc("Hub firewall configuration.")
  firewall?: FirewallConfig;

  @doc("Azure Bastion configuration.")
  bastion?: BastionConfig;

  @doc("DDoS protection configuration.")
  ddosProtection?: DdosProtectionConfig;

  @doc("Private DNS configuration.")
  privateDns?: PrivateDnsConfig;

  @doc("VPN Gateway configuration.")
  vpnGateway?: VpnGatewayConfig;

  @doc("ExpressRoute Gateway configuration.")
  expressRoute?: ExpressRouteConfig;

  @doc("Gateway subnet address prefix for hub-and-spoke deployments.")
  gatewaySubnetAddressPrefix?: Ipv4CidrPrefix;
}
