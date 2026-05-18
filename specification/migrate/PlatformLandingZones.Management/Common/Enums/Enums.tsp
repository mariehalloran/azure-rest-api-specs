namespace Microsoft.Migrate;

// =============================================================================
// Region / topology enums
// =============================================================================

@doc("Role of an Azure region within the landing zone.")
union RegionRole {
  string,

  @doc("Primary region. Hosts the authoritative copies of platform services.")
  Primary: "Primary",

  @doc("Secondary region. Used for paired services such as disaster recovery.")
  Secondary: "Secondary",
}

@doc("Top-level connectivity topology that the landing zone deploys against.")
union ConnectivityTopology {
  string,

  @doc("Classic hub-and-spoke topology built on Virtual Network peering.")
  HubAndSpoke: "HubAndSpoke",

  @doc("Azure Virtual WAN based topology.")
  VirtualWan: "VirtualWan",

  @doc("Management-only landing zone with no platform-managed network connectivity. Per-service connectivity sub-blocks are omitted in this mode.")
  ManagementOnly: "ManagementOnly",
}

@doc("Egress model for spoke traffic destined for the internet.")
union InternetEgressModel {
  string,

  @doc("Egress flows through the hub (Azure Firewall or third-party NVA based on FirewallConfig.kind).")
  ViaHub: "ViaHub",

  @doc("Spoke egresses directly to the internet without traversing the hub.")
  DirectFromSpoke: "DirectFromSpoke",
}

// =============================================================================
// Subscription model
// =============================================================================

@doc("Subscription model for platform-tier workloads in the landing zone.")
union PlatformSubscriptionModel {
  string,

  @doc("Each platform function (identity, connectivity, management) uses its own dedicated subscription.")
  Dedicated: "Dedicated",

  @doc("All platform functions share a single platform subscription.")
  Shared: "Shared",
}

// =============================================================================
// Identity enums
// =============================================================================

@doc("Identity provider strategy for the landing zone.")
union IdentityProvider {
  string,

  @doc("Microsoft Entra ID only.")
  EntraIdOnly: "EntraIdOnly",

  @doc("Microsoft Entra ID with Azure AD Domain Services for legacy workloads.")
  EntraIdWithDomainServices: "EntraIdWithDomainServices",

  @doc("Hybrid identity with on-premises Active Directory Domain Services synchronized via Microsoft Entra Connect.")
  HybridAdDs: "HybridAdDs",
}

// =============================================================================
// Connectivity — firewall
// =============================================================================

@doc("Firewall kind deployed at the hub.")
union FirewallKind {
  string,

  @doc("Azure Firewall.")
  AzureFirewall: "AzureFirewall",

  @doc("Third-party Network Virtual Appliance. The PLZ resource captures the design intent; deployment of the NVA itself is the customer's responsibility.")
  ThirdPartyNva: "ThirdPartyNva",

  @doc("No platform-managed firewall.")
  None: "None",
}

@doc("Azure Firewall SKU.")
union AzureFirewallSku {
  string,

  @doc("Basic SKU.")
  Basic: "Basic",

  @doc("Standard SKU.")
  Standard: "Standard",

  @doc("Premium SKU. Required for TLS inspection and IDPS.")
  Premium: "Premium",
}

@doc("Threat intelligence mode for Azure Firewall.")
union ThreatIntelMode {
  string,

  @doc("Threat intelligence is disabled.")
  Off: "Off",

  @doc("Traffic matching threat intelligence is logged as an alert without blocking.")
  Alert: "Alert",

  @doc("Traffic matching threat intelligence is blocked and logged.")
  Deny: "Deny",
}

@doc("Intrusion Detection and Prevention System mode for Azure Firewall Premium.")
union IdpsMode {
  string,

  @doc("IDPS is disabled.")
  Off: "Off",

  @doc("IDPS inspects traffic and logs detections without blocking.")
  Alert: "Alert",

  @doc("IDPS inspects traffic and both alerts on and blocks detected threats.")
  Deny: "Deny",
}

@doc("Third-party Network Virtual Appliance vendor recorded in the design.")
union NvaVendor {
  string,

  @doc("Palo Alto Networks.")
  PaloAlto: "PaloAlto",

  @doc("Check Point.")
  Checkpoint: "Checkpoint",

  @doc("Fortinet.")
  Fortinet: "Fortinet",

  @doc("Cisco.")
  Cisco: "Cisco",

  @doc("Other vendor not in the predefined list.")
  Other: "Other",
}

// =============================================================================
// Connectivity — gateways / bastion / DDoS / DNS
// =============================================================================

@doc("Bastion SKU.")
union BastionSku {
  string,

  @doc("Basic SKU.")
  Basic: "Basic",

