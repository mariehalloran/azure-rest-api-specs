using Azure.ResourceManager;
using TypeSpec.Versioning;

namespace Microsoft.Migrate;

@removed(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Assessment Status.")
union AssessmentStatus {
  @doc("Assessment is Created.")
  Created: "Created",

  @doc("Assessment is Updated.")
  Updated: "Updated",

  @doc("Assessment is currently running.")
  Running: "Running",

  @doc("Assessment is Completed or Ready.")
  Completed: "Completed",

  @doc("Assessment is Failed i.e. it is now invalid.")
  Invalid: "Invalid",

  @doc("Assessment is Out of Sync.")
  OutOfSync: "OutOfSync",

  @doc("Assessment is Out Dated.")
  OutDated: "OutDated",

  @doc("Assessment is Deleted.")
  Deleted: "Deleted",

  @doc("Assessment has Failed.")
  Failed: "Failed",

  string,
}

@removed(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Assessment Sizing Criteria.")
union AssessmentSizingCriterion {
  @doc("Performance Data based Sizing.")
  PerformanceBased: "PerformanceBased",

  @doc("As On Premises or Static Data based Sizing.")
  AsOnPremises: "AsOnPremises",

  string,
}

@removed(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Cloud Suitability for Azure.")
union CloudSuitability {
  @doc("Unknown. Indicates missing data.")
  Unknown: "Unknown",

  @doc("Not Suitable for Azure.")
  NotSuitable: "NotSuitable",

  @doc("Suitable for Azure.")
  Suitable: "Suitable",

  @doc("Conditionally Suitable for Azure.")
  ConditionallySuitable: "ConditionallySuitable",

  @doc("Unknown Readiness for Azure.")
  ReadinessUnknown: "ReadinessUnknown",

  string,
}

@doc("The status of the current operation.")
union ProvisioningState {
  @doc("Resource provisioning Successful.")
  Succeeded: "Succeeded",

  @doc("Resource provisioning Failed.")
  Failed: "Failed",

  @doc("Resource provisioning Canceled.")
  Canceled: "Canceled",

  @doc("Resource is being Provisioned.")
  Provisioning: "Provisioning",

  @doc("Resource is being Updated.")
  Updating: "Updating",

  @doc("Resource is being Deleted.")
  Deleting: "Deleting",

  @doc("Resource is being Accepted.")
  Accepted: "Accepted",

  string,
}

@removed(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Premium Disk Support")
union PremiumDiskSupport {
  @doc("Premium Disk Supported")
  PremiumDiskSupported: "PremiumDiskSupported",

  @doc("Premium Disk Not Supported")
  PremiumDiskNotSupported: "PremiumDiskNotSupported",

  string,
}

@removed(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Web Server Type.")
union WebServerType {
  @doc("Unknown. Indicates Missing Data.")
  Unknown: "Unknown",

  @doc("ASP.NET Web App.")
  IIS: "IIS",

  @doc("Java Web App.")
  Tomcat: "Tomcat",

  string,
}

@removed(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Web App Type.")
union WebAppType {
  @doc("Unknown. Indicates Missing Data.")
  Unknown: "Unknown",

  @doc("ASP.NET Web App.")
  ASPNET: "ASP.Net",

  @doc("Java Web App.")
  Java: "Java",

  string,
}

@removed(BusinessCaseApiVersions.v2025_09_09_preview)
@doc("Wep App Tier.")
union AzureWebAppTier {
  @doc("Unknown. Indicates Missing Data.")
  Unknown: "Unknown",

  @doc("Free Tier.")
  Free: "Free",

  @doc("Shared Tier.")
  Shared: "Shared",

  @doc("Basic Tier.")
  Basic: "Basic",

  @doc("Standard Tier.")
  Standard: "Standard",

  @doc("Premium Tier.")
  Premium: "Premium",

  @doc("PremiumV2 Tier.")
  PremiumV2: "PremiumV2",

  @doc("Isolated Tier.")
  Isolated: "Isolated",

  string,
}

@doc("The licensing program.")
@removed(BusinessCaseApiVersions.v2026_06_06_preview)
union LicensingProgram {
  @doc("Retail/Pay as you go.")
  Retail: "Retail",

  @doc("Not known")
  Unknown: "Unknown",

  @doc("Enterprise agreement.")
  EA: "EA",

  @doc("Microsoft customer agreement.")
  MCA: "MCA",

  string,
}
