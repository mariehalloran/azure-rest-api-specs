import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/http";
import "@typespec/openapi";
import "@typespec/rest";

using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Rest;

namespace Microsoft.Bami;

// ─── Enums (extensible unions) ───────────────────────────────────────────────

@doc("The provisioning state of the resource.")
union ProvisioningState {
  string,
  ResourceProvisioningState,

  @doc("The resource provisioning request has been accepted.")
  Accepted: "Accepted",

  @doc("The resource is being provisioned.")
  InProgress: "InProgress",
}

@doc("OData $filter query parameter for ARM list operations.")
model OdataFilterParameter {
  @query("$filter")
  @doc("OData filter expression. Supports a limited subset of OData filter syntax for filtering the result list.")
  filter?: string;
}

@doc("The type of automation request.")
union RequestType {
  string,

  @doc("Account provisioning request.")
  Account: "Account",

  @doc("Tenant provisioning request.")
  Tenant: "Tenant",

  @doc("Subscription provisioning request.")
  Subscription: "Subscription",

  @doc("Application consent request. A non-billable production automation request that grants first-party application consent for the specified billing scope.")
  AppConsent: "AppConsent",

  @doc("PC (Profit Center) code update request. A non-billable production automation request that updates the PC code / service group mapping for the specified billing scope.")
  PCCodeUpdate: "PCCodeUpdate",
}

@doc("The account type to create.")
union AccountType {
  string,

  @doc("SMB account type.")
  SMB: "SMB",

  @doc("SMB safelist account type.")
  SMBSafelist: "SMBSafelist",

  @doc("Field-led account type.")
  FieldLed: "FieldLed",

  @doc("FedGov direct account type.")
  FedGovDirect: "FedGovDirect",

  @doc("FedGov indirect account type.")
  FedGovIndirect: "FedGovIndirect",

  @doc("Indirect partner account type.")
  IndirectPartnerAccount: "IndirectPartnerAccount",

  @doc("Indirect customer account type.")
  IndirectCustomerAccount: "IndirectCustomerAccount",

  @doc("Indirect account type.")
  IndirectAccount: "IndirectAccount",

  @doc("NCOE customer account type.")
  NCOECustomerAccount: "NCOECustomerAccount",

  @doc("Customer-led account type.")
  CustomerLed: "CustomerLed",

  @doc("Customer-led safelist account type.")
  CustomerLedSafelist: "CustomerLedSafelist",

  @doc("Partner-led safelist account type.")
  PartnerLedSafelist: "PartnerLedSafelist",

  @doc("Enterprise Agreement account type.")
  EA: "EA",
}

@doc("The current processing status of the request.")
union RequestStatus {
  string,

  @doc("The request has been started.")
  Started: "Started",

  @doc("The request is pending approval.")
  PendingApproval: "PendingApproval",

  @doc("The request is pending admin approval.")
  PendingAdminApproval: "PendingAdminApproval",

  @doc("The request is pending BAMI admin approval.")
  PendingBAMIAdminApproval: "PendingBAMIAdminApproval",

  @doc("The request is pending budget approval.")
  PendingBudgetApproval: "PendingBudgetApproval",

  @doc("The request is pending service admin approval.")
  PendingServiceAdminApproval: "PendingServiceAdminApproval",

  @doc("The request has been approved.")
  Approved: "Approved",

  @doc("The request has been denied.")
  Denied: "Denied",

  @doc("The request has been cancelled.")
  Cancelled: "Cancelled",

  @doc("The request is in progress.")
  InProgress: "InProgress",

  @doc("The request has been completed.")
  Completed: "Completed",

  @doc("The request has failed.")
  Failed: "Failed",

  @doc("The request is expiring.")
  Expiring: "Expiring",

  @doc("The request has expired.")
  Expired: "Expired",

  @doc("The request has been deleted.")
  Deleted: "Deleted",

  @doc("The request is pending configuration.")
  PendingConfiguration: "PendingConfiguration",

  @doc("The request requires action.")
  ActionRequired: "ActionRequired",

  @doc("The request is pending linking.")
  PendingLinking: "PendingLinking",
}

@doc("The status of the application's automation onboarding.")
union ApplicationEntitlementStatus {
  string,

  @doc("The application entitlement is active.")
  Active: "Active",

  @doc("The application entitlement is suspended.")
  Suspended: "Suspended",