  @doc("Standard SKU. Required when scale units are specified.")
  Standard: "Standard",

  @doc("Premium SKU.")
  Premium: "Premium",
}

@doc("DDoS Protection plan tier.")
union DdosProtectionPlan {
  string,

  @doc("Network protection plan.")
  Network: "Network",

  @doc("IP Protection plan.")
  IpProtection: "IpProtection",
}

@doc("VPN Gateway SKU (hub-and-spoke topology).")
union VpnGatewaySku {
  string,

  @doc("VpnGw1.")
  VpnGw1: "VpnGw1",

  @doc("VpnGw2.")
  VpnGw2: "VpnGw2",

  @doc("VpnGw3.")
  VpnGw3: "VpnGw3",

  @doc("VpnGw4.")
  VpnGw4: "VpnGw4",

  @doc("VpnGw5.")
  VpnGw5: "VpnGw5",

  @doc("Availability-zone-aware VpnGw1.")
  VpnGw1AZ: "VpnGw1AZ",

  @doc("Availability-zone-aware VpnGw2.")
  VpnGw2AZ: "VpnGw2AZ",

  @doc("Availability-zone-aware VpnGw3.")
  VpnGw3AZ: "VpnGw3AZ",

  @doc("Availability-zone-aware VpnGw4.")
  VpnGw4AZ: "VpnGw4AZ",

  @doc("Availability-zone-aware VpnGw5.")
  VpnGw5AZ: "VpnGw5AZ",
}

@doc("VPN Gateway generation (hub-and-spoke topology).")
union VpnGatewayGeneration {
  string,

  @doc("Generation 1.")
  Generation1: "Generation1",

  @doc("Generation 2.")
  Generation2: "Generation2",
}

@doc("ExpressRoute gateway SKU (hub-and-spoke topology).")
union ExpressRouteGatewaySku {
  string,

  @doc("Standard SKU.")
  Standard: "Standard",

  @doc("HighPerformance SKU.")
  HighPerformance: "HighPerformance",

  @doc("UltraPerformance SKU. Required for FastPath.")
  UltraPerformance: "UltraPerformance",

  @doc("ErGw1AZ availability-zone-aware SKU.")
  ErGw1AZ: "ErGw1AZ",

  @doc("ErGw2AZ availability-zone-aware SKU.")
  ErGw2AZ: "ErGw2AZ",

  @doc("ErGw3AZ availability-zone-aware SKU.")
  ErGw3AZ: "ErGw3AZ",
}

// =============================================================================
// Management
// =============================================================================

@doc("Log Analytics workspace SKU.")
union LogAnalyticsSku {
  string,

  @doc("Pay-as-you-go (per-GB) ingestion pricing.")
  PerGB2018: "PerGB2018",

  @doc("Capacity reservation pricing.")
  CapacityReservation: "CapacityReservation",
}

@doc("Recovery Services vault redundancy.")
union VaultRedundancy {
  string,

  @doc("Locally redundant storage.")
  LocallyRedundant: "LocallyRedundant",

  @doc("Zone redundant storage.")
  ZoneRedundant: "ZoneRedundant",

  @doc("Geo redundant storage. Required to enable cross-region restore.")
  GeoRedundant: "GeoRedundant",
}

@doc("Automation Account SKU.")
union AutomationSku {
  string,

  @doc("Basic SKU.")
  Basic: "Basic",
}

// =============================================================================
// Security
// =============================================================================

@doc("Microsoft Defender for Cloud plan identifier.")
union DefenderPlanName {
  string,

  @doc("Servers plan.")
  Servers: "Servers",

  @doc("App Service plan.")
  AppServices: "AppServices",

  @doc("Storage plan.")
  Storage: "Storage",

  @doc("SQL plan.")
  Sql: "Sql",

  @doc("Open-source relational database plan.")
  OpenSourceRelationalDatabases: "OpenSourceRelationalDatabases",

  @doc("Cosmos DB plan.")
  CosmosDbs: "CosmosDbs",

  @doc("Key Vault plan.")
  KeyVaults: "KeyVaults",

  @doc("DNS plan.")
  Dns: "Dns",

  @doc("Resource Manager plan.")
  Arm: "Arm",

  @doc("Containers plan.")
  Containers: "Containers",

  @doc("API plan.")
  Api: "Api",

  @doc("Cloud Security Posture Management plan.")
  CloudPosture: "CloudPosture",

  @doc("AI Workload plan.")
  AiServices: "AiServices",
}

@doc("Microsoft Defender for Cloud plan tier.")
union DefenderPlanTier {
  string,

  @doc("Free tier.")
  Free: "Free",

  @doc("Standard tier.")
  Standard: "Standard",

