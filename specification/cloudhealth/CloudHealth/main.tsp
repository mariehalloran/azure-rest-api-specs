import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.Core.Foundations;

@useAuth(AadOauth2Auth<["https://data.healthmodels.azure.com/.default"]>)
@service(#{ title: "Azure Monitor Health Models Data Plane" })
@versioned(Versions)
@server(
  "https://{healthModelId}.{region}.data.healthmodels.azure.com",
  "Per-model data-plane endpoint",
  {
    @doc("The health model resource identifier.")
    healthModelId: string,

    @doc("The Azure region hosting the health model's data plane.")
    region: string,
  }
)
namespace Microsoft.CloudHealth.HealthIntelligence.DataPlane;

@doc("Service API versions.")
enum Versions {
  @doc("The 2026-06-01-preview version.")
  @previewVersion
  v2026_06_01_preview: "2026-06-01-preview",
}

// Regex for proxy-resource name validation, mirroring the control-plane contract:
// up to 260 chars, alphanumeric and hyphens, must start and end with an alphanumeric character.
alias proxyResourceNameRegex = "^[a-zA-Z0-9][a-zA-Z0-9-]{1,258}[a-zA-Z0-9]$";

@pattern(proxyResourceNameRegex)
@doc("Entity resource name; matches the control-plane proxy-resource naming contract.")
scalar entityName extends string;

@doc("Health state of the requested health model, echoed by the status endpoint.")
model QueryEchoResponse {
  @doc("True when a health model exists for the requested id.")
  healthModelExists: boolean;

  @doc("Health state of the health model; null when the health model does not exist.")
  healthModelState?: string;
}

@doc("A contiguous interval during which the entity held a single health state.")
model EntityHealthStatePeriod {
  @doc("Health state held during this period — typically one of Unknown, Healthy, Degraded, or Unhealthy. The value as recorded; an open string, not a closed enum.")
  healthState: string;

  @doc("""
    When this state became active (UTC). Omitted when the state was already active at the
    earliest point observable from retained data — i.e. its true start is older than the
    ~30-day data-retention window, predates the entity's first recorded transition, or lies
    beyond the result cap.
    """)
  startAt?: utcDateTime;

  @doc("""
    When the entity transitioned away from this state (UTC). Omitted when the state is still
    active now (no later transition recorded).
    """)
  endAt?: utcDateTime;
}

@doc("Health-state periods overlapping the requested window, newest first.")
model EntityHealthStateHistoryResponse {
  @doc("The health-state periods, ordered newest first.")
  value: EntityHealthStatePeriod[];
}

@route("/api")
interface Model {
  @doc("Return whether the health model exists and its current health state.")
  @get
  status(...ApiVersionParameter): QueryEchoResponse;
}

@route("/api/entities/{entityName}/healthStateHistory")
interface EntityHealthStateHistory {
  @doc("Return the health-state periods active during the requested window for an entity.")
  @get
  getHealthStateHistory(
    @doc("The entity to return health-state history for.")
    @path
    entityName: entityName,

    @doc("Start of the requested window (UTC).")
    @query
    startAt: utcDateTime,

    @doc("End of the requested window (UTC); defaults to now when omitted.")
    @query
    endAt?: utcDateTime,

    ...ApiVersionParameter,
  ): EntityHealthStateHistoryResponse;
}
