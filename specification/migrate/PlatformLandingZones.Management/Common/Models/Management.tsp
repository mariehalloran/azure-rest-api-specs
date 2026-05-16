import "../Enums/Enums.tsp";

namespace Microsoft.Migrate;

@doc("Log Analytics workspace configuration.")
model LogAnalyticsConfig {
  @doc("Workspace name.")
  workspaceName: string;

  @doc("Workspace SKU.")
  sku: LogAnalyticsSku;

  @doc("Retention in days.")
  @minValue(30)
  @maxValue(730)
  retentionInDays: int32;

  @doc("Daily ingestion quota in GB. -1 indicates unlimited; only meaningful with the PerGB2018 SKU.")
  dailyQuotaGb?: float32;

  @doc("Capacity reservation level in GB per day. Required when sku is CapacityReservation.")
  capacityReservationGbPerDay?: int32;
}

@doc("Azure Monitor configuration.")
model AzureMonitorConfig {
  @doc("Whether VM Insights is enabled.")
  vmInsightsEnabled: boolean;

  @doc("Whether Container Insights is enabled.")
  containerInsightsEnabled?: boolean;

  @doc("Whether Application Insights is provisioned in the management subscription.")
  applicationInsightsEnabled?: boolean;
}

@doc("Microsoft Sentinel configuration.")
model SentinelConfig {
  @doc("Whether Microsoft Sentinel is enabled on the management Log Analytics workspace.")
  enabled: boolean;

  @doc("Names of Sentinel data connectors to enable.")
  dataConnectors?: string[];
}

@doc("Azure Automation account configuration.")
model AutomationConfig {
  @doc("Automation account name.")
  accountName: string;

  @doc("Automation account SKU.")
  sku: AutomationSku;
}

@doc("Recovery Services vault configuration. Hoisted to the management block so it can be shared by Backup and Site Recovery.")
model RecoveryServicesVault {
  @doc("Vault name.")
  vaultName: string;

  @doc("Storage redundancy of the vault.")
  redundancy: VaultRedundancy;

  @doc("Whether cross-region restore is enabled. Requires GeoRedundant redundancy.")
  crossRegionRestoreEnabled?: boolean;
}

@doc("Backup configuration.")
model BackupConfig {
  @doc("Whether centralized backup is enabled for the landing zone.")
  enabled: boolean;

  @doc("Soft-delete retention in days for the recovery services vault.")
  @minValue(14)
  @maxValue(180)
  softDeleteRetentionInDays?: int32;
}

@doc("Azure Site Recovery configuration.")
model SiteRecoveryConfig {
  @doc("Whether Site Recovery is enabled for the landing zone.")
  enabled: boolean;
}

@doc("Management plane configuration for the landing zone.")
model Management {
  @doc("Log Analytics workspace configuration.")
  logAnalytics: LogAnalyticsConfig;

  @doc("Azure Monitor configuration.")
  azureMonitor: AzureMonitorConfig;

  @doc("Microsoft Sentinel configuration.")
  sentinel?: SentinelConfig;

  @doc("Azure Automation configuration.")
  automation?: AutomationConfig;

  @doc("Shared Recovery Services vault used by backup and site recovery.")
  recoveryServicesVault?: RecoveryServicesVault;

  @doc("Backup configuration.")
  backup?: BackupConfig;

  @doc("Azure Site Recovery configuration.")
  siteRecovery?: SiteRecoveryConfig;
}