  @doc("Plan tier P1.")
  P1: "P1",

  @doc("Plan tier P2.")
  P2: "P2",
}

@doc("Key Vault kind.")
union KeyVaultKind {
  string,

  @doc("Standard SKU vault.")
  Standard: "Standard",

  @doc("Premium SKU vault. Required for HSM-backed software keys.")
  Premium: "Premium",

  @doc("Managed HSM. A separate Managed HSM resource is provisioned.")
  ManagedHsm: "ManagedHsm",
}

// =============================================================================
// Governance
// =============================================================================

@doc("Policy assignment baseline mode.")
union PolicyAssignmentMode {
  string,

  @doc("Apply the canonical Azure Landing Zone policy initiative as defined by Azure/alz-terraform-accelerator.")
  AlzDefaults: "AlzDefaults",

  @doc("Apply customer-defined policy assignments only.")
  Custom: "Custom",

  @doc("Do not deploy any platform policy assignments.")
  None: "None",
}

@doc("Azure Landing Zone management group scope at which a policy or lock applies.")
union AlzManagementGroupScope {
  string,

  @doc("Intermediate root management group (the ALZ root).")
  IntermediateRoot: "IntermediateRoot",

  @doc("Platform management group.")
  Platform: "Platform",

  @doc("Identity platform management group.")
  Identity: "Identity",

  @doc("Management platform management group.")
  Management: "Management",

  @doc("Connectivity platform management group.")
  Connectivity: "Connectivity",

  @doc("Landing zones management group (parent of Corp and Online).")
  LandingZones: "LandingZones",

  @doc("Corp landing zones management group.")
  Corp: "Corp",

  @doc("Online landing zones management group.")
  Online: "Online",

  @doc("Sandbox management group.")
  Sandbox: "Sandbox",

  @doc("Decommissioned management group.")
  Decommissioned: "Decommissioned",
}

@doc("Azure Policy enforcement mode.")
union PolicyEnforcementMode {
  string,

  @doc("Policies are evaluated and resources in violation are recorded as non-compliant. Effects such as deny are enforced.")
  Default: "Default",

  @doc("Policies are evaluated but effects are not enforced. Useful for testing.")
  DoNotEnforce: "DoNotEnforce",
}

@doc("Azure Policy effect applied when an assignment is evaluated.")
union PolicyEffect {
  string,

  @doc("Block the non-compliant request.")
  Deny: "Deny",

  @doc("Log non-compliance without blocking.")
  Audit: "Audit",

  @doc("Block creation of non-compliant audit log entries.")
  AuditIfNotExists: "AuditIfNotExists",

  @doc("Deploy a remediation when the related resource does not exist.")
  DeployIfNotExists: "DeployIfNotExists",

  @doc("Modify the resource to bring it into compliance.")
  Modify: "Modify",

  @doc("Append fields to the resource to bring it into compliance.")
  Append: "Append",

  @doc("Disable evaluation of the assignment.")
  Disabled: "Disabled",
}

@doc("Azure Resource Manager lock level.")
union ResourceLockLevel {
  string,

  @doc("CanNotDelete: authorized users can read and modify but not delete.")
  CanNotDelete: "CanNotDelete",

  @doc("ReadOnly: authorized users can read only.")
  ReadOnly: "ReadOnly",
}

// =============================================================================
// Cost management
// =============================================================================

@doc("Customer billing account type.")
union BillingAccountType {
  string,

  @doc("Enterprise Agreement.")
  EnterpriseAgreement: "EnterpriseAgreement",

  @doc("Microsoft Customer Agreement.")
  MicrosoftCustomerAgreement: "MicrosoftCustomerAgreement",

  @doc("Microsoft Partner Agreement.")
  MicrosoftPartnerAgreement: "MicrosoftPartnerAgreement",

  @doc("Pay-as-you-go.")
  PayAsYouGo: "PayAsYouGo",

  @doc("Cloud Solution Provider.")
  CloudSolutionProvider: "CloudSolutionProvider",
}

@doc("Reservation purchase strategy.")
union ReservationStrategy {
  string,

  @doc("Do not purchase reservations as part of the landing zone.")
  None: "None",

  @doc("Purchase reservations to cover stable, predictable workloads only.")
  StableWorkloadsOnly: "StableWorkloadsOnly",

  @doc("Aggressive reservation coverage across all workloads.")
  Aggressive: "Aggressive",
}

@doc("Savings plan strategy.")
union SavingsPlanStrategy {
  string,

  @doc("Do not purchase savings plans as part of the landing zone.")
  None: "None",

  @doc("Purchase 1-year savings plans.")
  OneYear: "OneYear",

  @doc("Purchase 3-year savings plans.")
  ThreeYear: "ThreeYear",
}
