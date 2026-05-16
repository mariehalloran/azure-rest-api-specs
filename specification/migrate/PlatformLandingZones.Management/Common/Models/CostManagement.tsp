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
}

@doc("Cost management configuration for the landing zone.")
model CostManagement {
  @doc("Billing account type.")
  billingAccountType: BillingAccountType;

  @doc("Reservation purchase strategy.")
  reservations: ReservationStrategy;

  @doc("Savings plan strategy.")
  savingsPlans: SavingsPlanStrategy;

  @doc("Budgets configured on the landing zone.")
  @identifiers(#["name"])
  budgets?: PlatformLandingZoneBudget[];
}
