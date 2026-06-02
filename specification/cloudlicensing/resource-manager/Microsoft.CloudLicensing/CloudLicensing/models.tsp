import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.Core;
using TypeSpec.Versioning;

namespace Microsoft.CloudLicensing;

/**
 * The provisioning state of a cloud licensing resource.
 */
@Azure.Core.lroStatus
union ProvisioningState {
  ResourceProvisioningState,

  /** Resource provisioning request has been accepted. */
  Accepted: "Accepted",

  /** Resource is being provisioned. */
  Provisioning: "Provisioning",

  /** Resource is being updated. */
  Updating: "Updating",

  /** Resource is being deleted. */
  Deleting: "Deleting",

  string,
}

/**
 * The type of identity that a license can be assigned to.
 */
union AssignedIdentityType {
  string,

  /** A user identity. */
  User: "User",

  /** A group identity. */
  Group: "Group",

  /** A device identity. */
  Device: "Device",
}

/**
 * The type of license source for an allotment.
 */
union SourceType {
  string,

  /** Asset-based license source. */
  Asset: "asset",

  /** Third-party deal license source. */
  ThirdPartyDeal: "thirdPartyDeal",

  /** OMS subscription license source. */
  OmsSubscription: "omsSubscription",

  /** OCP entitlement license source. */
  OcpEntitlement: "ocpEntitlement",

  /** Low friction trial license source. */
  LowFrictionTrial: "lowFrictionTrial",

  /** SharePoint Online heartbeat tenant license source. */
  SpoHeartbeatTenant: "spoHeartbeatTenant",
}

/**
 * The state of an allotment source.
 */
union SourceState {
  string,

  /** The allotment source is active. */
  Active: "active",

  /** The allotment source is in a warning state. */
  Warning: "warning",

  /** The allotment source is suspended. */
  Suspended: "suspended",

  /** The allotment source has been deleted. */
  Deleted: "deleted",

  /** The allotment source is locked out. */
  LockOut: "lockOut",
}

/**
 * The type of owner for an allotment.
 */
union OwnerType {
  string,

  /** The owner is a tenant. */
  Tenant: "tenant",

  /** The owner is a user. */
  User: "user",
}

/**
 * Represents the owner of an allotment.
 */
model AllotmentOwner {
  /**
   * The type of the owner.
   */
  type: OwnerType;

  /**
   * The unique identifier of the owner.
   */
  id?: uuid;
}

/**
 * Represents the product or service that is allotted.
 */
model Allottable {
  /**
   * The catalog identifier for the product. This is the marketplace catalog item ID
   * that identifies the specific product offering.
   */
  catalogId: string;

  /**
   * The service identifier associated with the allottable product.
   */
  serviceId?: string;

  /**
   * The Microsoft Entra SKU identifier (GUID) for the product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-nullable" "aadSkuId is nullable in the existing CPL contract"
  aadSkuId?: uuid | null;

  /**
   * The Microsoft Entra SKU part number for the product.
   */
  aadSkuPartNumber?: string;

  /**
   * The ISV (Independent Software Vendor) tenant identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-nullable" "isvTenantId is nullable in the existing CPL contract"
  isvTenantId?: uuid | null;

  /**
   * Indicates whether this is a trial offering.
   */
  #suppress "@azure-tools/typespec-azure-core/no-nullable" "isTrial is nullable in the existing CPL contract"
  isTrial?: boolean | null;
}

/**
 * External reference identifiers associated with an allotment source.
 */
model ExternalReferences {
  /**
   * The external subscription identifier.
   */
  externalSubscriptionId?: string;

  /**
   * The external order identifier.
   */
  externalOrderId?: string;
}

/**
 * The properties of a license allotment.
 */
model AllotmentProperties {
  /**
   * The provisioning state of the allotment resource.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * The type of license source for this allotment.
   */
  sourceType: SourceType;

  /**
   * The owner of this allotment.
   */
  owner: AllotmentOwner;

  /**
   * The product or service that is allotted.
   */
  allottable: Allottable;

  /**
   * The number of licenses in this allotment.
   */
  quantity: int32;

  /**
   * The state of the allotment source.
   */
  state: SourceState;

  /**
   * Reason codes describing the current state of the allotment source.
   */
  reasonCodes?: string[];

  /**
   * The tenant identifier of the beneficiary organization for this allotment.
   */
  @visibility(Lifecycle.Read)
  beneficiaryTenantId?: uuid;

  /**
   * The start date when this allotment becomes active.
   */
  startDate?: utcDateTime;

  /**
   * The next lifecycle date for this allotment (e.g., renewal or expiration).
   */
  nextLifecycleDate?: utcDateTime;

  /**
   * The subscription end date for this allotment.
   */
  subscriptionEndDate?: utcDateTime;

  /**
   * External reference identifiers associated with this allotment.
   */
  externalReferences?: ExternalReferences;

  /**
   * The partner tenant identifier, if applicable.
   */
  partnerTenantId?: uuid;

  /**
   * The commerce billing context for this allotment.
   */
  commerceBillingContext?: string;

  /**
   * The allowed overage quantity for the allotment source.
   */
  allowedOverageUnits?: int32;
}

/**
 * The properties of a license assignment.
 */
model AssignmentProperties {
  /**
   * The provisioning state of the assignment resource.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * The Microsoft Entra object (principal) ID of the identity to which the license is assigned.
   */
  assignedIdentityId: uuid;

  /**
   * The type of identity that the license is assigned to.
   */
  assignedIdentityType: AssignedIdentityType;

  /**
   * The set of service plan IDs that are disabled for this assignment.
   */
  disabledServicePlanIds?: uuid[];
}
