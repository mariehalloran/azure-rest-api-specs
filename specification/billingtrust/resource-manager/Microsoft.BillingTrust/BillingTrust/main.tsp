import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

@armProviderNamespace("Microsoft.BillingTrust")
@service(#{ title: "BillingTrust Management API" })
@doc("Microsoft.BillingTrust resource provider. Provides Assessment and Rule resources used to evaluate trust attributes (such as education-domain qualification and business verification) of a billing account.")
@versioned(Versions)
namespace Microsoft.BillingTrust;

@doc("Supported API Versions for Microsoft.BillingTrust")
enum Versions {
  @doc("API Version 2026-03-17-preview.")
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  @Azure.Core.previewVersion
  `2026-03-17-preview`,
}

interface Operations extends Azure.ResourceManager.Operations {}

// ============================================================================
// Enums / Unions
// ============================================================================

@doc("The status of the current operation")
@Azure.Core.lroStatus
union ProvisioningState {
  string,
  ResourceProvisioningState,

  @doc("The resource is being provisioned")
  Provisioning: "Provisioning",

  @doc("The resource is updating")
  Updating: "Updating",

  @doc("The resource create request has been accepted")
  Accepted: "Accepted",
}

@doc("The aggregated evaluation state of an assessment, derived from its rules")
union AssessmentState {
  string,

  @doc("One or more rules have not reached a steady state")
  Pending: "pending",

  @doc("One or more rules are currently being evaluated")
  Running: "running",

  @doc("One or more rules require user action")
  ActionRequired: "actionRequired",

  @doc("One or more rules require manual review")
  UnderReview: "underReview",

  @doc("All rules reached a steady state, and the last non-skipped rule failed")
  Failed: "failed",

  @doc("All rules reached a steady state, and the last non-skipped rule succeeded")
  Succeeded: "succeeded",

  @doc("Assessment succeeded but with a manual override applied by operations")
  SucceededWithOverride: "succeededWithOverride",

  @doc("Assessment failed but with a manual override applied by operations")
  FailedWithOverride: "failedWithOverride",

  @doc("Assessment expired and requires re-evaluation")
  Expired: "expired",
}

@doc("The evaluation state of a rule")
union RuleState {
  string,

  @doc("Rule is queued and not yet evaluated")
  Pending: "pending",

  @doc("Rule evaluation is in progress")
  Running: "running",

  @doc("Customer input is required to proceed")
  ActionRequired: "actionRequired",

  @doc("Operations review is in progress")
  UnderReview: "underReview",

  @doc("Rule preconditions (runAfter) were not met; rule was skipped")
  Skipped: "skipped",

  @doc("Rule evaluation failed")
  Failed: "failed",

  @doc("Rule evaluation succeeded")
  Succeeded: "succeeded",

  @doc("Rule succeeded but with a manual override applied by operations")
  SucceededWithOverride: "succeededWithOverride",

  @doc("Rule failed but with a manual override applied by operations")
  FailedWithOverride: "failedWithOverride",

  @doc("Rule expired and requires re-evaluation")
  Expired: "expired",
}

@doc("The verification state of a single domain entry within an eduQualification rule")
union DomainEntryState {
  string,

  @doc("Domain verification queued or in progress")
  Pending: "pending",

  @doc("Customer must supply additional evidence (e.g. supplemental documents)")
  ActionRequired: "actionRequired",

  @doc("Domain verification failed")
  Failed: "failed",

  @doc("Domain verification succeeded")
  Succeeded: "succeeded",
}

@doc("The kind of rule. Additional kinds may be added in future API versions.")
union RuleKind {
  string,

  @doc("Education qualification rule. Verifies education-domain ownership for the billing account.")
  EduQualification: "eduQualification",

  @doc("Business verification rule. Verifies the business identity of the billing account.")
  BusinessVerification: "businessVerification",
}

@doc("Assessment template name. Each template defines a fixed set of rules and their configuration. The list of templates may be extended in future API versions.")
union AssessmentType {
  string,

  @doc("Education qualification assessment. Verifies that the billing account qualifies for education programs based on customer-supplied domains.")
  Edu: "Edu",

  @doc("Business verification assessment. Verifies the billing account's business identity against the sold-to information on file.")
  BusinessVerification: "BusinessVerification",

  @doc("Payee enrollment assessment. Verifies a billing account is eligible to enroll as a payee. Rule names within this template may change between API versions — iterate `rules` via LIST rather than addressing rules by name.")
  PayeeEnrollment: "PayeeEnrollment",

  @doc("Payee profile assessment. Verifies the payee profile associated with a billing account. Rule names within this template may change between API versions — iterate `rules` via LIST rather than addressing rules by name.")
  PayeeProfile: "PayeeProfile",
}

// ============================================================================
// Assessment (Extension Resource, singleton named "default")
// ============================================================================

@doc("A billing trust assessment. An assessment runs a set of rules to evaluate trust attributes of a billing account. The assessment is a singleton per parent resource and is always named 'default'. Re-issuing PUT with the same `assessmentType` is idempotent; changing `assessmentType` after the assessment exists is not supported.")
@singleton
model Assessment is ExtensionResource<AssessmentProperties> {
  @doc("The name of the assessment. Must be 'default'.")
  @pattern("^default$")
  @key("assessmentName")
  @segment("assessments")
  @path
  @visibility(Lifecycle.Read)
  name: string;
}

@doc("The properties of an Assessment resource")
model AssessmentProperties {
  @doc("The name of the assessment template whose rules will be evaluated (e.g. 'Edu'). Immutable after creation.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  assessmentType: AssessmentType;

  @doc("The aggregated evaluation state of all active rules within this assessment")
  @visibility(Lifecycle.Read)
  evaluationState?: AssessmentState;

  @doc("The next scheduled re-evaluation of this assessment. Only present when one or more rules in this assessment have a configured recurrence.")
  @visibility(Lifecycle.Read)
  nextEvaluation?: utcDateTime;

  @doc("Error information when evaluationState is failed")
  @visibility(Lifecycle.Read)
  error?: Azure.ResourceManager.CommonTypes.ErrorDetail;

  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "initialValues is a write-only seed parameter forwarded to per-kind rules; it is not persisted on the assessment and is intentionally not returned on Read."
  @doc("Optional initial values applied to the rules created with this assessment. Write-only — these values are routed to the per-kind rules and are not returned on read.")
  @visibility(Lifecycle.Create)
  @Azure.ResourceManager.identifiers(#[])
  initialValues?: InitialRuleValueBase[];

  @doc("The provisioning state of the resource")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

// ============================================================================
// Rule (child resource of Assessment)
// ============================================================================

@doc("A rule within an assessment")
@parentResource(Assessment)
model Rule is ProxyResource<RuleProperties> {
  @doc("The name of the rule. Rules are created by the service when the parent assessment is created — the available rule names are determined by the assessment template. Names start with an alphanumeric character and may contain letters, digits, underscores, and hyphens.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,63}$")
  @key("ruleName")
  @segment("rules")
  @path
  name: string;
}

@doc("Base properties of a Rule resource. Polymorphic by `kind` — kind-specific writable fields live on derived models.")
@discriminator("kind")
model RuleProperties {
  // Visibility note for the back-channel PUT (see `interface Rules.createOrUpdate`):
  //   `evaluationState` and `error` are conceptually read-only from a
  //   customer's perspective — they're never directly set by end users.
  //   But the RP back-PUT (issued by our worker with the BillingTrust
  //   1P FPA identity) must include them in the request body so the
  //   RPaaS-side cache reflects the latest evaluator state. To make
  //   RPaaS's `provider-api-validation` accept the body, the fields are
  //   declared with `Lifecycle.Read, Lifecycle.Create, Lifecycle.Update`.
  //   The OpenAPI surface advertises them as writable, but the runtime
  //   `RuleController.OnValidateCreate` soft-rejects every customer PUT
  //   with `OperationNotAllowed` (200 OK + `{status:failed, …}` per
  //   `rpaasextensionapi.md` §50-67). Per `urp_mrp_comm.md` §17-18, UserRP
  //   extensions are NOT invoked when the UserRP itself calls MetaRP
  //   with its 1P identity — so our back-PUT bypasses the gate.
  //
  //   `kind` is the discriminator; SDK clients cannot change a rule's
  //   kind via any operation, so it's `Lifecycle.Read` only. Our back-PUT
  //   body still carries `kind` because TypeSpec's discriminator emits it
  //   regardless of mutability.
  //
  //   `provisioningState` stays `Lifecycle.Read` because RPaaS/MetaRP
  //   owns it end-to-end via operationStatus PATCH — the projector also
  //   strips it from the wire via `NullValueHandling.Ignore`.

  @doc("The kind of rule. Acts as a discriminator for kind-specific properties.")
  @visibility(Lifecycle.Read)
  kind: RuleKind;

  @doc("The evaluation state of the rule")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  evaluationState?: RuleState;

  @doc("Error information when evaluationState is failed or actionRequired")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  error?: Azure.ResourceManager.CommonTypes.ErrorDetail;

  @doc("The provisioning state of the resource")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Properties of an eduQualification rule. Verifies education-domain ownership for a billing account.")
model EduQualificationRuleProperties extends RuleProperties {
  kind: RuleKind.EduQualification;

  @doc("Per-tenant domain entries to verify.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  @Azure.ResourceManager.identifiers(#[])
  domains?: DomainEntry[];

  @doc("References to supplemental documents. Settable only when evaluationState is `actionRequired`.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  supplementalDocuments?: url[];
}

@doc("""
  Properties of a business verification rule. Verifies the billing account's
  business identity.
  
  Sold-to fields (`soldTo`, `registrationNumber`, `taxIds`) reflect the billing
  account's information on file and cannot be supplied by end users.
  """)
model BusinessVerificationRuleProperties extends RuleProperties {
  kind: RuleKind.BusinessVerification;

  @doc("Sold-to identity used for business verification. Populated from the billing account at the time the rule is created.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  soldTo?: SoldTo;

  @doc("Registration number context (allowed types and registration id). Populated from the billing account at the time the rule is created.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  registrationNumber?: RegistrationNumber;

  @doc("Tax ids associated with the sold-to identity. Populated from the billing account at the time the rule is created.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  @Azure.ResourceManager.identifiers(#[])
  taxIds?: TaxId[];

  @doc("Optional external-registry identifier (e.g. DUNS) used to disambiguate verification matches. Settable on PATCH while `evaluationState` is `pending` or `actionRequired`.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  externalId?: ExternalId;

  @doc("References to supplemental documents (businessVerification rules only; only settable while evaluationState is `pending` or `actionRequired`).")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  supplementalDocuments?: url[];
}

@doc("Patch body for updating a rule. Polymorphic by `kind` — kind-specific patchable fields live on per-kind subtypes. PATCH cannot change a rule's kind; the discriminator carries the rule's existing kind for routing only.")
@discriminator("kind")
model RulePatchProperties {
  @doc("The kind of rule. Acts as a discriminator for per-kind patchable fields. Must match the existing rule's kind; PATCH cannot mutate kind.")
  kind: RuleKind;
}

@doc("Patch body for an eduQualification rule. Only `supplementalDocuments` is settable, and only when evaluationState == actionRequired.")
model EduQualificationRulePatchProperties extends RulePatchProperties {
  kind: RuleKind.EduQualification;

  @doc("References to supplemental documents (eduQualification rules only; only settable when evaluationState == actionRequired).")
  supplementalDocuments?: url[];
}

@doc("Patch body for a businessVerification rule. Settable while evaluationState is `pending` or `actionRequired`. `externalId` lets the customer disambiguate an ambiguous verification match (e.g. via DUNS); `supplementalDocuments` carries references to documents uploaded via the assessment-scoped upload-token action.")
model BusinessVerificationRulePatchProperties extends RulePatchProperties {
  kind: RuleKind.BusinessVerification;

  @doc("Optional external-registry identifier (e.g. DUNS) used to disambiguate ambiguous verification matches.")
  externalId?: ExternalId;

  @doc("References to supplemental documents (businessVerification rules only; only settable while evaluationState is `pending` or `actionRequired`).")
  supplementalDocuments?: url[];
}

// ============================================================================
// Review resource — DEFERRED to a future API version
// ============================================================================
//
// A tenant-level Review resource for operations follow-up is intentionally
// omitted from this preview. Tenant-level APIs require additional ARM API
// review sign-off (linter `TenantLevelAPIsNotAllowed`) and are out of scope
// for this revision. The `Review`, `ReviewProperties`, and `Reviews`
// interface — together with the appropriate `suppressions.yaml` entry and
// sign-off — will be added when the review feature is implemented.

// ============================================================================
// Supporting models
// ============================================================================

@doc("Base type for write-only initial values supplied when creating an assessment. Polymorphic by `kind`; per-kind initial values forward into the corresponding rule.")
@discriminator("kind")
model InitialRuleValueBase {
  @doc("The kind of rule to initialize")
  kind: RuleKind;
}

@doc("Initial values for an education qualification rule. Per-domain entries (`domainNames` + `tenantId`) are used to populate the rule when the assessment is created.")
model EduInitialValue extends InitialRuleValueBase {
  kind: RuleKind.EduQualification;

  @doc("Per-domain entries to use when populating the education qualification rule. Only `domainNames` and `tenantId` are read from this payload; `state` and `error` on each entry are populated by the service.")
  @Azure.ResourceManager.identifiers(#[])
  domains: DomainEntry[];
}

// NOTE: No `BusinessVerificationInitialValue` model exists because BV-producing
// templates (`BusinessVerification`, `PayeeEnrollment`, `PayeeProfile`) reject
// any `initialValues` array at PUT time with `InitialValuesNotSupportedForAssessmentType`.
// Sold-to / registration-number / tax-ids are server-populated from BillingRP.
// If a future API version needs BV seed values, add the model then.

@doc("Sold-to identity used for business verification.")
model SoldTo {
  @doc("First address line.")
  addressLine1?: string;

  @doc("Second address line.")
  addressLine2?: string;

  @doc("Third address line.")
  addressLine3?: string;

  @doc("City of the address.")
  city?: string;

  @doc("ISO 3166-1 alpha-2 country code.")
  country?: string;

  @doc("Company name.")
  companyName?: string;

  @doc("District or sub-region.")
  district?: string;

  @doc("Contact email address.")
  email?: string;

  @doc("Contact first name.")
  firstName?: string;

  @doc("Contact last name.")
  lastName?: string;

  @doc("Contact middle name.")
  middleName?: string;

  @doc("Contact phone number (E.164).")
  phoneNumber?: string;

  @doc("Postal or ZIP code.")
  postalCode?: string;

  @doc("State, province, or region.")
  region?: string;
}

@doc("Registration number context for business verification.")
model RegistrationNumber {
  @doc("Allowed registration-number types based on the billing-account country (e.g. `VAT`, `GST`, `EIN`).")
  type?: string[];

  @doc("Caller-supplied registration number value.")
  id?: string;

  @doc("Whether a registration number is required for the sold-to country.")
  required?: boolean;
}

@doc("Status of a tax id record.")
union TaxIdStatus {
  string,

  @doc("The tax id has been verified and is currently valid.")
  Valid: "valid",

  @doc("The tax id is no longer valid (e.g. expired or revoked).")
  Invalid: "invalid",

  @doc("Status could not be determined from the upstream registry.")
  Other: "other",
}

@doc("Tax id entry associated with the sold-to identity.")
model TaxId {
  @doc("Tax id value.")
  id?: string;

  @doc("ISO 3166-1 alpha-2 country code the tax id is registered in.")
  country?: string;

  @doc("Scope of the tax id (e.g. `Federal`, `State`).")
  scope?: string;

  @doc("Status of the tax id.")
  status?: TaxIdStatus;

  @doc("Type of tax id (e.g. `VAT`, `GST`, `EIN`). Extensible — additional types may be returned as upstream registries evolve.")
  type?: string;
}

@doc("External-registry identifier (e.g. DUNS) used to disambiguate ambiguous verification matches.")
model ExternalId {
  @doc("Identifier type. Currently `DUNS` is supported.")
  type: string;

  @doc("Identifier value.")
  id: string;
}

@doc("A domain entry within an education qualification rule. `domainNames` and `tenantId` are supplied on creation; `state` and `error` are returned by the service.")
model DomainEntry {
  @doc("Domain names associated with a tenant.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  domainNames: string[];

  @doc("The Microsoft Entra tenant ID owning these domains. Defaults to the calling user's tenant when omitted.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  tenantId?: Azure.Core.uuid;

  @doc("The verification state of this domain entry.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  state?: DomainEntryState;

  @doc("Error detail when state is `failed` or `actionRequired`. Omitted otherwise.")
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  error?: Azure.ResourceManager.CommonTypes.ErrorDetail;
}

// -- Action response models -------------------------------------------------

@doc("Response containing an upload token for supplemental document uploads")
model GenerateUploadTokenResponse {
  @doc("The time-bound, principal-bound upload token")
  @secret
  token: string;
}

// ============================================================================
// Resource operations
// ============================================================================

@armResourceOperations(Assessment)
interface Assessments {
  get is ArmResourceRead<Assessment>;

  @doc("Create or update an Assessment. Long-running operation — returns 200 (replace) or 201 (create) with the `Azure-AsyncOperation` polling header on both responses.")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Assessment,
    LroHeaders = Azure.ResourceManager.ArmCombinedLroHeaders &
      Azure.Core.Foundations.RetryAfterHeader,
    Response =
      | (ArmResourceUpdatedResponse<Assessment> &
          Azure.ResourceManager.ArmCombinedLroHeaders &
          Azure.Core.Foundations.RetryAfterHeader)
      | ArmResourceCreatedResponse<
          Assessment,
          Azure.ResourceManager.ArmCombinedLroHeaders &
            Azure.Core.Foundations.RetryAfterHeader
        >
  >;

  // NOTE: PATCH (`update`) intentionally NOT exposed for Assessment.
  // AssessmentProperties has zero updateable fields (assessmentType is immutable
  // Create+Read; evaluationState/error/provisioningState are read-only;
  // initialValues is create-only). Assessment is an ExtensionResource (proxy)
  // and therefore has no `tags` either. A PATCH endpoint with an empty body
  // schema is a no-op footgun for SDK consumers — drop it. Re-add when a real
  // mutable property exists.
  //
  // PUT idempotency contract: re-issuing PUT with the same assessmentType and
  // equivalent initialValues after the assessment exists is a no-op (rules
  // already exist; new identical seed is ignored). Re-issuing PUT with a
  // different assessmentType or with non-empty initialValues that would
  // re-seed existing rules is rejected by the service with 409 Conflict.

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "False positive: ArmResourceDeleteWithoutOkAsync correctly returns 202+204 for an async delete; linter mistakes it for a synchronous delete missing 200."
  @doc("Delete an assessment. Long-running operation — returns 202 + 204 + default with `Azure-AsyncOperation` (preferred) and `Location` polling headers.")
  delete is ArmResourceDeleteWithoutOkAsync<
    Assessment,
    LroHeaders = Azure.ResourceManager.ArmCombinedLroHeaders &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  list is ArmResourceListByParent<Assessment>;

  @doc("Request a time-bound, principal-bound upload token for supplemental document uploads.")
  listUploadToken is ArmResourceActionSync<
    Assessment,
    void,
    GenerateUploadTokenResponse
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "By design: rule lifecycle is owned by the parent Assessment. Rules are instantiated when the assessment is created (from the assessmentType template) and removed when the assessment is deleted. Customers cannot independently delete rules — this is an intentional deviation from the ARM convention that proxy resources support DELETE. See comments in the interface body for details."
@armResourceOperations(Rule)
interface Rules {
  get is ArmResourceRead<Rule>;
  list is ArmResourceListByParent<Rule>;

  // Back-channel createOrUpdate (PUT) — RP-only.
  //
  // Why this exists: rules are server-instantiated during the parent
  // assessment's ResourceCreationBegin, but RPaaS's tracked-resources
  // cache for ProxyOnly+Extension child types is populated only by
  // PUT-shaped operations going through the ARM/RPaaS validator.
  // Without a PUT declared here, our worker's back-PUT
  // (RpaasRuleProjector.ProjectRuleAsync) fails RPaaS's
  // `provider-api-validation` with HTTP 412
  // `HttpPayloadAPISpecValidationFailed`, the cache never populates,
  // and customer GET on `/rules/{name}` 404s at the ARM front door's
  // tracked-cache short-circuit.
  //
  // Customer-facing rules contract (architect spec §5.2) is PATCH-only.
  // End-user PUT is rejected by `RuleController.OnValidateCreate` with
  // the documented RPaaS soft-reject (`200 OK` +
  // `{status:failed, error:{Code:OperationNotAllowed,…}}` per
  // `rpaasextensionapi.md` §50-67); RPaaS surfaces this as a 4xx to ARM.
  //
  // Per EngHub `urp_mrp_comm.md` §17-18, UserRP→MetaRP calls via the
  // registered 1P identity bypass UserRP extensions entirely — so our
  // back-PUT never hits `OnValidateCreate`. Customer PUT is rejected;
  // RP PUT goes through.
  //
  // Sync (no LRO) because the back-PUT just refreshes the cache body;
  // the actual evaluation LRO is owned by the assessment-level Create
  // flow.
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-name-pattern" "Rule names are deterministic server-instantiated names (Qualify_Edu, Verify_Business, …) per template; pattern is enforced at the model level."
  @doc("Create or update a Rule. Rules are created by the service when the parent assessment is created and are not directly creatable by end users — calls from end users are rejected with `OperationNotAllowed`. Use PATCH to modify rule fields that the customer is authorized to change.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<Rule>;

  // PATCH cannot change a rule's `kind`. The patch body is discriminated
  // by `kind`; each rule kind ships its own patchable field set on a
  // derived subtype (e.g. EduQualificationRulePatchProperties
  // .supplementalDocuments). The base RulePatchProperties carries only
  // the discriminator; the runtime PATCH controller rejects a kind that
  // does not match the existing rule.
  //
  // The arm-resource-patch linter expects every patchable field on the
  // base Properties model and cannot reason about discriminated
  // subtypes. This suppression documents the deliberate design choice.
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-patch" "By design: the PATCH body is discriminated by `kind`. Per-kind patchable fields live on derived subtypes (e.g. EduQualificationRulePatchProperties.supplementalDocuments) because they are semantically meaningful only for that kind; service-side PATCH enforces both kind and state. Future kinds add their own RulePatchProperties subtype."
  @doc("Update a Rule. The PATCH body is discriminated by `kind` and must match the existing rule's kind. For `eduQualification` rules, only `supplementalDocuments` is patchable, and only when `evaluationState == actionRequired`. For `businessVerification` rules, the patchable fields are `supplementalDocuments` and `externalId`, and only when `evaluationState` is `pending` or `actionRequired`. All other field/state combinations are rejected with 400 InvalidParameterValue or 409 RuleNotActionable.")
  update is ArmCustomPatchSync<Rule, RulePatchProperties>;

  // NOTE: Rule deliberately does NOT support DELETE — rule lifecycle is
  // owned by the parent Assessment (instantiated on assessment Create
  // from the template; removed when the assessment is deleted).
  // Intentional deviation from the ARM convention that proxy resources
  // support DELETE.

  // NOTE: A `present` action applicable only to verifiedCredential rules
  // is deferred to a future API version — no template in scope uses
  // verifiedCredential. The action and its `PresentResponse` model will
  // be re-added when VerifiedCredential ships.
}

// NOTE: Reviews and provider-level actions `eventAssessment` and
// `hydrateReview` are intentionally not declared. Reviews require ARM
// API review sign-off as a tenant-level API; eventAssessment and
// hydrateReview are out of current scope and not registered in the
// ProviderHub manifest, so declaring them in TypeSpec would advertise
// endpoints the ARM front door would 404. They will be re-added (with
// manifest registrations and sign-off) when those features ship.
