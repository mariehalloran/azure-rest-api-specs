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
    @pattern("^[a-z][a-z0-9-]{1,61}[a-z0-9]$")
    healthModelId: string,

    @doc("The Azure region hosting the health model's data plane.")
    @pattern("^[a-zA-Z0-9]{4,100}$")
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

@maxLength(4096)
@doc("String with max length validation of 4096 characters")
scalar string4096 extends string;

@pattern(proxyResourceNameRegex)
@doc("Entity resource name; matches the control-plane proxy-resource naming contract.")
scalar entityName extends string;

@pattern(proxyResourceNameRegex)
@doc("Signal resource name; matches the control-plane proxy-resource naming contract.")
scalar signalName extends string;

@doc("Health state")
union HealthState {
  string,

  @doc("Healthy status")
  Healthy: "Healthy",

  @doc("Degraded status")
  Degraded: "Degraded",

  @doc("Unhealthy status")
  Unhealthy: "Unhealthy",

  @doc("Unknown status")
  Unknown: "Unknown",
}

@doc("A health state transition record")
model HealthStateTransition {
  @doc("Previous health state before the transition")
  previousState: HealthState;

  @doc("New health state after the transition")
  newState: HealthState;

  @doc("Timestamp when the transition occurred")
  occurredAt: utcDateTime;

  @doc("Reason of the transition")
  reason?: string4096;
}

@doc("Health state of the requested health model, echoed by data-plane operations.")
model QueryEchoResponse {
  @doc("True when a health model exists for the requested id.")
  healthModelExists: boolean;

  @doc("Health state of the health model; omitted when the health model does not exist.")
  healthModelState?: string;
}

@error
@doc("Returned when the requested health model does not exist.")
model ModelNotFoundResponse {
  @doc("HTTP status code (404) indicating the health model was not found.")
  @statusCode
  statusCode: 404;

  @doc("Echoed health-model status; reports that the requested health model does not exist.")
  @body
  body: QueryEchoResponse;
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

@doc("Health-state transitions overlapping the requested window, newest first.")
model EntityTransitionHistoryResponse {
  @doc("The health-state transitions, ordered newest first.")
  value: HealthStateTransition[];

  @doc("The full URI to fetch the next page of results; absent when there is no next page.")
  @nextLink
  nextLink?: url;
}

@doc("Health-state periods overlapping the requested window, newest first.")
model EntityHealthStateHistoryResponse {
  @doc("The health-state periods, ordered newest first.")
  value: EntityHealthStatePeriod[];
}

@doc("A single recorded signal data point.")
model SignalHistoryDataPoint {
  @doc("Timestamp when the data point occurred (UTC).")
  occurredAt: utcDateTime;

  @doc("Value of the signal at this point; null when the signal has no numeric value at this point.")
  value?: float64;

  @doc("Health state of the signal at this point.")
  healthState: HealthState;

  @doc("Additional context for this data point; null when none is recorded.")
  additionalContext?: string4096;
}

@doc("Signal data points recorded for an entity's signal, newest first.")
model SignalDataPointHistoryResponse {
  @doc("The signal data points, ordered newest first.")
  value: SignalHistoryDataPoint[];

  @doc("The full URI to fetch the next page of results; absent when there is no next page.")
  @nextLink
  nextLink?: url;
}

@doc("A data annotation recorded for an entity.")
model DataAnnotation {
  @doc("Unique identifier of the annotation.")
  annotationId: string;

  @doc("Timestamp when the annotation was created (UTC).")
  createdAt: utcDateTime;

  @doc("Description of the annotation; null when none is recorded.")
  description?: string4096;

  @doc("Additional details for the annotation; null when none is recorded.")
  annotationDetails?: Record<string4096>;
}

@doc("Data annotations recorded for an entity, newest first.")
model DataAnnotationsResponse {
  @doc("The data annotations, ordered newest first.")
  value: DataAnnotation[];

  @doc("The full URI to fetch the next page of results; absent when there is no next page.")
  @nextLink
  nextLink?: url;
}

@route("/api")
interface Model {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Data-plane status echo is a simple non-resource GET; it does not map to an Azure.Core resource operation template. To be revisited at API Stewardship review."
  #suppress "@azure-tools/typespec-azure-core/use-standard-names" "Operation name mirrors the implemented data-plane contract ('status'); renaming would diverge from the deployed service."
  @doc("Return whether the health model exists and its current health state.")
  @get
  status(...ApiVersionParameter): QueryEchoResponse | ModelNotFoundResponse;
}

@route("/api/entities/{entityName}/transitions")
interface EntityTransitionHistory {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Data-plane history query is a simple non-resource GET; it does not map to an Azure.Core resource operation template. To be revisited at API Stewardship review."
  @doc("Return the health-state transitions recorded for an entity, newest first.")
  @get
  getTransitionHistory(
    @doc("The entity to return health-state transitions for.")
    @path
    entityName: entityName,

    @doc("Start of the requested window (UTC); defaults to 24 hours before now when omitted.")
    @query
    startAt?: utcDateTime,

    @doc("End of the requested window (UTC); defaults to now when omitted.")
    @query
    endAt?: utcDateTime,

    @doc("Maximum number of transitions to return; defaults to 1000 when omitted.")
    @query
    @maxValue(1000)
    @minValue(1)
    top?: int32,

    @doc("An opaque string value that identifies the portion of the result set to be returned with the next operation.")
    @query
    @continuationToken
    nextMarker?: string4096,

    ...ApiVersionParameter,
  ): EntityTransitionHistoryResponse;
}

@route("/api/entities/{entityName}/healthStateHistory")
interface EntityHealthStateHistory {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Data-plane history query is a simple non-resource GET; it does not map to an Azure.Core resource operation template. To be revisited at API Stewardship review."
  #suppress "@azure-tools/typespec-azure-core/response-schema-problem" "The 404 branch is an @error response (ModelNotFoundResponse); the emitted OpenAPI correctly marks it x-ms-error-response. The linter's multiple-non-error-schemas heuristic is a false positive here."
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
  ): EntityHealthStateHistoryResponse | ModelNotFoundResponse;
}

