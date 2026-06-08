import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@azure-tools/typespec-liftr-base";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using LiftrBase;

namespace Kore.AgentPlatform;

// =============================================================================
// User / Company profile metadata
// =============================================================================

/**
 * Azure customer profile metadata used by the partner for JIT provisioning.
 *
 * Composes the standard `LiftrBase.UserDetails` (firstName, lastName,
 * emailAddress, upn, phoneNumber) with Kore-specific extensions.
 */
model UserDetails {
  ...LiftrBase.UserDetails;

  /** Alternate email address of the user. */
  alternateEmail?: email;

  /** Mailing or office address. */
  address?: string;
}

/** Organization-tier company metadata. */
model CompanyDetails {
  /** Company name. */
  companyName?: string;

  /** Office address of the company. */
  officeAddress?: string;

  /** Country or region of the company. */
  country?: string;

  /** Primary domain of the company. */
  domain?: string;

  /** Industry or line of business. */
  businessType?: string;

  /** Approximate number of employees. */
  numberOfEmployees?: int32;
}

// =============================================================================
// Single sign-on (read-only; populated from Kore create/patch response)
// =============================================================================

/**
 * Single Sign-On metadata returned by the partner after Organization creation.
 *
 * Spreads the standard `LiftrBase.SingleSignOnPropertiesV2` shape
 * (`type`, `state`, `enterpriseAppId`, `url`, `aadDomains`).
 */
model SingleSignOnProperties {
  ...LiftrBase.SingleSignOnPropertiesV2;
}

// =============================================================================
// Organization partner properties
// =============================================================================

/** Partner-specific (Kore) properties for an Organization. */
model OrganizationPartnerProperties {
  /** Display name of the Organization on the partner side. */
  @minLength(2)
  @maxLength(100)
  organizationName: string;

  /** Billing contact email address for the Organization. */
  billingEmail: email;

  /** Initial owner email for the Organization. JIT-provisioned by the partner if the user does not already exist. */
  ownerEmail: email;

  /**
   * Default Workspace created atomically with the Organization.
   * Required at create time and immutable thereafter.
   * After create, manage workspaces via the workspaces resource type and parent actions.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  defaultWorkspace: DefaultWorkspaceProperties;

  /** Partner-issued Organization identifier (e.g., "org_01..."). */
  @visibility(Lifecycle.Read)
  partnerResourceId?: string;
}

/** Properties of the default Workspace created with the Organization. */
model DefaultWorkspaceProperties {
  /** Display name of the default Workspace. */
  @minLength(2)
  @maxLength(100)
  name: string;
}

// =============================================================================
// Organization resource properties
// =============================================================================