  @doc("The application entitlement is pending approval.")
  PendingApproval: "PendingApproval",

  @doc("The application has been offboarded.")
  Offboarded: "Offboarded",

  @doc("The application entitlement is pending linking.")
  PendingLinking: "PendingLinking",

  @doc("The application has been onboarded.")
  Onboarded: "Onboarded",
}

@doc("The audience type for field-led accounts.")
union FieldLedAudienceType {
  string,

  @doc("Internal audience.")
  Internal: "Internal",

  @doc("External audience.")
  External: "External",
}

@doc("The configuration type for field-led accounts.")
union FieldLedConfigurationType {
  string,

  @doc("Standard configuration.")
  Standard: "Standard",

  @doc("No billing configuration.")
  NoBilling: "NoBilling",
}

@doc("The environment type for field-led accounts.")
union FieldLedEnvironmentType {
  string,

  @doc("Test environment.")
  Test: "Test",

  @doc("Production environment.")
  Production: "Production",
}

@doc("The MCAPI authorization level.")
union McapiAuthorization {
  string,

  @doc("Production access level.")
  ProductionAccess: "ProductionAccess",

  @doc("Canary access level.")
  CanaryAccess: "CanaryAccess",
}

// ─── Simple Models ───────────────────────────────────────────────────────────

@doc("A postal address.")
model Address {
  @doc("Address line 1.")
  addressLine1?: string;

  @doc("Address line 2.")
  addressLine2?: string;

  @doc("Address line 3.")
  addressLine3?: string;

  @doc("The city.")
  city?: string;

  @doc("The state or province.")
  state?: string;

  @doc("The postal or ZIP code.")
  postalCode?: string;

  @doc("The ISO country code.")
  countryCode?: string;
}

@doc("Organization information for tenant and account creation.")
model OrganizationInfo {
  @doc("The display name of the organization.")
  displayName: string;

  @doc("The domain name (subdomain portion). The full domain suffix is appended by the service.")
  domainName?: string;

  @doc("The organization size.")
  size?: string;
}

@doc("User information for tenant creation. Fields are auto-populated from the application entitlement onboarding record when not provided by the caller.")
model UserInfo {
  @doc("The user's first name.")
  firstName?: string;

  @doc("The user's last name.")
  lastName?: string;

  @doc("The user's email address.")
  emailAddress?: string;

  @doc("The user's middle name.")
  middleName?: string;

  @doc("The user's phone number.")
  phoneNumber?: string;

  @doc("The preferred communication language.")
  communicationLanguage?: string;

  @doc("The user's address.")
  address?: Address;
}

@doc("The signup entity containing organization and user information for tenant creation.")
model SignupEntity {
  @doc("The organization information.")
  organizationInfo: OrganizationInfo;

  @doc("The user information. Auto-populated from the application entitlement onboarding record if not provided.")
  userInfo?: UserInfo;

  @doc("Tags for the signup entity.")
  tags?: string[];
}

// ─── Context Models ──────────────────────────────────────────────────────────

