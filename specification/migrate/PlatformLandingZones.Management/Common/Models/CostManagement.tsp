import "@azure-tools/typespec-azure-resource-manager";
import "../Enums/Enums.tsp";

using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("Budget configured on the landing zone.")
model PlatformLandingZoneBudget {
  @doc("Budget name.")
  name: string;

  @doc("Monthly budget amount in billing currency.")
  @minValue(0)
  amount: float64;

  @doc("Email addresses notified when budget thresholds are crossed.")
  notificationEmails: string[];

  @doc("Thresholds in percent (0-1000) of the budget amount at which notifications fire.")
  thresholds: int32[];

  @doc("ALZ management-group scope at which the budget applies.")
  scope: AlzManagementGroupScope;
}

@doc("Cost management configuration for the landing zone.")
model CostManagement {
  @doc("ISO-4217 billing currency used for budgets and Bill of Materials cost estimates (e.g., \"USD\", \"EUR\").")
  @pattern("^[A-Z]{3}$")
  currency: string;

  @doc("Billing account type.")
  billingAccountType: BillingAccountType;

  @doc("Reservation purchase strategy.")
  reservations: ReservationStrategy;

  @doc("Savings plan strategy.")
  savingsPlans: SavingsPlanStrategy;

  @doc("Budgets configured on the landing zone.")
  @identifiers(#["name"])
  budgets?: PlatformLandingZoneBudget[];

  @doc("Whether Cost Management anomaly alerts are enabled for the landing zone.")
  costAnomalyAlertsEnabled?: boolean;

  @doc("Whether tag inheritance from subscription to resource is enabled in Cost Management.")
  tagInheritanceEnabled?: boolean;
}
