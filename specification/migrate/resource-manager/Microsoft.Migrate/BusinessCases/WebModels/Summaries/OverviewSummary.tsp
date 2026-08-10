import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-autorest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "../Common/Models.tsp";
import "../Common/Enums.tsp";
import "../../Common/StandardizedContracts/CarbonEmissionsDetails.tsp";
import "../../Common/StandardizedContracts/DataTypes.tsp";

using Autorest;
using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using OpenAPI;

namespace Microsoft.Migrate;

@doc("Overview summary REST resource.")
@parentResource(BusinessCase)
model OverviewSummary is ProxyResource<OverviewSummaryProperties> {
  @doc("Gets the Name of the Overview Summary.")
  @key("overviewSummaryName")
  @segment("overviewSummaries")
  @path
  // "^[^<>&:\\?\/#\x00-\x1F\x7F]{1,260}$"
  @pattern("^[^<>&:\\?/#]{1,260}$")
  name: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "This is a hydrated resource with no PUT call."
@doc("Overview summary properties class.")
model OverviewSummaryProperties {
  @doc("Summary of custom applications migrated to Azure.")
  @visibility(Lifecycle.Read)
  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  applicationSummary: CostSummary;

  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("Summary of commercial off-the-shelf (COTS) applications.")
  @visibility(Lifecycle.Read)
  cotsApplicationSummary: CostSummary;

  @doc("Summary of custom applications migrated to Azure.")
  @visibility(Lifecycle.Read)
  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  customApplicationSummary: CostSummary;

  @doc("Summary of ungrouped workloads migrated to Azure.")
  @visibility(Lifecycle.Read)
  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  independentWorkloadsSummary: CostSummary;

  @doc("Total cost details in azure.")
  @visibility(Lifecycle.Read)
  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  totalAzureCostDetails: TotalCostDetails;

  @doc("Total cost details in on-premises.")
  @visibility(Lifecycle.Read)
  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  totalOnPremCostDetails: TotalCostDetails;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The total Azure cost..")
  @visibility(Lifecycle.Read)
  totalAzureCost?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The total Azure IaaS cost.")
  @visibility(Lifecycle.Read)
  totalAzureIaasCost?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The total Azure PaaS cost.")
  @visibility(Lifecycle.Read)
  totalAzurePaasCost?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The total Avs cost.")
  @visibility(Lifecycle.Read)
  totalAzureAvsCost?: float32;

  @doc("The windows ahub saving.")
  @visibility(Lifecycle.Read)
  windowsAhubSavings?: float32;

  @doc("The linux ahub saving.")
  @visibility(Lifecycle.Read)
  linuxAhubSavings?: float32;

  @doc("The sql ahub saving.")
  @visibility(Lifecycle.Read)
  sqlAhubSavings?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The total on premises cost.")
  @visibility(Lifecycle.Read)
  totalOnPremisesCost?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("ESU Savings 4 Years.")
  @visibility(Lifecycle.Read)
  esuSavingsFor4years?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The management cost saving.")
  @visibility(Lifecycle.Read)
  managementCostSavings?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The security cost saving.")
  @visibility(Lifecycle.Read)
  securityCostSavings?: float32;

  @doc("Shows the year-on-year cost overall.")
  @visibility(Lifecycle.Read)
  yearOnYearEstimates?: YearOnYearEstimates;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("Shows the discovered servers by virtualization platform.")
  @visibility(Lifecycle.Read)
  serversDiscovered?: ServersDiscovered;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The SQL on premises utilization insights.")
  @visibility(Lifecycle.Read)
  utilizationData?: UtilizationData;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("Shows the infrastructure as a service machine OS distribution.")
  @visibility(Lifecycle.Read)
  iaasOsDistribution?: IaasOsDistribution;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("OS Support Status Distribution.")
  @visibility(Lifecycle.Read)
  osSupportStatusDistribution?: SupportStatusDistribution;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("Sql Support Status Distribution.")
  @visibility(Lifecycle.Read)
  sqlSupportStatusDistribution?: SupportStatusDistribution;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("Shows the distribution of platforms.")
  @visibility(Lifecycle.Read)
  paasDistribution?: PaasDistribution;

  @doc("The total Azure arc enabled on-premises cost assuming all on-premises infra is arc enabled.")
  @visibility(Lifecycle.Read)
  azureArcEnabledOnPremisesCost?: float32;

  @doc("The final cost including azure and azure arc enabled on-premises considering the remaining on-prem infra is arc enabled.")
  @visibility(Lifecycle.Read)
  futureCostIncludingAzureArc?: float32;

  @doc("ESU Savings in 4 Years considering the remaining on-prem infra each year is arc enabled.")
  @visibility(Lifecycle.Read)
  futureEsuSavingsFor4YearsIncludingAzureArc?: float32;

  @doc("The management cost saving considering the remaining on-prem infra is arc enabled")
  @visibility(Lifecycle.Read)
  futureManagementCostSavingsIncludingAzureArc?: float32;

  @doc("The security cost saving considering the remaining on-prem infra is arc enabled.")
  @visibility(Lifecycle.Read)
  futureSecurityCostSavingsIncludingAzureArc?: float32;

  @doc("The total cost of services offered by azure arc.")
  @visibility(Lifecycle.Read)
  azureArcServicesCost?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The Iaas component of the future azure cost based on the final migration percentage.")
  @visibility(Lifecycle.Read)
  futureAzureIaasCost?: float32;

  @removed(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The Paas component of the future azure cost based on the final migration percentage.")
  @visibility(Lifecycle.Read)
  futureAzurePaasCost?: float32;

  @doc("The future azure arc cost based on the final migration percentage.")
  @visibility(Lifecycle.Read)
  futureAzureArcEnabledOnPremisesCost?: float32;

  @doc("The total cost of services offered by azure arc based on the final migration percentage.")
  @visibility(Lifecycle.Read)
  futureAzureArcServicesCost?: float32;

  @doc("The total on-premises sustainability estimates.")
  @visibility(Lifecycle.Read)
  totalOnPremisesSustainabilityDetails: CarbonEmissionsDetails;

  @doc("The total azure sustainability estimates.")
  @visibility(Lifecycle.Read)
  totalAzureSustainabilityDetails: CarbonEmissionsDetails;

  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("Future state cost which includes Azure cost and Arc enabled on-premises cost based on the final migration percentage.")
  @visibility(Lifecycle.Read)
  futureCostDetails?: TotalCostDetails;

  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The Azure arc enabled on-premises cost.")
  @visibility(Lifecycle.Read)
  azureArcEnabledOnPremisesCostDetails?: TotalCostDetails;

  @added(BusinessCaseApiVersions.v2025_09_09_preview)
  @doc("The final azure arc enabled on-premises cost based on the final migration percentage.")
  @visibility(Lifecycle.Read)
  futureAzureArcEnabledOnPremisesCostDetails?: TotalCostDetails;

  @added(BusinessCaseApiVersions.v2026_06_06_preview)
  @doc("Azure value uplift benefits, aggregated across the heterogeneous assessment that contributes to this business case. Absent when the contributing assessment reported no value benefits.")
  @visibility(Lifecycle.Read)
  valueBenefit?: ValueBenefitDetails;

  @added(BusinessCaseApiVersions.v2026_06_06_preview)
  @doc("Infrastructure cost savings and the value benefit combined into the total economic benefit of the migration. Absent when no value benefit was reported, since the total would then restate the cost savings.")
  @visibility(Lifecycle.Read)
  totalEconomicBenefit?: TotalEconomicBenefitDetails;
}

@doc("""
  The complete economic picture of the migration: what is saved on infrastructure, plus what Azure
  delivers beyond price.
  
  Carries the totals only. The pillar and line-item breakdown behind the value benefit is the
  sibling `valueBenefit`, so it is not repeated here.
  
  The total is returned rather than left for the caller to add up, so that the portal, the export
  and any downstream report agree on the figure instead of each rounding the parts independently.
  """)
@added(BusinessCaseApiVersions.v2026_06_06_preview)
model TotalEconomicBenefitDetails {
  @doc("""
    Annual infrastructure cost savings, the on-premises cost less the future-state cost.
    
    Measured against the future-state cost rather than the Azure cost, so that any on-premises
    footprint the customer keeps running is charged against the saving instead of being ignored.
    """)
  @visibility(Lifecycle.Read)
  costSavingsAnnual: float64;

  @doc("Annual risk-adjusted value benefit. Restates the aggregate of the sibling value benefit so this object can be read on its own.")
  @visibility(Lifecycle.Read)
  valueBenefitAnnualRiskAdjusted: float64;

  @doc("""
    Annual total economic benefit, the sum of the cost savings and the risk-adjusted value benefit.
    
    Reported annually rather than as a net present value. The two halves are discounted differently
    today — the value benefit arrives already discounted from the contributing assessment, while
    cost savings ramp with the migration completion percentage — so a combined net present value
    would be the sum of two methods and would overstate the benefit of a phased migration.
    """)
  @visibility(Lifecycle.Read)
  totalEconomicBenefitAnnual: float64;

  @doc("Total economic benefit expressed as a fraction of the current annual on-premises spend.")
  @visibility(Lifecycle.Read)
  percentOfOnPremisesCost?: float64;
}

@doc("Azure value uplift benefits for a set of workloads, broken down by pillar.")
@added(BusinessCaseApiVersions.v2026_06_06_preview)
model ValueBenefitDetails {
  @doc("Total annual value benefit after risk adjustment, expressed in the business case currency.")
  @visibility(Lifecycle.Read)
  totalAnnualRiskAdjusted: float64;

  @doc("Net present value of the risk-adjusted value benefit over the finance horizon.")
  @visibility(Lifecycle.Read)
  valueBenefitNpv: float64;

  @doc("Breakdown of the value benefit by pillar.")
  @visibility(Lifecycle.Read)
  @identifiers(#["pillar"])
  pillars: ValueBenefitPillar[];
}

@doc("Value benefit contributed by a single pillar.")
@added(BusinessCaseApiVersions.v2026_06_06_preview)
model ValueBenefitPillar {
  @doc("The pillar this benefit is attributed to.")
  @visibility(Lifecycle.Read)
  pillar: ValueBenefitPillarType;

  @doc("Total annual value benefit for the pillar before risk adjustment.")
  @visibility(Lifecycle.Read)
  totalAnnual: float64;

  @doc("Total annual value benefit for the pillar after risk adjustment.")
  @visibility(Lifecycle.Read)
  riskAdjustedAnnual: float64;

  @doc("Net present value of the pillar's risk-adjusted benefit over the finance horizon.")
  @visibility(Lifecycle.Read)
  npv: float64;

  @doc("Individual contributions that make up the pillar's benefit.")
  @visibility(Lifecycle.Read)
  @identifiers(#["name"])
  lineItems: ValueBenefitLineItem[];
}

@doc("A single named contribution to a value benefit pillar.")
@added(BusinessCaseApiVersions.v2026_06_06_preview)
model ValueBenefitLineItem {
  @doc("Name of the contribution.")
  @visibility(Lifecycle.Read)
  name: string;

  @doc("Value of the contribution, expressed in the business case currency.")
  @visibility(Lifecycle.Read)
  value: float64;
}

@doc("Represents the value uplift pillar a benefit belongs to.")
@added(BusinessCaseApiVersions.v2026_06_06_preview)
union ValueBenefitPillarType {
  @doc("Unknown or uninitialized pillar.")
  Unknown: "Unknown",

  @doc("Productivity pillar, covering administrator, developer and operations efficiency gains.")
  Productivity: "Productivity",

  @doc("Resiliency pillar, covering avoided downtime and reduced incidents.")
  Resiliency: "Resiliency",

  @doc("Business agility pillar, covering the value of earlier delivery.")
  BusinessAgility: "BusinessAgility",

  string,
}

@doc("Shows the discovered servers by virtualization platform.")
@removed(BusinessCaseApiVersions.v2025_09_09_preview)
model ServersDiscovered {
  @doc("Number of servers on VMWare.")
  @visibility(Lifecycle.Read)
  vmWare?: int32;

  @doc("Number of servers on HyperV.")
  @visibility(Lifecycle.Read)
  hyperV?: int32;

  @doc("Number of physical servers.")
  @visibility(Lifecycle.Read)
  physical?: int32;

  @doc("Number of servers whose virtualization is unknown.")
  @visibility(Lifecycle.Read)
  notApplicable?: int32;
}

@doc("Shows the infrastructure as a service machine OS distribution.")
@removed(BusinessCaseApiVersions.v2025_09_09_preview)
model IaasOsDistribution {
  @doc("Number of Windows servers.")
  @visibility(Lifecycle.Read)
  windows?: int32;

  @doc("Number of Linux servers.")
  @visibility(Lifecycle.Read)
  linux?: int32;

  @doc("Number of servers neither Windows or Linux.")
  @visibility(Lifecycle.Read)
  other?: int32;
}

@doc("Shows the distribution of platforms.")
@removed(BusinessCaseApiVersions.v2025_09_09_preview)
model PaasDistribution {
  @doc("Number of SQL Server machines.")
  @visibility(Lifecycle.Read)
  sqlServers?: int32;

  @doc("Number of IIS Web servers.")
  @visibility(Lifecycle.Read)
  iisWebServers?: int32;

  @doc("Distribution of webapps for each target type.")
  @visibility(Lifecycle.Read)
  @identifiers(#[])
  webAppDistribution?: NameValuePair<string, int32>[];
}

@added(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Summary of migration strategy, including count and cost details.")
@removed(BusinessCaseApiVersions.v2026_06_06_preview)
model StrategySummary {
  @doc("Name of the migration strategy.")
  strategy: string;

  @doc("Number of workloads using this strategy.")
  count: int32;

  @doc("Cost details for workloads using this strategy.")
  costDetails: TotalCostDetails;
}

@added(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Summary of application migration, including readiness, cost, and strategies.")
model CostSummary {
  @doc("Azure cost details for the applications.")
  azureCostDetails: TotalCostDetails;

  @doc("On-premises cost details for the applications.")
  onPremCostDetails: TotalCostDetails;
}

@added(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("The Cost Details have total Cost, other costs segregation")
model TotalCostDetails {
  @doc("License cost details for workloads.")
  @visibility(Lifecycle.Read)
  totalCost: float32;

  @doc("License cost details for workloads.")
  @visibility(Lifecycle.Read)
  licenseCostDetails: float32;

  @doc("The storage cost.")
  @visibility(Lifecycle.Read)
  storageCost?: float32;

  @doc("The compute cost.")
  @visibility(Lifecycle.Read)
  computeCost?: float32;

  @doc("The IT labor cost.")
  @visibility(Lifecycle.Read)
  itLaborCost?: float32;

  @doc("The network cost.")
  @visibility(Lifecycle.Read)
  networkCost?: float32;

  @doc("The windows AhubSavings.")
  @visibility(Lifecycle.Read)
  ahubSavings?: float32;

  @doc("The linux AhubSavings.")
  @visibility(Lifecycle.Read)
  linuxAhubSavings?: float32;

  @doc("Security Cost.")
  @visibility(Lifecycle.Read)
  securityCost?: float32;

  @doc("Management Cost Details.")
  @visibility(Lifecycle.Read)
  managementCostDetails?: float32;

  @doc("esu savings.")
  @visibility(Lifecycle.Read)
  esuSavings?: float32;

  @doc("The facilities cost.")
  @visibility(Lifecycle.Read)
  facilitiesCost?: float32;

  @visibility(Lifecycle.Read)
  @doc("Gets or sets the list of cost line items.")
  @identifiers(#[])
  costLineItems?: CostLineItem[];
}

@doc("Represents a single line item in a cost breakdown.")
@added(BusinessCaseApiVersions.v2025_09_09_preview)
model CostLineItem {
  @doc("Gets or sets the pillar this cost belongs to.")
  pillar: CostPillar;

  @doc("Gets or sets the name of the cost component.")
  name: CostComponentCategory;

  @doc("Gets or sets the value of the cost component.")
  value: float64;

  @doc("Gets or sets the type of cost (Capex or Opex).")
  costType: CostComponentType;
}

@doc("Represents the type of cost component.")
@added(BusinessCaseApiVersions.v2025_09_09_preview)
union CostComponentType {
  @doc("Unknown or uninitialized cost type.")
  Unknown: "Unknown",

  @doc("Capital expenditure (CapEx) cost.")
  CapexCost: "CapexCost",

  @doc("Operational expenditure (OpEx) cost.")
  OpexCost: "OpexCost",

  string,
}

@doc("Represents the category of a cost component.")
@added(BusinessCaseApiVersions.v2025_09_09_preview)
union CostComponentCategory {
  @doc("Unknown or uninitialized category.")
  Unknown: "Unknown",

  @doc("Hardware acquisition cost.")
  HardwareAcquisitionCost: "HardwareAcquisitionCost",

  @doc("Virtualization license cost.")
  VirtualizationLicenseCost: "VirtualizationLicenseCost",

  @doc("Linux license cost.")
  LinuxLicenseCost: "LinuxLicenseCost",

  @doc("SQL license cost.")
  SqlLicenseCost: "SqlLicenseCost",

  @doc("Windows license cost.")
  WindowsLicenseCost: "WindowsLicenseCost",

  @doc("ESU costs.")
  EsuCosts: "EsuCosts",

  @doc("Hardware maintainance cost.")
  HardwareMaintainanceCost: "HardwareMaintainanceCost",

  @doc("Storage acquisition cost.")
  StorageAcquisitionCost: "StorageAcquisitionCost",

  @doc("Storage maintenance cost.")
  StorageMaintenanceCost: "StorageMaintenanceCost",

  @doc("Network acquisition cost.")
  NetworkAcquisitionCost: "NetworkAcquisitionCost",

  @doc("Network maintenance cost.")
  NetworkMaintenanceCost: "NetworkMaintenanceCost",

  @doc("Facilities cost.")
  FacilitiesCost: "FacilitiesCost",

  @doc("Security cost.")
  SecurityCost: "SecurityCost",

  @doc("Labor cost.")
  LaborCost: "LaborCost",

  @doc("Monitoring cost in Azure Arc.")
  AzureArcMonitoringCost: "AzureArcMonitoringCost",

  @doc("Patching cost in Azure Arc.")
  AzureArcPatchingCost: "AzureArcPatchingCost",

  @doc("Data protection cost in Azure.")
  AzureDataProtectionCost: "AzureDataProtectionCost",

  @doc("Management cost.")
  ManagementCost: "ManagementCost",

  @doc("Monitoring service cost.")
  MonitoringServiceCost: "MonitoringServiceCost",

  @doc("Other data protection management cost.")
  OtherDataProtectionManagementCost: "OtherDataProtectionManagementCost",

  @doc("Other monitoring management cost.")
  OtherMonitoringManagementCost: "OtherMonitoringManagementCost",

  @doc("Other patching management cost.")
  OtherPatchingManagementCost: "OtherPatchingManagementCost",

  @doc("Patching service cost.")
  PatchingServiceCost: "PatchingServiceCost",

  @doc("Storage backup cost.")
  StorageBackupCost: "StorageBackupCost",

  @doc("System Center license cost.")
  SystemCenterLicenseCost: "SystemCenterLicenseCost",

  @doc("Third party management cost.")
  ThirdPartyManagementCost: "ThirdPartyManagementCost",

  @doc("VSphere management cost.")
  VSphereManagementCost: "VSphereManagementCost",

  string,
}

@doc("Represents the cost pillar a line item belongs to.")
@added(BusinessCaseApiVersions.v2025_09_09_preview)
union CostPillar {
  @doc("Unknown or uninitialized pillar.")
  Unknown: "Unknown",

  @doc("Compute pillar.")
  Compute: "Compute",

  @doc("Facilities pillar.")
  Facilities: "Facilities",

  @doc("IT labor pillar.")
  ItLabor: "ItLabor",

  @doc("Licensing pillar.")
  Licensing: "Licensing",

  @doc("Management pillar.")
  Management: "Management",

  @doc("Network pillar.")
  Network: "Network",

  @doc("Security pillar.")
  Security: "Security",

  @doc("Storage pillar.")
  Storage: "Storage",

  string,
}
