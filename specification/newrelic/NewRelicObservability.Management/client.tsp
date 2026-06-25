import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;

@@override(NewRelic.Observability.NewRelicMonitorResources.delete,
  reorderParameters(
    NewRelic.Observability.NewRelicMonitorResources.delete,
    #[
      "apiVersion",
      "subscriptionId",
      "resourceGroupName",
      "provider",
      "userEmail",
      "monitorName"
    ]
  ),
  "go"
);

@@clientName(NewRelic.Observability,
  "NewRelicObservabilityMgmtClient",
  "python"
);

@@clientName(NewRelic.Observability.NewRelicAccountProperties,
  "AccountPropertiesForNewRelic",
  "go"
);

@@clientName(NewRelic.Observability.MonitoredSubscriptions.createOrUpdate,
  "createorUpdate",
  "go"
);