@doc("Configuration for a field-led account type. Used as the base schema for FedGovDirect, NCOE, and other field-led-derived account types.")
model FieldLedContext {
  @doc("The audience type.")
  audienceType?: FieldLedAudienceType;

  @doc("The configuration type.")
  configurationType?: FieldLedConfigurationType;

  @doc("The environment type.")
  environmentType?: FieldLedEnvironmentType;

  @doc("The MCAPI authorization level.")
  mcapiAuthorization?: McapiAuthorization;

  @doc("The object ID (GUID) for BYOT (Bring Your Own Tenant) scenarios. Mutually exclusive with signupEntity.")
  objectId?: string;

  @doc("The organization tier.")
  tier?: string;

  @doc("The tenant ID (GUID) for BYOT scenarios. Mutually exclusive with signupEntity.")
  tenantId?: string;

  @doc("The ISO country code for BYOT scenarios. Used by the service to determine country-specific account configuration.")
  countryCode?: string;

  @doc("The account fulfillment details. Populated after account creation is completed.")
  @visibility(Lifecycle.Read)
  fulfillmentDetail?: FieldLedRequestFulfillmentDetail;

  @doc("The signup entity for new tenant creation. Mutually exclusive with tenantId + objectId.")
  signupEntity?: SignupEntity;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "SMB is a standard business acronym"
@doc("Configuration specific to SMB account types. Composes FieldLedContext with SMB-specific properties.")
model SMBContext {
  ...FieldLedContext;

  @doc("The user email to be used for allow listing and test account configuration.")
  userEmail?: string;
}

@doc("Configuration for FedGov indirect account types. Composes FieldLedContext with a customer signup entity.")
model FedGovIndirectContext {
  ...FieldLedContext;

  @doc("The customer signup entity for the FedGov indirect account.")
  customerSignupEntity?: SignupEntity;
}

@doc("Configuration for indirect (CSP) account types. Composes FieldLedContext with a partner signup entity.")
model IndirectContext {
  ...FieldLedContext;

  @doc("The partner signup entity for the indirect account.")
  partnerSignupEntity?: SignupEntity;
}

@doc("Configuration for an account creation request. Specifies the account type and the corresponding type-specific sub-context.")
model AccountContext {
  @doc("The account type to create.")
  accountType: AccountType;

  @doc("The SMB account context. Required when accountType is 'SMB' or 'SMBSafelist'.")
  smbContext?: SMBContext;

  @doc("The field-led account context. Required when accountType is 'FieldLed'.")
  fieldLedContext?: FieldLedContext;

  @doc("The FedGov direct account context. Required when accountType is 'FedGovDirect'. Uses the same schema as FieldLedContext.")
  fedGovDirectContext?: FieldLedContext;

  @doc("The FedGov indirect account context. Required when accountType is 'FedGovIndirect'.")
  fedGovIndirectContext?: FedGovIndirectContext;

  @doc("The indirect account context. Required when accountType is 'IndirectPartnerAccount', 'IndirectCustomerAccount', or 'IndirectAccount'.")
  indirectContext?: IndirectContext;

  @doc("The NCOE customer account context. Required when accountType is 'NCOECustomerAccount'. Uses the same schema as FieldLedContext.")
  ncoeContext?: FieldLedContext;

  @doc("First-party application IDs that should be granted access to the newly created tenant.")
  applicationIds?: string[];

  @doc("The governance policy template ID for configuring application access in the new tenant.")
  governancePolicyTemplateId?: string;
}

@doc("Configuration for a tenant creation request.")
model TenantContext {
  @doc("Organization information including display name and domain name.")
  organizationInfo: OrganizationInfo;

  @doc("User information for tenant creation. Auto-populated from the application entitlement onboarding record if not provided.")
  userInfo?: UserInfo;

  @doc("The tenant provision location.")
  tenantProvisionLocation?: string;

  @doc("Additional tags for the tenant.")
  additionalTags?: string[];

  @doc("The tenant classification.")
  tenantClassification?: string;

  @doc("The tenant fulfillment details. Populated after tenant creation is completed.")
  @visibility(Lifecycle.Read)
  tenantFulfillmentDetail?: SignupEntityResponse;

  @doc("The billing account fulfillment details. Populated after account creation is completed.")
  @visibility(Lifecycle.Read)
  fulfillmentDetail?: FieldLedRequestFulfillmentDetail;

  @doc("First-party application IDs that should be granted access to the newly created tenant.")
  applicationIds?: string[];

  @doc("The governance policy template ID for configuring application access in the new tenant.")
  governancePolicyTemplateId?: string;
}

@doc("The test account context associated with the automation request. Contains configuration for account or tenant provisioning.")
model RequestContext {
  @doc("The account context. Required when requestType is 'Account'.")
  accountContext?: AccountContext;

  @doc("The tenant context. Required when requestType is 'Tenant'.")
  tenantContext?: TenantContext;

  @doc("The application consent context. Required when requestType is 'AppConsent'.")
  appConsentContext?: AppConsentContext;

  @doc("The PC code update context. Required when requestType is 'PCCodeUpdate'.")
  pcCodeUpdateContext?: PCCodeUpdateContext;
}

@doc("The Azure environment (cloud) that an application consent selection applies to.")
union AzureEnvironment {
  string,

  @doc("The Azure public cloud.")
  Public: "Public",

  @doc("The Azure production environment.")
  Prod: "Prod",

  @doc("The Azure US Government (Fairfax) cloud.")
  Fairfax: "Fairfax",

  @doc("The Azure China (Mooncake) cloud.")
  Mooncake: "Mooncake",

  @doc("The Azure Germany (Blackforest) cloud.")
  Blackforest: "Blackforest",

  @doc("The test environment.")
  Test: "Test",

  @doc("The dogfood environment.")
  Dog: "Dog",

  @doc("The development environment.")
  Development: "Development",

  @doc("The US Nat air-gapped cloud.")
  UsNat: "USNat",

  @doc("The US Sec air-gapped cloud.")
  UsSec: "USSec",

  @doc("The CBV environment.")
  Cbv: "Cbv",

  @doc("The France cloud.")
  France: "France",

  @doc("The Delos air-gapped cloud.")
  Delos: "Delos",
}

@doc("The first-party application consent grant for a single tenant.")
model TenantAppConsent {
  @doc("The tenant ID (GUID) the applications belong to.")
  tenantId: string;

  @doc("The first-party application IDs (GUIDs) to grant consent for in this tenant.")
  applicationIds: string[];
}

@doc("The application consent selections for a single Azure environment.")
model AppConsentEnvironmentSelection {
  @doc("The Azure environment (cloud) the consent applies to.")
  environment: AzureEnvironment;

  @doc("The per-tenant application consent grants for this environment.")
  @identifiers(#["tenantId"])
  tenants: TenantAppConsent[];
}

@doc("Configuration for an application consent request. Grants first-party application consent for a billing scope. AppConsent is a non-billable production automation request.")
model AppConsentContext {
  @doc("Whether this is a HOBO (hosted-on-behalf-of) consent. Defaults to false server-side.")
  isHobo?: boolean;

  @doc("The Service Tree ID (GUID) of the billing service that owns the consent.")
  billingServiceTreeId: string;

  @doc("The display name of the billing service that owns the consent.")
  billingServiceName: string;

  @doc("The applications to consent, grouped by Azure environment then by tenant.")
  @identifiers(#["environment"])
  appsConsentPerTenant?: AppConsentEnvironmentSelection[];
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "'PCCode' is the Profit Center code domain acronym; this casing matches the enum and field names already serialized by the deployed BAMI service (e.g. RequestType.PCCodeUpdate, currentPCCode), so the spec must preserve it to stay wire-accurate."
@doc("Configuration for a PC (Profit Center) code update request. Updates the PC code / service group mapping for a billing scope. PCCodeUpdate is a non-billable production automation request.")
model PCCodeUpdateContext {
  #suppress "@azure-tools/typespec-azure-core/casing-style" "'currentPCCode' matches the field name already serialized by the deployed BAMI service (Profit Center code domain term); renaming would diverge the spec from the wire contract."
  @doc("The current PC code prior to the update.")
  currentPCCode?: string;

  @doc("The Service Tree ID (GUID) of the billing service that owns the subscriptions.")
  billingServiceTreeId?: string;

  @doc("The display name of the billing service that owns the subscriptions.")
  billingServiceName?: string;

  @doc("The subscription IDs to update. Used for subscription-scoped PC code updates.")
  subscriptionIds?: string[];

  @doc("The source service group ID. Used for service-group-scoped PC code updates.")
  serviceGroupId?: string;

  @doc("The target service group ID to move the subscriptions to.")
  targetServiceGroupId?: string;

  @doc("The target service group display name.")
  targetServiceGroupName?: string;

  @doc("The per-service subscription selections for a service-group-scoped PC code update.")
  @identifiers(#["serviceTreeId"])
  serviceSelections?: PCCodeUpdateServiceSelection[];
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "'PCCode' is the Profit Center code domain acronym; this casing matches the enum and field names already serialized by the deployed BAMI service (e.g. RequestType.PCCodeUpdate, currentPCCode), so the spec must preserve it to stay wire-accurate."
@doc("A service and its selected subscriptions within a service-group-scoped PC code update.")
model PCCodeUpdateServiceSelection {
  @doc("The service identifier (Service Tree ID, GUID) within the service group.")
  serviceTreeId?: string;

  @doc("The service display name.")
  serviceName?: string;

  @doc("The subscription IDs selected under this service.")
  subscriptionIds?: string[];
}

// ─── Fulfillment Models ─────────────────────────────────────────────────────

@doc("Details of a created tenant.")
model TenantDetails {
  @doc("The tenant ID (GUID).")
  tenantId?: string;

  @doc("The unique user identifier (PUID).")
  userId?: string;

  @doc("The user object ID (GUID).")
  userObjectId?: string;

  @doc("The user principal name.")
  upn?: string;

  @doc("The email address provided in the admin user info.")
  emailAddress?: string;
}

@doc("The signup error.")
model SignupError {
  @doc("The error code.")
  code?: string;

  @doc("The error message.")
  message?: string;
}

@doc("Error details from the tenant signup process.")
model SignupErrorDetails {
  @doc("The signup error.")
  error?: SignupError;
}

@doc("The response from tenant creation containing provisioning state and tenant details.")
model SignupEntityResponse {
  @doc("The provisioning state of the tenant creation.")
  provisioningState?: ProvisioningState;

  @doc("The created tenant details.")
  tenantDetails?: TenantDetails;

  @doc("Error details if tenant creation failed.")
  errorDetails?: SignupErrorDetails;
}

@doc("Error details for fulfillment operations.")
model FulfillmentErrorDetail {
  @doc("The error code.")
  code?: string;

  @doc("The error message.")
  message?: string;

  @doc("The error target.")
  target?: string;
}

@doc("Fulfillment details for a field-led account creation, including billing account, profile, and invoice section identifiers.")
model FieldLedRequestFulfillmentDetail {
  @doc("The billing account ID.")
  accountId?: string;

  @doc("The organization ID.")
  organizationId?: string;

  @doc("The composite billing account identifier in the form '{accountId}:{organizationId}'. Populated when both accountId and organizationId are present.")
  @visibility(Lifecycle.Read)
  billingAccountId?: string;

  @doc("The billing profile ID.")
  billingProfileId?: string;

  @doc("The invoice section ID.")
  invoiceSectionId?: string;

  @doc("The partner billing profile ID (for indirect/CSP accounts).")
  partnerBillingProfileId?: string;

  @doc("The partner invoice section ID (for indirect/CSP accounts).")
  partnerInvoiceSectionId?: string;

  @doc("The partner account ID (for indirect/CSP accounts).")
  partnerAccountId?: string;

  @doc("The partner organization ID (for indirect/CSP accounts).")
  partnerOrganizationId?: string;

  @doc("Error details if account creation failed.")
  errorDetail?: FulfillmentErrorDetail;
}

@doc("Fulfillment details for a completed application consent request.")
model AppConsentFulfillmentDetail {
  @doc("The billing profile ID associated with the consent.")
  billingProfileId?: string;

  @doc("The invoice section ID associated with the consent.")
  invoiceSectionId?: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Consent fulfillment tags are a dynamic string-to-string map; an explicit type is not applicable."
  @doc("Tags applied as part of the consent fulfillment.")
  tags?: Record<string>;

  @doc("Error details if the application consent failed.")
  errorDetail?: FulfillmentErrorDetail;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "'PCCode' is the Profit Center code domain acronym; this casing matches the enum and field names already serialized by the deployed BAMI service (e.g. RequestType.PCCodeUpdate, currentPCCode), so the spec must preserve it to stay wire-accurate."
@doc("Fulfillment details for a completed PC code update request.")
model PCCodeUpdateFulfillmentDetail {
  @doc("The transfer ID generated for a subscription-scoped PC code update.")
  transferId?: string;

  @doc("The per-service transfer IDs generated for a service-group-scoped PC code update.")
  @identifiers(#["serviceTreeId"])
  serviceTransferIds?: PCCodeUpdateServiceTransfer[];

  @doc("Error details if the PC code update failed.")
  errorDetail?: FulfillmentErrorDetail;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "'PCCode' is the Profit Center code domain acronym; this casing matches the enum and field names already serialized by the deployed BAMI service (e.g. RequestType.PCCodeUpdate, currentPCCode), so the spec must preserve it to stay wire-accurate."
@doc("The transfer ID produced for a single service within a service-group-scoped PC code update.")
model PCCodeUpdateServiceTransfer {
  @doc("The service identifier (Service Tree ID, GUID) the transfer belongs to.")
  serviceTreeId?: string;

  @doc("The transfer ID generated for the service.")
  transferId?: string;
}

@doc("Result details for a completed automation request. The populated fields depend on the requestType.")
model RequestFulfillmentDetails {
  @doc("The organization info with full domain name (subdomain + suffix). Populated for Account and Tenant requests.")
  organizationInfo?: OrganizationInfo;

  @doc("The tenant fulfillment details including tenantId, userObjectId, and UPN. Populated for Tenant requests.")
  tenantFulfillmentDetail?: SignupEntityResponse;

  @doc("The tenant ID (GUID) of the created tenant. Populated for Account requests.")
  tenantId?: string;

  @doc("The user object ID (GUID) in the created tenant. Populated for Account requests.")
  objectId?: string;

  @doc("The account fulfillment details including accountId, billingProfileId, etc. Populated for Account requests.")
  fulfillmentDetail?: FieldLedRequestFulfillmentDetail;

  @doc("The signup entity used for tenant creation. Contains organization info and user info.")
  signupEntity?: SignupEntity;

  @doc("The application consent fulfillment details. Populated for AppConsent requests.")
  @visibility(Lifecycle.Read)
  appConsentFulfillmentDetail?: AppConsentFulfillmentDetail;

  @doc("The PC code update fulfillment details. Populated for PCCodeUpdate requests.")
  @visibility(Lifecycle.Read)
  pcCodeUpdateFulfillmentDetail?: PCCodeUpdateFulfillmentDetail;
}

// ─── Cancel Request Body ─────────────────────────────────────────────────────

@doc("The request body for cancelling an automation request.")
model CancelRequestBody {
  @doc("The reason for cancellation.")
  reason?: string;
}

// ─── Resource Properties ─────────────────────────────────────────────────────

@doc("Properties of an automation request.")
model AutomationRequestProperties {
  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @doc("The type of request to create.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  requestType: RequestType;

  @doc("The account type to create. Required for Account requests.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  accountType?: AccountType;

  @doc("The estimated monthly spend in USD for this test account. Required and must be greater than zero for billable request types (Account, Subscription, Tenant). Optional for non-billable production request types (AppConsent, PCCodeUpdate).")
  @minValue(0)
  @visibility(Lifecycle.Create, Lifecycle.Read)
  estimatedMonthlySpend?: float64;

  @doc("Business justification for this request. Optional — when omitted, the value is taken from the parent ApplicationEntitlement's businessJustification (captured at onboarding time). Free-form text MUST NOT contain customer data, PII, or secrets.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  businessJustification?: string;

  @doc("The test account context containing all configuration for the request.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  context: RequestContext;

  @doc("The current processing status of the request.")
  @visibility(Lifecycle.Read)
  requestStatus?: RequestStatus;

  @doc("The resolved service name from Service Tree.")
  @visibility(Lifecycle.Read)
  serviceName?: string;

  @doc("The business-domain timestamp at which the automation request was submitted to the BAMI service (UTC). Distinct from systemData.createdAt, which records when the underlying ARM resource record was first persisted.")
  @visibility(Lifecycle.Read)
  createdDate?: utcDateTime;

  @doc("The business-domain timestamp at which the automation request entered its most recent processing state (e.g., status transition, fulfillment update). Distinct from systemData.lastModifiedAt, which records when the underlying ARM resource record was last written.")
  @visibility(Lifecycle.Read)
  lastModifiedDate?: utcDateTime;

  @doc("The fulfillment result details. Populated when the request reaches Completed status.")
  @visibility(Lifecycle.Read)
  result?: RequestFulfillmentDetails;

  @doc("The ID (GUID) of the onboarding request; equal to the resource 'name'.")
  @visibility(Lifecycle.Read)
  onboardingRequestId?: string;
}

@doc("Properties of the application entitlement.")
model ApplicationEntitlementProperties {
  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @doc("The Service Tree ID (GUID).")
  @visibility(Lifecycle.Read)
  serviceTreeId?: string;

  @doc("The application (client) ID (GUID).")
  @visibility(Lifecycle.Read)
  applicationId?: string;

  @doc("The application display name.")
  @visibility(Lifecycle.Read)
  applicationDisplayName?: string;

  @doc("The Profit Center (PC) code used for cross-charging usage of this application entitlement, captured at onboarding time.")
  @visibility(Lifecycle.Read)
  pcCode?: string;

  @doc("Business justification captured at onboarding time. Reused as the default Comments value for every automation request created under this entitlement. Free-form text MUST NOT contain customer data, PII, or secrets.")
  @maxLength(500)
  @visibility(Lifecycle.Read)
  businessJustification?: string;

  @doc("The ID (GUID) of the onboarding request that created this application entitlement.")
  @visibility(Lifecycle.Read)
  onboardingRequestId?: string;

  @doc("The status of the application's automation onboarding.")
  @visibility(Lifecycle.Read)
  status?: ApplicationEntitlementStatus;

  @doc("The maximum number of requests allowed within the quota window.")
  @visibility(Lifecycle.Read)
  maxAssignedQuota?: int32;

  @doc("The maximum estimated cost (USD) allowed within the quota window.")
  @visibility(Lifecycle.Read)
  estimatedCostPerWindow?: float64;

  @doc("The number of days in the quota window.")
  @visibility(Lifecycle.Read)
  quotaWindowDays?: int32;

  @doc("The current number of requests used in the current period.")
  @visibility(Lifecycle.Read)
  currentQuotaUsage?: int32;

  @doc("The current cost usage (USD) in the current period.")
  @visibility(Lifecycle.Read)
  currentCostUsage?: float64;

  @doc("The date when the quota resets.")
  @visibility(Lifecycle.Read)
  quotaResetDate?: utcDateTime;

  @doc("The date when the quota was last used. Omitted from the response when the entitlement has not been used yet.")
  @visibility(Lifecycle.Read)
  lastQuotaUsageDate?: utcDateTime;

  @doc("The date when the application entitlement expires. Past this date the entitlement is no longer usable for automation.")
  @visibility(Lifecycle.Read)
  endDate?: utcDateTime;

  @doc("The Microsoft Entra tenant ID (GUID) of the user who submitted the onboarding request, captured at onboarding time.")
  @visibility(Lifecycle.Read)
  requesterTenantId?: string;

  @doc("The Microsoft Entra object ID (GUID) of the user who submitted the onboarding request, captured at onboarding time.")
  @visibility(Lifecycle.Read)
  requesterObjectId?: string;
}

// ─── Resource Definitions ────────────────────────────────────────────────────

@doc("An application entitlement resource representing the application's automation onboarding status and usage limits.")
model ApplicationEntitlementResource
  is TrackedResource<ApplicationEntitlementProperties> {
  @doc("The application entitlement identifier (onboarding request ID).")
  @key("applicationEntitlementId")
  @segment("applicationEntitlements")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-_.]{0,62}$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@doc("An automation request resource for test account provisioning.")
@parentResource(ApplicationEntitlementResource)
model AutomationRequestResource
  is TrackedResource<AutomationRequestProperties> {
  @doc("The identifier of the automation request.")
  @key("requestId")
  @segment("requests")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-_.]{0,62}$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

// ─── Operations Interfaces ───────────────────────────────────────────────────

@armResourceOperations
interface AutomationRequests {
  @doc("Get an automation request.")
  get is ArmResourceRead<AutomationRequestResource>;

  @doc("Create or update an automation request.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<AutomationRequestResource>;

  @doc("Update an automation request.")
  update is ArmCustomPatchSync<
    AutomationRequestResource,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      AutomationRequestResource,
      AutomationRequestProperties
    >
  >;

  @doc("Delete an automation request.")
  delete is ArmResourceDeleteSync<AutomationRequestResource>;

  @doc("List automation requests for an application entitlement.")
  list is ArmResourceListByParent<AutomationRequestResource>;

  @doc("Cancel an automation request.")
  cancel is ArmResourceActionSync<
    AutomationRequestResource,
    CancelRequestBody,
    AutomationRequestResource
  >;
}

@armResourceOperations
interface ApplicationEntitlements {
  @doc("Get application entitlement.")
  get is ArmResourceRead<ApplicationEntitlementResource>;

  @doc("Create or link the application entitlement after onboarding approval.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ApplicationEntitlementResource>;

  @doc("Update application entitlement.")
  update is ArmCustomPatchSync<
    ApplicationEntitlementResource,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      ApplicationEntitlementResource,
      ApplicationEntitlementProperties
    >
  >;

  @doc("Delete application entitlement.")
  delete is ArmResourceDeleteSync<ApplicationEntitlementResource>;

  @doc("List application entitlements.")
  listByResourceGroup is ArmResourceListByParent<
    ApplicationEntitlementResource,
    Parameters = OdataFilterParameter
  >;

  @doc("List application entitlements by subscription.")
  listBySubscription is ArmListBySubscription<
    ApplicationEntitlementResource,
    Parameters = OdataFilterParameter
  >;
}
