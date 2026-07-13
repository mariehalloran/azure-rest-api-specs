import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.EdgeOperator;

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/** The pricing model applied to a billing period. */
union PricingModel {
  string,

  /** Trial pricing model. */
  Trial: "Trial",

  /** Annual pricing model. */
  Annual: "Annual",
}

/** Auto-renewal setting for a billing configuration. */
union AutoRenew {
  string,

  /** Auto renew is enabled. */
  Enabled: "Enabled",

  /** Auto renew is disabled. */
  Disabled: "Disabled",
}

/** Billing status of a billing configuration. */
union BillingStatus {
  string,

  /** Billing is enabled. */
  Enabled: "Enabled",

  /** Billing is disabled. */
  Disabled: "Disabled",

  /** Billing is stopped. */
  Stopped: "Stopped",
}

/** Billing model for a billing configuration. */
union BillingModel {
  string,

  /** Billed on capacity. */
  Capacity: "Capacity",
}

/** Connection intent for a billing configuration. */
union ConnectionIntent {
  string,

  /** Device is connected to cloud. */
  Connected: "Connected",

  /** Device is disconnected from cloud. */
  Disconnected: "Disconnected",
}

/** Benefit plan enablement status. */
union BenefitPlanStatus {
  string,

  /** Benefit plan is enabled. */
  Enabled: "Enabled",

  /** Benefit plan is disabled. */
  Disabled: "Disabled",
}

/** Benefit plans associated with the billing configuration. */
model BenefitPlans {
  /** Azure Hybrid Windows Server Benefit plan status. */
  azureHybridWindowsServerBenefit?: BenefitPlanStatus;

  /** Number of Windows Server VMs licensed under the Azure Hybrid Benefit plan. */
  @minValue(1)
  windowsServerVmCount?: int32;
}

// ---------------------------------------------------------------------------
// Shared models
// ---------------------------------------------------------------------------

/** Details for a single billing period. */
model BillingPeriodDetails {
  /** Number of cores allocated for this billing period. Must be greater than zero. */
  @minValue(1)
  cores: int32;

  /** The pricing model applied to this billing period. */
  pricingModel: PricingModel;

  /** The start date of this billing period in YYYY-MM-DD format. */
  startDate: plainDate;

  /** The end date of this billing period in YYYY-MM-DD format. Absent for open-ended periods. */
  endDate?: plainDate;
}

/** Billing configuration details, including renewal settings and period information. */
model BillingConfigurationDetails {
  /** Auto-renewal setting for the billing configuration. */
  autoRenew: AutoRenew;

  /** The current billing status. Preserved verbatim in historical snapshots. */
  billingStatus: BillingStatus;

  /** The current active billing period. */
  current: BillingPeriodDetails;

  /** The upcoming billing period. Present only when a future period has been scheduled. */
  upcoming?: BillingPeriodDetails;
}

/**
 * Properties shared by billing configurations and their snapshots.
 * This payload originates from Azure and is uploaded by the customer to Azure Local (ALDO)
 * via this API. ALDO performs server-side signature validation on the received JSON to verify
 * it has not been tampered with since it was issued by Azure. The payload must be forwarded
 * verbatim — any modification to field values will cause signature verification to fail.
 * ARM populates `provisioningState`, `etag`, and `systemData` on the envelope automatically.
 */
