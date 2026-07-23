import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./versions.tsp";

using Rest;
using Http;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;

namespace Anyscale.Platform;

/** An Anyscale on Azure terms and conditions that a subscription must accept before Anyscale resources can be provisioned. A read-only catalog entry that customers view and accept. */
@added(Versions.v2026_07_01_preview)
@subscriptionResource
@resource("agreements")
model Agreement is ProxyResource<AgreementProperties> {
  /** The name that uniquely identifies the agreement (e.g. "default" for the primary terms). */
  @pattern("^[a-zA-Z0-9_-]+$")
  @key("agreementName")
  @path
  @segment("agreements")
  name: string;
}

/** Properties of an Anyscale agreement. All fields are RP-managed (read-only); customers read and accept, they do not author. */
@added(Versions.v2026_07_01_preview)
model AgreementProperties {
  /** The provisioning state of the agreement resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** The display name of the agreement. */
  @visibility(Lifecycle.Read)
  displayName?: string;

  /** URL to view/download the agreement document. */
  @visibility(Lifecycle.Read)
  agreementLink?: url;

  /** Current status of the agreement. */
  @visibility(Lifecycle.Read)
  status?: AgreementStatus;

  /** Date from which the agreement is effective (UTC). Present once accepted. */
  @visibility(Lifecycle.Read)
  effectiveDate?: utcDateTime;

  /** Identities that accepted the agreement. Present once accepted. */
  @visibility(Lifecycle.Read)
  @identifiers(#["email"])
  participants?: Participant[];
}

/** The current status of the agreement. */
@added(Versions.v2026_07_01_preview)
union AgreementStatus {
  string,

  /** The agreement is available but has not been accepted yet. */
  Pending: "Pending",

  /** The agreement has been accepted and is currently in effect. */
  Active: "Active",
}

/** An identity that accepted the agreement. */
@added(Versions.v2026_07_01_preview)
model Participant {
  /** Email/UPN of the participant who accepted. */
  email: string;

  /** When the participant accepted (UTC). */
  statusDate: utcDateTime;
}

@added(Versions.v2026_07_01_preview)
@armResourceOperations
interface Agreements {
  /** Get an agreement. Returns the catalog entry (status "Pending") until accepted, then the full signed record. */
  get is ArmResourceRead<Agreement>;

  /** List the agreements available to the subscription. */
  listBySubscription is ArmListBySubscription<Agreement>;

  /** Accept (sign) the agreement. The accepting identity is taken from the ARM caller token. Idempotent. */
  accept is ArmResourceActionSync<Agreement, void, Agreement>;
}
