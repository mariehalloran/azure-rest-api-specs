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
 * The product information for a license allotment.
 */
model Allotted {
  /**
   * The product code (UPN) for the allotted product (e.g., "EMSPREMIUM").
   */
  productCode?: string;

  /**
   * The service identifier for the allotted product.
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
 * An underlying source (subscription or asset) backing a license allotment.
 */
model AllotmentSource {
  /**
   * The unique identifier of the underlying source.
   */
  id?: string;

  /**
   * The source type (e.g., "asset", "subscription").
   */
  type?: string;

  /**
   * The lifecycle state of the source (e.g., "active", "warning", "suspended").
   */
  state?: string;
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
   * The owner of the allotment.
   */
  owner: AllotmentOwner;

  /**
   * The product information for the allotment.
   */
  allotted: Allotted;

  /**
   * The total number of licenses in the allotment, summed across all sources.
   */
  totalQuantity: int64;

  /**
   * The number of unique principals currently holding an assignment from the allotment.
   */
  assignedCount?: int32;

  /**
   * The underlying sources (subscriptions or assets) backing the allotment.
   */
  sources?: AllotmentSource[];

  /**
   * The tenant identifier of the beneficiary organization for the allotment.
   */
  @visibility(Lifecycle.Read)
  beneficiaryTenantId?: uuid;
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