model BillingConfigurationProperties {
  /** The ARM resource identifier of the associated `Microsoft.Edge/disconnectedOperations` resource
   * whose billing this configuration covers. This is a cross-reference field in the properties payload —
   * it is not the identifier of the `BillingConfiguration` resource itself. */
  resourceId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Edge/disconnectedOperations";
    }
  ]>;

  /** The name of the associated disconnected operations resource. */
  resourceName: string;

  /** The identifier of the stamp hosting the resource. This value is assigned by Azure and
   * sourced verbatim from the deployment manifest issued by `Microsoft.Edge/disconnectedOperations`. */
  stampId: string;

  /** The Azure region where the associated resource is located. */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  location: string;

  /** The billing model for this configuration. */
  billingModel: BillingModel;

  /** The connection intent for this configuration. */
  connectionIntent: ConnectionIntent;

  /** The cloud environment in which the associated resource operates. */
  cloud?: string;

  /** The billing configuration data. Required when creating or replacing the resource. */
  billingConfiguration: BillingConfigurationDetails;

  /** The benefit plans associated with the billing configuration. */
  benefitPlans?: BenefitPlans;

  /**
   * The provisioning state of the billing configuration resource.
   * Set by ARM after each write operation. Read-only.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

// ---------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------

/**
 * The active billing configuration for a subscription.
 * Represents the billing manifest for Azure Local Disconnected Operations (ALDO) resources
 * registered under this subscription. This is a singleton resource — the only accepted
 * resource name is `default`. After each successful PUT, the RP creates an immutable
 * snapshot under `billingConfigurations/default/snapshots`.
 */
@subscriptionResource
@singleton("default")
model BillingConfiguration is ProxyResource<BillingConfigurationProperties> {
  ...ResourceNameParameter<BillingConfiguration>;
  ...Azure.ResourceManager.EntityTagProperty;
}

/**
 * An immutable historical snapshot of a billing configuration.
 * Snapshots are created by the RP after each successful PUT on `billingConfigurations/default`.
 */
@parentResource(BillingConfiguration)
model BillingConfigurationSnapshot
  is ProxyResource<BillingConfigurationProperties> {
  ...ResourceNameParameter<
    Resource = BillingConfigurationSnapshot,
    KeyName = "snapshotName",
    SegmentName = "snapshots",
    NamePattern = "^[a-zA-Z0-9_-]+$"
  >;
  ...Azure.ResourceManager.EntityTagProperty;
}

// ---------------------------------------------------------------------------
// Interfaces
// ---------------------------------------------------------------------------

/**
 * Operations on the active billing configuration for a subscription.
 * Only GET and PUT (create-or-replace) are supported. PATCH and DELETE are not allowed —
 * customers manage the configuration exclusively via PUT /billingConfigurations/default.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "BillingConfiguration intentionally does not support DELETE. The active configuration can only be replaced via PUT /billingConfigurations/default."
#suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "BillingConfiguration intentionally does not support DELETE."
@armResourceOperations
interface BillingConfigurations {
  /** Gets the active billing configuration for the subscription. */
  get is ArmResourceRead<BillingConfiguration>;

  /**
   * Creates or fully replaces the active billing configuration for the subscription.
   * The resource name must be `default`. After ARM commits the resource, the RP creates
   * an immutable snapshot under `billingConfigurations/default/snapshots`.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    BillingConfiguration,
    Parameters = {
      @header("If-Match")
      @doc("The request should only proceed if an entity matches this string.")
      ifMatch?: string;

      @header("If-None-Match")
      @doc("The request should only proceed if no entity matches this string.")
      ifNoneMatch?: string;
    }
  >;

  /**
   * Lists all billing configuration resources for the subscription.
   * Since billingConfigurations is a singleton, this always returns at most one item (`default`).
   */
  listBySubscription is ArmListBySubscription<BillingConfiguration>;
}

/** Read-only operations on billing configuration snapshots. */
@armResourceOperations
interface BillingConfigurationSnapshots {
  /** Gets a specific historical snapshot of a billing configuration by snapshot name. */
  get is ArmResourceRead<BillingConfigurationSnapshot>;

  /**
   * Lists all historical snapshots of billing configurations for the subscription.
   *
   * **Expected volume:** Snapshots are created only when the customer replaces the active
   * billing configuration via PUT /billingConfigurations/default. Customers are expected
   * to update at most once per year; in the worst case (e.g., a mid-year plan change)
   * no more than twice per year. Even accounting for edge cases such as corrections or
   * retries, the total number of snapshots per subscription is expected to remain low
   * (low tens) over the lifetime of a subscription. Snapshots are never
   * deleted. Callers should not need to traverse more than one page in practice.
   */
  list is ArmResourceListByParent<BillingConfigurationSnapshot>;
}
