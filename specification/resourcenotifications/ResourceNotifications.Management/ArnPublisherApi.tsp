import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.ResourceNotifications;

// cspell:words DSTS Dsts

/** ARM resource ID of an Event Grid source supported by ARN. */
alias EventGridSourceResourceId = Azure.Core.armResourceIdentifier<[
  {
    type: "Microsoft.EventGrid/topics";
  },
  {
    type: "Microsoft.EventGrid/domains";
  },
  {
    type: "Microsoft.EventGrid/domains/topics";
  }
]>;

/** Request-rate limits overriding the defaults supplied by an ingestion unit SKU. */
@added(Versions.v2026_08_01_preview)
model CapacityOverrides {
  /** Maximum requests in a rolling 60-second window. */
  @minValue(1)
  maxRequestsPerMinute?: int32;

  /** Maximum requests in a rolling one-second window. */
  @minValue(1)
  maxRequestsPerSecond?: int32;
}

// ─── SKU ─── //

/** SKU name for an ingestion unit. Determines the HTTP push ingestion capacity tier. */
@added(Versions.v2026_08_01_preview)
union IngestionUnitSkuName {
  string,

  /** Standard push tier: production HTTP push ingestion capacity. */
  Standard: "Standard",

  /** Premium push tier: high-throughput HTTP push ingestion capacity. */
  Premium: "Premium",

  /** Dedicated push tier: high-volume HTTP push ingestion capacity. */
  Dedicated: "Dedicated",
}

/** ARN-owned capacity profile assigned to a regional ingestion unit. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitSku {
  /** Capacity profile selecting the workload type and default request-rate limits. */
  name: IngestionUnitSkuName;

  /** Number of capacity units assigned to this ingestion unit. */
  @minValue(1)
  capacity?: int32 = 1;
}

// Polymorphic Authorization

/** Authentication mechanism accepted by an ingestion unit. */
@added(Versions.v2026_08_01_preview)
union AuthenticationType {
  string,

  /** Microsoft Entra application authentication. */
  Aad: "AAD",

  /** DSTS claim authentication. */
  Dsts: "DSTS",
}

/** Base model for an ingestion unit authentication configuration. */
@added(Versions.v2026_08_01_preview)
@discriminator("authenticationType")
model IngestionUnitAuthorization {
  /** Authentication mechanism represented by this entry. */
  authenticationType: AuthenticationType;
}

