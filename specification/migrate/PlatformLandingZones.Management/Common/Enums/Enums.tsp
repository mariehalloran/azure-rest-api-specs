namespace Microsoft.Migrate;

@doc("Role of an Azure region within the landing zone.")
union RegionRole {
  string,

  @doc("Primary region.")
  Primary: "Primary",

  @doc("Secondary region.")
  Secondary: "Secondary",
}

@doc("Connectivity topology for the platform landing zone.")
union ConnectivityTopology {
  string,

  @doc("Hub-and-spoke virtual network topology.")
  HubAndSpoke: "HubAndSpoke",

  @doc("Azure Virtual WAN topology.")
  VirtualWan: "VirtualWan",
}

@doc("Internet egress model for the platform landing zone.")
union InternetEgressModel {
  string,

  @doc("Spoke egress flows through the hub.")
  ViaHub: "ViaHub",
}

@doc("Deployment scale for the platform landing zone.")
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

@doc("Firewall implementation used by the platform landing zone.")
union FirewallKind {
  string,

  @doc("Azure Firewall.")
  AzureFirewall: "AzureFirewall",

  @doc("Third-party network virtual appliance.")
  ThirdPartyNva: "ThirdPartyNva",
}

@doc("Azure Firewall stock keeping unit.")
union AzureFirewallSku {
  string,

  @doc("Premium stock keeping unit.")
  Premium: "Premium",
}

@doc("Azure Firewall threat intelligence mode.")
union ThreatIntelMode {
  string,

  @doc("Alert on threat-intelligence matches.")
  Alert: "Alert",
}

@doc("Azure Firewall intrusion detection and prevention system mode.")
union IdpsMode {
  string,

  @doc("Intrusion detection and prevention system (IDPS) is disabled.")
  Off: "Off",
}

@doc("Private domain name system zone deployment mode.")
union PrivateDnsZoneMode {
  string,

  @doc("Deploy Azure Private Link private DNS zones and an auto-registration private DNS zone.")
  PrivateLinkAndAutoRegistration: "PrivateLinkAndAutoRegistration",
}

@doc("Connectivity resources deployed in an Azure region.")
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

@doc("Network virtual appliance vendor.")
union NvaVendor {
  string,

  @doc("The network virtual appliance vendor is not specified.")
  Other: "Other",
}

@doc("Azure Bastion stock keeping unit.")
union BastionSku {
  string,

  @doc("Standard stock keeping unit.")
  Standard: "Standard",
}

@doc("Distributed denial-of-service protection plan.")
union DdosProtectionPlan {
  string,

  @doc("Network protection plan.")
  Network: "Network",
}

@doc("Virtual private network gateway stock keeping unit for hub-and-spoke connectivity.")
union VpnGatewaySku {
  string,

  @doc("Availability-zone-aware VpnGw1.")
  VpnGw1AZ: "VpnGw1AZ",
}

@doc("ExpressRoute gateway stock keeping unit.")
union ExpressRouteGatewaySku {
  string,

  @doc("Availability-zone-aware ErGw1.")
  ErGw1AZ: "ErGw1AZ",
}

@doc("Log Analytics workspace stock keeping unit.")
union LogAnalyticsSku {
  string,

  @doc("Pay-as-you-go ingestion pricing.")
  PerGB2018: "PerGB2018",
}

@doc("Policy assignment baseline for the platform landing zone.")
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

@doc("Version control system used to materialize the platform landing zone.")
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
