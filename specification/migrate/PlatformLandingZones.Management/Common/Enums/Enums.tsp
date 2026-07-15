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

@doc("Azure Firewall stock keeping unit selected by the stock accelerator templates.")
union AzureFirewallSku {
  string,

  @doc("Premium stock keeping unit.")
  Premium: "Premium",
}

@doc("Threat intelligence mode selected by the stock accelerator templates.")
union ThreatIntelMode {
  string,

  @doc("Alert on threat-intelligence matches.")
  Alert: "Alert",
}

@doc("Intrusion detection and prevention system mode selected by the stock accelerator templates.")
union IdpsMode {
  string,

  @doc("Intrusion detection and prevention system (IDPS) is disabled.")
  Off: "Off",
}

@doc("Private DNS zone deployment mode selected by the stock accelerator templates.")
union PrivateDnsZoneMode {
  string,

  @doc("Deploy Azure Private Link private DNS zones and an auto-registration private DNS zone.")
  PrivateLinkAndAutoRegistration: "PrivateLinkAndAutoRegistration",
}

@doc("Regional connectivity resources deployed by the stock accelerator templates.")
union RegionalConnectivityDeploymentMode {
  string,

  @doc("Do not deploy regional connectivity resources.")
  None: "None",

  @doc("Deploy only the connectivity hub.")
  Hub: "Hub",

  @doc("Deploy only the sidecar virtual network.")
  Sidecar: "Sidecar",

  @doc("Deploy both the connectivity hub and the sidecar virtual network.")
  HubAndSidecar: "HubAndSidecar",
}

@doc("Network virtual appliance vendor value used when the stock generic network virtual appliance template is selected.")
union NvaVendor {
  string,

  @doc("Vendor is not specialized by the stock template.")
  Other: "Other",
}

@doc("Bastion stock keeping unit selected by the stock accelerator templates.")
union BastionSku {
  string,

  @doc("Standard stock keeping unit.")
  Standard: "Standard",
}

@doc("Distributed denial-of-service protection plan selected by the stock accelerator templates.")
union DdosProtectionPlan {
  string,

  @doc("Network protection plan.")
  Network: "Network",
}

@doc("Virtual private network gateway stock keeping unit selected by the stock hub-and-spoke template.")
union VpnGatewaySku {
  string,

  @doc("Availability-zone-aware VpnGw1.")
  VpnGw1AZ: "VpnGw1AZ",
}

@doc("ExpressRoute gateway stock keeping unit selected for this preview.")
union ExpressRouteGatewaySku {
  string,

  @doc("Availability-zone-aware ErGw1.")
  ErGw1AZ: "ErGw1AZ",
}

@doc("Log Analytics workspace stock keeping unit selected by the stock management template.")
union LogAnalyticsSku {
  string,

  @doc("Pay-as-you-go ingestion pricing.")
  PerGB2018: "PerGB2018",
}

@doc("Policy assignment baseline selected by the stock Azure Landing Zones template.")
union PolicyAssignmentMode {
  string,

  @doc("Apply the canonical Azure Landing Zone policy baseline.")
  AlzDefaults: "AlzDefaults",
}

@doc("Azure Landing Zones management-group scope at which a policy assignment override applies.")
union AlzManagementGroupScope {
  string,

  @doc("Intermediate root management group.")
  IntermediateRoot: "IntermediateRoot",

  @doc("Platform management group.")
  Platform: "Platform",

  @doc("Security management group.")
  Security: "Security",

  @doc("Management management group.")
  Management: "Management",

  @doc("Connectivity management group.")
  Connectivity: "Connectivity",

  @doc("Identity management group.")
  Identity: "Identity",

  @doc("Landing zones management group.")
  LandingZones: "LandingZones",

  @doc("Corp management group.")
  Corp: "Corp",

  @doc("Online management group.")
  Online: "Online",

  @doc("Local management group.")
  Local: "Local",

  @doc("Sandbox management group.")
  Sandbox: "Sandbox",

  @doc("Decommissioned management group.")
  Decommissioned: "Decommissioned",
}

@doc("Enforcement mode applied to an Azure Policy assignment.")
union PolicyEnforcementMode {
  string,

  @doc("Enforce the policy assignment.")
  Default: "Default",

  @doc("Evaluate compliance without enforcing the policy assignment.")
  DoNotEnforce: "DoNotEnforce",
}

@doc("Effect applied by an Azure Policy assignment override.")
union PolicyEffect {
  string,

  @doc("Audit noncompliant resources.")
  Audit: "Audit",

  @doc("Deny noncompliant resource changes.")
  Deny: "Deny",

  @doc("Disable policy evaluation.")
  Disabled: "Disabled",

  @doc("Deploy a resource when it does not exist.")
  DeployIfNotExists: "DeployIfNotExists",

  @doc("Modify a resource.")
  Modify: "Modify",

  @doc("Append properties to a resource.")
  Append: "Append",

  @doc("Audit when a related resource does not exist.")
  AuditIfNotExists: "AuditIfNotExists",
}

@doc("Version control system used by the accelerator bootstrap template.")
union VersionControlSystem {
  string,
  @doc("Azure DevOps.")
  AzureDevOps: "AzureDevOps",
  @doc("GitHub source control.")
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