/** Microsoft Entra application authentication configuration. */
@added(Versions.v2026_08_01_preview)
model AadIngestionUnitAuthorization extends IngestionUnitAuthorization {
  authenticationType: "AAD";

  /** Applications permitted to publish through this ingestion unit. */
  @identifiers(#["applicationId"])
  @minItems(1)
  applications: AuthorizedApplication[];
}

/** A Microsoft Entra application permitted to publish through an ingestion unit. */
@added(Versions.v2026_08_01_preview)
model AuthorizedApplication {
  /** Microsoft Entra application ID. */
  applicationId: string;

  /** Notification scopes permitted for this application. */
  @minItems(1)
  scopes: string[];

  /** Allowed resource-home tenant IDs. Empty or omitted permits all tenants. */
  allowedTenantIds?: string[];

  /** Allowed subscription IDs. Empty or omitted permits all subscriptions. */
  allowedSubscriptionIds?: string[];
}

/** DSTS claim authentication configuration. */
@added(Versions.v2026_08_01_preview)
model DstsIngestionUnitAuthorization extends IngestionUnitAuthorization {
  authenticationType: "DSTS";

  /** DSTS claims permitted to publish through this ingestion unit. */
  @identifiers(#["claim"])
  @minItems(1)
  claims: DstsClaimAuthorization[];
}

/** A publisher-defined DSTS claim permitted to publish through an ingestion unit. */
@added(Versions.v2026_08_01_preview)
model DstsClaimAuthorization {
  /** Case-sensitive DSTS claim moniker. */
  @minLength(1)
  claim: string;
}

// ─── INGESTION UNITS ─── //

/** Regional ingestion capacity for a publisher registered with Microsoft.ProviderHub. */
@added(Versions.v2026_08_01_preview)
@parentResource(ArmLocationResource<"Extension">)
model IngestionUnit
  is Azure.ResourceManager.ProxyResource<IngestionUnitProperties, false> {
  /** Ingestion unit name. */
  @key("ingestionUnitName")
  @segment("ingestionUnits")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}[a-zA-Z0-9]$")
  @path
  name: string;
}

/** Properties for an ingestion unit resource. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitProperties {
  /** Capacity profile assigned to this ingestion unit. */
  sku: IngestionUnitSku;

  /** Request-rate limits overriding the defaults supplied by the SKU. */
  capacityOverrides?: CapacityOverrides;

  /** Authentication mechanisms permitted to publish through this ingestion unit. */
  @identifiers(#["authenticationType"])
  @minItems(1)
  authorizations: IngestionUnitAuthorization[];

  /** System-provisioned receiver hostname. */
  @visibility(Lifecycle.Read)
  endpoint?: string;

  /** ARM resource IDs of Event Grid topics, domains, and domain topics routed through this unit. */
  eventGridTopicIds?: EventGridSourceResourceId[];

  /** Whether this ingestion unit is enabled. Set to false to disable during outages. Default: true. */
  #suppress "EnumInsteadOfBoolean" "enabled is a simple on/off operational toggle"
  enabled?: boolean = true;

  /** Read-only provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Capacity profile fields supported by an ingestion unit PATCH request. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitSkuUpdate {
  /** Updated capacity profile. */
  name?: IngestionUnitSkuName;

  /** Updated number of capacity units. */
  @minValue(1)
  capacity?: int32;
}

/** Capacity override fields supported by an ingestion unit PATCH request. */
@added(Versions.v2026_08_01_preview)
model CapacityOverridesPatch {
  /** Updated minute limit. */
  @minValue(1)
  maxRequestsPerMinute?: int32;

  /** Updated one-second limit. */
  @minValue(1)
  maxRequestsPerSecond?: int32;
}

/** Ingestion unit properties supported by a PATCH request. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitPatchProperties {
  /** Updated capacity profile. */
  sku?: IngestionUnitSkuUpdate;

  /** Updated request-rate overrides. */
  capacityOverrides?: CapacityOverridesPatch;

  /** Complete replacement authentication collection. */
  @identifiers(#["authenticationType"])
  @minItems(1)
  authorizations?: IngestionUnitAuthorization[];

  /** Complete replacement collection of Event Grid topics, domains, and domain topics routed through this ingestion unit. */
  eventGridTopicIds?: EventGridSourceResourceId[];

  /** Updated enabled state. */
  enabled?: boolean;
}

/** Ingestion unit PATCH request. */
@added(Versions.v2026_08_01_preview)
model IngestionUnitPatch {
  /** Properties to update. */
  properties?: IngestionUnitPatchProperties;
}

/** Ingestion unit operations. */
@added(Versions.v2026_08_01_preview)
@armResourceOperations
interface IngestionUnits {
  /** Get an ingestion unit. */
  get is ArmResourceRead<IngestionUnit>;

  /** Create or update an ingestion unit. Asynchronous operation. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<IngestionUnit>;

  /** Update an ingestion unit. Asynchronous operation. */
  update is ArmCustomPatchAsync<
    IngestionUnit,
    IngestionUnitPatch,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, IngestionUnit> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /** Delete an ingestion unit. Asynchronous operation. */
  delete is ArmResourceDeleteWithoutOkAsync<
    IngestionUnit,
    LroHeaders = ArmCombinedLroHeaders<ArmOperationStatus, IngestionUnit> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /** List ingestion units in a location. */
  listByLocation is ArmResourceListByParent<IngestionUnit>;
}
