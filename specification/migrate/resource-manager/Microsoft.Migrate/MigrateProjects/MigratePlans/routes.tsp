import "./MigratePlan.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using OpenAPI;

namespace Microsoft.Migrate;

@added(ApiVersions.v2026_06_01_preview)
@armResourceOperations
interface MigratePlans {
  get is ArmResourceRead<MigratePlan>;

  listByParent is ArmResourceListByParent<MigratePlan>;

  @doc("Register or activate a Migrate plan. Registering creates the plan; supplying artifacts activates it and starts plan generation. This is a synchronous (non-LRO) operation: provisioningState is terminal in the response, and asynchronous plan-generation progress is tracked by polling the read-only `status` property via GET until it reaches a terminal value.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<MigratePlan>;

  @doc("Update a Migrate plan. Supports updating the migration strategy. Artifact `status` is read-only and reflects server-computed plan-generation progress, so it cannot be changed through this operation.")
  update is ArmResourcePatchSync<MigratePlan, MigratePlanProperties>;

  @doc("Delete a Migrate plan.")
  delete is ArmResourceDeleteSync<MigratePlan>;
}
