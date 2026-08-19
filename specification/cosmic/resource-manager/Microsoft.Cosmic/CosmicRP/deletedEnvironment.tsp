import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./namespace.tsp";

using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace Microsoft.Cosmic;

@doc("A soft-deleted Environment, surfaced as a read-only tombstone under its parent namespace. Lists, restores, and purges are performed against this proxy resource while the namespace remains live.")
@parentResource(Namespace)
model DeletedEnvironment is ProxyResource<DeletedEnvironmentProperties> {
  @doc("The name of the soft-deleted environment.")
  @key("deletedEnvironmentName")
  @segment("deletedEnvironments")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @minLength(3)
  @maxLength(63)
  @path
  name: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Soft-deleted environments are read-only tombstone views of a previously-deleted environment; they have no provisioning lifecycle, so provisioningState is not applicable."
@doc("Properties of a soft-deleted environment. All properties are read-only; the soft-delete state is owned by the resource provider.")
model DeletedEnvironmentProperties {
  @doc("Soft-delete bookkeeping (when it was deleted, retention, purge eligibility, who deleted it).")
  @visibility(Lifecycle.Read)
  deleteMetadata?: DeletedEnvironmentDeleteMetadata;

  @doc("The captured environment configuration at soft-delete time. Mirrors the original resource's properties so a GET on the deleted environment surfaces the full typed body (Key Vault DeletedKeyBundle style).")
  @visibility(Lifecycle.Read)
  environment?: EnvironmentProperties;
}

@doc("Soft-delete metadata for a deleted environment. All properties are read-only and owned by the resource provider.")
model DeletedEnvironmentDeleteMetadata {
  @doc("UTC instant at which the environment was soft-deleted.")
  @visibility(Lifecycle.Read)
  deletedAt?: utcDateTime;

  @doc("UTC instant at which the soft-deleted environment is eligible for automatic purge (deletedAt + retentionPeriod).")
  @visibility(Lifecycle.Read)
  purgeAfter?: utcDateTime;

  @doc("Retention bucket applied to this soft-deleted environment (ISO 8601 duration, e.g. P30DT0H0M).")
  @visibility(Lifecycle.Read)
  retentionPeriod?: string;

  @doc("When true, the environment cannot be manually purged during the retention window.")
  @visibility(Lifecycle.Read)
  purgeProtection?: boolean;

  @doc("Identity that initiated the delete (non-sensitive context only).")
  @visibility(Lifecycle.Read)
  deletedBy?: string;
}

// --- Action models --------------------------------------------------

#suppress "@azure-tools/typespec-client-generator-core/csharp-model-suffix" "Name kept for backward compatibility"
@doc("Request body for the soft-deleted environment actions (purge, restore), carrying the platform ring so APIM can route the request to the target ring's RP instance. The soft-deleted environment is a proxy resource (not cached by ARM/MetaRP), so the ring is supplied explicitly rather than read from a replayed body.")
model DeletedEnvironmentActionRequest {
  @doc("Platform ring classification (e.g. test, sdf, msit, prod). Used by APIM to route the request to the target ring's RP instance.")
  platformRing: CosmicRing;
}

@doc("Response body for the purge action.")
model DeletedEnvironmentPurgeResult {
  @doc("The name of the environment that was purged.")
  environmentName: string;

  @doc("Whether the purge succeeded for all instances of the environment.")
  purged: boolean;

  @doc("Failure detail when the purge did not fully succeed (no secrets). Null on success.")
  reason?: string;
}

@doc("Response body for the restore action.")
model DeletedEnvironmentRestoreResult {
  @doc("The name of the environment that was restored.")
  environmentName: string;

  @doc("Whether the restore succeeded for all instances of the environment.")
  restored: boolean;

  @doc("Failure detail when the restore did not fully succeed (no secrets). Null on success.")
  reason?: string;
}

@armResourceOperations
interface DeletedEnvironments {
  @doc("Get a soft-deleted environment by name within the parent namespace.")
  get is ArmResourceRead<DeletedEnvironment>;

  @doc("List all soft-deleted environments within the parent namespace.")
  listByNamespace is ArmResourceListByParent<DeletedEnvironment>;

  @doc("Permanently purge a soft-deleted environment, tearing down the underlying NPS namespace instances. Takes the platform ring in the request body for APIM routing. Blocked with 403 when purge protection is enabled; returns 404 when no soft-deleted environment with the given name exists.")
  @action("purge")
  purge is ArmResourceActionSync<
    DeletedEnvironment,
    DeletedEnvironmentActionRequest,
    ArmResponse<DeletedEnvironmentPurgeResult>
  >;

  @doc("Restore a soft-deleted environment back to active state during the retention window. Takes the platform ring in the request body for APIM routing.")
  @action("restore")
  restore is ArmResourceActionSync<
    DeletedEnvironment,
    DeletedEnvironmentActionRequest,
    ArmResponse<DeletedEnvironmentRestoreResult>
  >;
}