@route("/api/entities/{entityName}/signals/{signalName}/history")
interface SignalHistory {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Data-plane history query is a simple non-resource GET; it does not map to an Azure.Core resource operation template. To be revisited at API Stewardship review."
  #suppress "@azure-tools/typespec-azure-core/response-schema-problem" "The 404 branch is an @error response (ModelNotFoundResponse); the emitted OpenAPI correctly marks it x-ms-error-response. The linter's multiple-non-error-schemas heuristic is a false positive here."
  @doc("Return the data points recorded for an entity's signal, newest first.")
  @get
  get(
    @doc("The entity that owns the signal to return history for.")
    @path
    entityName: entityName,

    @doc("The signal to return history for.")
    @path
    signalName: signalName,

    @doc("Start of the requested window (UTC); defaults to 24 hours before now when omitted.")
    @query
    startAt?: utcDateTime,

    @doc("End of the requested window (UTC); defaults to now when omitted.")
    @query
    endAt?: utcDateTime,

    @doc("Maximum number of data points to return; defaults to 1000 when omitted.")
    @query
    @maxValue(1000)
    @minValue(1)
    top?: int32,

    @doc("An opaque string value that identifies the portion of the result set to be returned with the next operation.")
    @query
    @continuationToken
    nextMarker?: string4096,

    ...ApiVersionParameter,
  ): SignalDataPointHistoryResponse | ModelNotFoundResponse;
}

@route("/api/entities/{entityName}/dataAnnotations")
interface DataAnnotations {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Data-plane history query is a simple non-resource GET; it does not map to an Azure.Core resource operation template. To be revisited at API Stewardship review."
  #suppress "@azure-tools/typespec-azure-core/response-schema-problem" "The 404 branch is an @error response (ModelNotFoundResponse); the emitted OpenAPI correctly marks it x-ms-error-response. The linter's multiple-non-error-schemas heuristic is a false positive here."
  @doc("Return the data annotations recorded for an entity, newest first.")
  @get
  get(
    @doc("The entity to return data annotations for.")
    @path
    entityName: entityName,

    @doc("Start of the requested window (UTC); defaults to 24 hours before now when omitted.")
    @query
    startAt?: utcDateTime,

    @doc("End of the requested window (UTC); defaults to now when omitted.")
    @query
    endAt?: utcDateTime,

    @doc("Maximum number of annotations to return; defaults to 100 when omitted.")
    @query
    @maxValue(100)
    @minValue(1)
    top?: int32,

    @doc("An opaque string value that identifies the portion of the result set to be returned with the next operation.")
    @query
    @continuationToken
    nextMarker?: string4096,

    ...ApiVersionParameter,
  ): DataAnnotationsResponse | ModelNotFoundResponse;
}