/** Properties of a Kore.AgentPlatform Organization. */
model OrganizationProperties {
  /**
   * Azure Marketplace SaaS subscriptions linked to this Organization.
   * At least one entry is required. Mutable to support Marketplace-driven
   * plan changes.
   */
  @minItems(1)
  @identifiers(#["subscriptionId"])
  marketplaceDetails: LiftrBase.MarketplaceDetails[];

  /** Partner-specific (Kore) Organization properties. */
  partnerProperties: OrganizationPartnerProperties;

  /** Azure customer profile metadata used by the partner for JIT provisioning. */
  user: UserDetails;

  /** Organization-tier company metadata. */
  companyDetails?: CompanyDetails;

  /** Single sign-on metadata returned by the partner after Organization creation. */
  @visibility(Lifecycle.Read)
  singleSignOn?: SingleSignOnProperties;

  /** Provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

// =============================================================================
// Workspace resource properties
// =============================================================================

/** Partner-specific (Kore) properties for a Workspace. */
model WorkspacePartnerProperties {
  /** Display name of the Workspace on the partner side. */
  @minLength(2)
  @maxLength(100)
  name: string;

  /** Email address of the Workspace owner. */
  ownerEmail?: email;

  /** Partner-issued Workspace identifier (e.g., "ws_01..."). */
  @visibility(Lifecycle.Read)
  partnerResourceId?: string;
}

/** Properties of a Kore.AgentPlatform Workspace. */
model WorkspaceProperties {
  /** Partner-specific (Kore) Workspace properties. */
  partnerProperties: WorkspacePartnerProperties;

  /** Indicates whether this is the default Workspace created with the Organization. */
  @visibility(Lifecycle.Read)
  isDefault?: boolean;

  /** Provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

// =============================================================================
// Action request bodies (workspace lifecycle, via parent Organization)
// =============================================================================

/**
 * PATCH body for the Organization resource.
 *
 * Intentionally omits ARM `tags`. Liftr does not propagate Azure resource tags
 * to the partner (Kore.AgentPlatform); customers can still tag the resource via
 * the generic `Microsoft.Resources/tags/default` ARM endpoint, but those tags
 * are not part of this resource provider's contract.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/patch-envelope" "Tags are not propagated to the partner (Kore). Tag updates are handled via the generic Microsoft.Resources/tags ARM endpoint and are not part of this RP's PATCH contract."
model OrganizationResourceUpdate {
  /** The resource-specific properties to update. */
  properties?: OrganizationPropertiesUpdate;
}

/** Mutable Organization properties (subset of OrganizationProperties). */
model OrganizationPropertiesUpdate {
  /**
   * Azure Marketplace SaaS subscriptions linked to this Organization.
   * Mutable to support Marketplace-driven plan changes.
   */
  @identifiers(#["subscriptionId"])
  marketplaceDetails?: LiftrBase.MarketplaceDetails[];

  /** Partner-specific (Kore) Organization properties. */
  partnerProperties?: OrganizationPartnerPropertiesUpdate;

  /** Azure customer profile metadata. */
  user?: UserDetails;

  /** Organization-tier company metadata. */
  companyDetails?: CompanyDetails;
}

/** Mutable partner properties for PATCH. */
model OrganizationPartnerPropertiesUpdate {
  /** Display name of the Organization on the partner side. */
  @minLength(2)
  @maxLength(100)
  organizationName?: string;

  /** Billing contact email address for the Organization. */
  billingEmail?: email;

  /** Initial owner email for the Organization. */
  ownerEmail?: email;
}

/** Request body for the `createWorkspace` action on an Organization. */
model CreateWorkspaceRequest {
  /**
   * Name of the Workspace to create. Becomes the ARM resource name segment,
   * addressable thereafter at `.../organizations/{org}/workspaces/{workspaceName}`.
   */
  @minLength(2)
  @maxLength(100)
  workspaceName: string;

  /**
   * Partner-issued identifier of the parent Organization (e.g., "org_01...").
   * Passed in the body so the partner can correlate the workspace action with
   * the Kore-side Organization without a separate lookup.
   */
  organizationPartnerResourceId: string;

  /** Properties of the Workspace to create. */
  properties: WorkspacePartnerProperties;
}

/** Request body for the `deleteWorkspace` action on an Organization. */
model DeleteWorkspaceRequest {
  /** Name of the Workspace to delete. */
  @minLength(2)
  @maxLength(100)
  workspaceName: string;

  /**
   * Partner-issued identifier of the parent Organization (e.g., "org_01...").
   * Passed in the body so the partner can correlate the workspace action with
   * the Kore-side Organization without a separate lookup.
   */
  organizationPartnerResourceId: string;
}

/** Request body for the `restoreWorkspace` action on an Organization. */
model RestoreWorkspaceRequest {
  /** Name of the soft-deleted Workspace to restore (within the grace period). */
  @minLength(2)
  @maxLength(100)
  workspaceName: string;

  /**
   * Partner-issued identifier of the parent Organization (e.g., "org_01...").
   * Passed in the body so the partner can correlate the workspace action with
   * the Kore-side Organization without a separate lookup.
   */
  organizationPartnerResourceId: string;
}

// =============================================================================
// SaaS Decoupling models (Liftr Standard)
//
// "SaaS" is the industry-standard abbreviation for Software as a Service and is
// retained verbatim in model and property names for consistency with the
// Liftr/marketplace ecosystem. Per-statement #suppress directives below silence
// the casing-style linter; TypeSpec requires one per declaration.
// =============================================================================

/** SaaS-related data properties. Contains the full list of SaaS resource IDs to link. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "SaaS abbreviation."
model SaaSData {
  /** List of SaaS resource IDs to link to this Organization. */
  #suppress "@azure-tools/typespec-azure-core/casing-style" "SaaS abbreviation."
  saaSResourceIds: string[];
}

/** SaaS guid & PublisherId for Activate and Validate SaaS Resource. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "SaaS abbreviation."
model ActivateSaaSParameterRequest {
  /** SaaS guid for Activate and Validate SaaS Resource. */
  saasGuid: string;

  /** Publisher Id for the marketplace offer. */
  publisherId: string;
}

/** Marketplace SaaS resource details. */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "Using extends for proxy resource model"
#suppress "@azure-tools/typespec-azure-core/casing-style" "SaaS abbreviation."
model SaaSResourceDetailsResponse
  extends Azure.ResourceManager.CommonTypes.ProxyResource {
  /** Id of the Marketplace SaaS Resource. */
  saasId?: string;
}

/** Individual SaaS resource linked to the Organization. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "SaaS abbreviation."
model LinkedSaaSItem {
  /** SaaS resource id. */
  #suppress "@azure-tools/typespec-azure-core/casing-style" "SaaS abbreviation."
  saaSResourceId: string;

  /** Flag indicating if the SaaS resource is hidden. */
  isHiddenSaaS?: boolean;
}

/** Response containing the list of SaaS resources linked to the Organization. */
#suppress "@azure-tools/typespec-azure-core/casing-style" "SaaS abbreviation."
model LinkedSaaSListResponse {
  /** List of SaaS resources linked to this Organization. */
  @identifiers(#["saaSResourceId"])
  value: LinkedSaaSItem[];
}
