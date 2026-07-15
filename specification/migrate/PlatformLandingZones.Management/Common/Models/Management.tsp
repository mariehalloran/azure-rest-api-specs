import "../Enums/Enums.tsp";

namespace Microsoft.Migrate;

@doc("Log Analytics workspace configuration produced by the stock management template.")
model LogAnalyticsConfig {
  @doc("Log Analytics workspace name.")
  workspaceName?: string;

  @doc("Log Analytics workspace stock keeping unit.")
  sku?: LogAnalyticsSku;

  @doc("Workspace data retention in days.")
  @minValue(30)
  @maxValue(730)
  retentionInDays?: int32;
}

@doc("Azure Monitor configuration produced by the stock management template.")
model AzureMonitorConfig {
  @doc("Whether VM Insights is enabled.")
  vmInsightsEnabled?: boolean;

  @doc("Whether Container Insights is enabled.")
  containerInsightsEnabled?: boolean;
}

@doc("Microsoft Sentinel state produced by the stock management template.")
model SentinelConfig {
  @doc("Whether Microsoft Sentinel is enabled.")
  enabled?: boolean;
}

@doc("Management configuration produced by the stock accelerator template.")
model Management {
  @doc("Log Analytics workspace configuration.")
  logAnalytics?: LogAnalyticsConfig;

  @doc("Azure Monitor configuration.")
  azureMonitor?: AzureMonitorConfig;

  @doc("Microsoft Sentinel configuration.")
  sentinel?: SentinelConfig;
}
