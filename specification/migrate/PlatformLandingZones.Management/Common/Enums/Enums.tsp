namespace Microsoft.Migrate;

@doc("Role of an Azure region within the landing zone.")
union RegionRole {
  string,

  @doc("Primary region.")
  Primary: "Primary",

  @doc("Secondary region.")
  Secondary: "Secondary",
}

@doc("Connectivity topology selected by the stock accelerator template.")
union ConnectivityTopology {
  string,

  @doc("Hub-and-spoke virtual network topology.")
  HubAndSpoke: "HubAndSpoke",

  @doc("Azure Virtual WAN topology.")
  VirtualWan: "VirtualWan",
}

@doc("Egress model used by the stock accelerator templates.")
union InternetEgressModel {
  string,

  @doc("Spoke egress flows through the hub.")
  ViaHub: "ViaHub",
}

@doc("Deployment scale selected by the stock accelerator templates.")
union ScaleTier {
  string,

  @doc("Full platform landing zone.")
  Full: "Full",

  @doc("Management-only landing zone.")
  ManagementOnly: "ManagementOnly",
}

@doc("Subscription model recorded for platform-tier workloads.")
union PlatformSubscriptionModel {
  string,

  @doc("Each platform function uses a dedicated subscription.")
  Dedicated: "Dedicated",

  @doc("Platform functions share one subscription.")
  Shared: "Shared",
}

@doc("Firewall kind selected by the stock accelerator templates.")
union FirewallKind {
  string,

  @doc("Azure Firewall.")
  AzureFirewall: "AzureFirewall",

  @doc("Third-party network virtual appliance.")
  ThirdPartyNva: "ThirdPartyNva",
}

@doc("Azure Firewall SKU selected by the stock accelerator templates.")
union AzureFirewallSku {
  string,

  @doc("Premium SKU.")
  Premium: "Premium",
}

@doc("Threat intelligence mode selected by the stock accelerator templates.")
union ThreatIntelMode {
  string,

  @doc("Alert on threat-intelligence matches.")
  Alert: "Alert",
}

@doc("IDPS mode selected by the stock accelerator templates.")
union IdpsMode {
  string,

  @doc("IDPS is disabled.")
  Off: "Off",
}

@doc("NVA vendor value used when the stock generic NVA template is selected.")
union NvaVendor {
  string,

  @doc("Vendor is not specialized by the stock template.")
  Other: "Other",
}

@doc("Bastion SKU selected by the stock accelerator templates.")
union BastionSku {
  string,

  @doc("Standard SKU.")
  Standard: "Standard",
}

@doc("DDoS protection plan selected by the stock accelerator templates.")
union DdosProtectionPlan {
  string,

  @doc("Network protection plan.")
  Network: "Network",
}

@doc("VPN Gateway SKU selected by the stock hub-and-spoke template.")
union VpnGatewaySku {
  string,

  @doc("Availability-zone-aware VpnGw1.")
  VpnGw1AZ: "VpnGw1AZ",
}

@doc("ExpressRoute Gateway SKU selected for this preview.")
union ExpressRouteGatewaySku {
  string,

  @doc("Availability-zone-aware ErGw1.")
  ErGw1AZ: "ErGw1AZ",
}

@doc("Log Analytics workspace SKU selected by the stock management template.")
union LogAnalyticsSku {
  string,

  @doc("Pay-as-you-go ingestion pricing.")
  PerGB2018: "PerGB2018",
}

@doc("Policy assignment baseline selected by the stock ALZ template.")
union PolicyAssignmentMode {
  string,

  @doc("Apply the canonical Azure Landing Zone policy baseline.")
  AlzDefaults: "AlzDefaults",
}

@doc("Version control system used by the accelerator bootstrap template.")
union VersionControlSystem {
  string,
  @doc("Azure DevOps.")
  AzureDevOps: "AzureDevOps",
  @doc("GitHub.")
  GitHub: "GitHub",
  @doc("Local output without a remote repository.")
  Local: "Local",
}

@doc("Asynchronous landing-zone generation status.")
union PlatformLandingZoneGenerationStatus {
  string,
  @doc("Generation is running.")
  Running: "Running",
  @doc("Generation succeeded.")
  Succeeded: "Succeeded",
  @doc("Generation failed.")
  Failed: "Failed",
}
