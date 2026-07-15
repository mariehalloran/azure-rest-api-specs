import "../Enums/Enums.tsp";
import "./NetworkTypes.tsp";

namespace Microsoft.Migrate;

@doc("Hub firewall configuration.")
@discriminator("kind")
model FirewallConfig {
  @doc("Firewall implementation kind.")
  kind: FirewallKind;
}

@doc("Azure Firewall configuration.")
model AzureFirewallConfig extends FirewallConfig {
  @doc("Azure Firewall implementation kind.")
  kind: FirewallKind.AzureFirewall;

  @doc("Azure Firewall stock keeping unit.")
  sku?: AzureFirewallSku;

  @doc("Whether the Azure Firewall domain name system proxy is enabled.")
  dnsProxyEnabled?: boolean;

  @doc("Threat intelligence mode.")
  threatIntelMode?: ThreatIntelMode;

  @doc("Intrusion detection and prevention system mode.")
  idpsMode?: IdpsMode;

  @doc("Azure Firewall subnet address prefix.")
  subnetAddressPrefix?: Ipv4CidrPrefix;

  @doc("Azure regions where Azure Firewall is deployed.")
  deployInRegions?: string[];
}

@doc("Generic third-party network virtual appliance configuration.")
model ThirdPartyNvaFirewallConfig extends FirewallConfig {
  @doc("Third-party network virtual appliance implementation kind.")
  kind: FirewallKind.ThirdPartyNva;

  @doc("Network virtual appliance vendor.")
  vendor?: NvaVendor;

  @doc("Network virtual appliance subnet address prefix.")
  subnetAddressPrefix?: Ipv4CidrPrefix;
}

@doc("Azure Bastion configuration.")
model BastionConfig {
  @doc("Bastion stock keeping unit.")
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

@doc("Azure distributed denial-of-service protection configuration.")
model DdosProtectionConfig {
  @doc("Distributed denial-of-service protection plan.")
  plan?: DdosProtectionPlan;
}

@doc("Private domain name system configuration.")
model PrivateDnsConfig {
  @doc("Private domain name system zone deployment mode.")
  zoneMode?: PrivateDnsZoneMode;

  @doc("Whether centralized domain name system resolution is enabled.")
  centralizedResolutionEnabled?: boolean;

  @doc("Name of the auto-registration private domain name system zone.")
  autoRegistrationZoneName?: string;

  @doc("Domain name system resolver subnet address prefix.")
  resolverSubnetAddressPrefix?: Ipv4CidrPrefix;
}

@doc("Virtual private network gateway configuration.")
@discriminator("topology")
model VpnGatewayConfig {
  @doc("Connectivity topology implemented by the virtual private network gateway.")
  topology: ConnectivityTopology;

  @doc("Azure regions where the virtual private network gateway is deployed.")
  deployInRegions?: string[];
}

@doc("Hub-and-spoke virtual private network gateway configuration.")
model HubAndSpokeVpnGatewayConfig extends VpnGatewayConfig {
  @doc("Hub-and-spoke connectivity topology.")
  topology: ConnectivityTopology.HubAndSpoke;

  @doc("Virtual private network gateway stock keeping unit.")
  sku?: VpnGatewaySku;

  @doc("Whether the virtual private network gateway is active-active.")
  activeActive?: boolean;

  @doc("Whether Border Gateway Protocol is enabled.")
  enableBgp?: boolean;
}

@doc("Azure Virtual WAN virtual private network gateway configuration.")
model VirtualWanVpnGatewayConfig extends VpnGatewayConfig {
  @doc("Azure Virtual WAN connectivity topology.")
  topology: ConnectivityTopology.VirtualWan;

  @doc("Number of Azure Virtual WAN virtual private network gateway scale units.")
  @minValue(1)
  @maxValue(20)
  scaleUnits?: int32;
}

@doc("ExpressRoute Gateway configuration.")
@discriminator("topology")
model ExpressRouteConfig {
  @doc("Connectivity topology implemented by the ExpressRoute gateway.")
  topology: ConnectivityTopology;

  @doc("Azure regions where the ExpressRoute gateway is deployed.")
  deployInRegions?: string[];
}

@doc("Hub-and-spoke ExpressRoute Gateway configuration.")
model HubAndSpokeExpressRouteConfig extends ExpressRouteConfig {
  @doc("Hub-and-spoke connectivity topology.")
  topology: ConnectivityTopology.HubAndSpoke;

  @doc("ExpressRoute gateway stock keeping unit.")
  sku?: ExpressRouteGatewaySku;

  @doc("Whether ExpressRoute FastPath is enabled.")
  fastPathEnabled?: boolean;
}

@doc("Azure Virtual WAN ExpressRoute gateway configuration.")
model VirtualWanExpressRouteConfig extends ExpressRouteConfig {
  @doc("Azure Virtual WAN connectivity topology.")
  topology: ConnectivityTopology.VirtualWan;

  @doc("Number of Azure Virtual WAN ExpressRoute gateway scale units.")
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

  @doc("Distributed denial-of-service protection configuration.")
  ddosProtection?: DdosProtectionConfig;

  @doc("Private domain name system configuration.")
  privateDns?: PrivateDnsConfig;

  @doc("Virtual private network gateway configuration.")
  vpnGateway?: VpnGatewayConfig;

  @doc("ExpressRoute Gateway configuration.")
  expressRoute?: ExpressRouteConfig;

  @doc("Gateway subnet address prefix for hub-and-spoke deployments.")
  gatewaySubnetAddressPrefix?: Ipv4CidrPrefix;
}
