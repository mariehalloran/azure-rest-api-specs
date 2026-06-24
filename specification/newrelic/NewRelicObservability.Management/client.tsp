import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;

namespace Customizations {
  using NewRelic.Observability;
  using Azure.ResourceManager;
  using TypeSpec.Rest;
  using TypeSpec.Http;

  /**
   * Deletes an existing New Relic monitor resource from your Azure subscription, removing the integration and stopping the observability of your Azure resources through New Relic
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "customization to preserve the released Go SDK parameter order"
  op monitorsDelete(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,
    ...Azure.ResourceManager.Legacy.Provider,

    /**
     * User Email.
     */
    @query("userEmail")
    userEmail: string,

    /**
     * Name of the Monitors resource
     */
    @path
    @segment("monitors")
    monitorName: string,
  ): void;
}

// The swagger converter placed the `userEmail` query parameter after the
// `monitorName` path parameter, which reorders the generated Go SDK method
// signature and is a breaking change versus the released SDK. Override the Go
// client method to restore the original parameter order
// (resourceGroupName, userEmail, monitorName).
@@override(NewRelic.Observability.NewRelicMonitorResources.delete,
  Customizations.monitorsDelete,
  "go"
);

@@clientName(
  NewRelic.Observability,
  "NewRelicObservabilityMgmtClient",
  "python"
);

@@clientName(
  NewRelic.Observability.NewRelicAccountProperties,
  "AccountPropertiesForNewRelic",
  "go"
);

@@clientName(
  NewRelic.Observability.MonitoredSubscriptions.createOrUpdate,
  "createorUpdate",
  "go"
);

