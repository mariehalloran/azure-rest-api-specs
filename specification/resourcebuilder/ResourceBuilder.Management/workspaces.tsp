import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./main.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.ResourceBuilder;

/** Workspace resource */
model Workspace is TrackedResource<WorkspaceProperties> {
  /** The name of the workspace. */
  @segment("workspaces")
  @key("workspaceName")
  @visibility(Lifecycle.Read)
  @path
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-_.]{0,127}$")
  name: string;

  ...ResourceSkuProperty;
}

/** Workspace properties */
model WorkspaceProperties {
  /** The status of the last operation. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;
}

@armResourceOperations
interface Workspaces {
  get is ArmResourceRead<Workspace>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<Workspace>;
  update is ArmResourcePatchSync<Workspace, WorkspaceProperties>;

  /**
   * Delete a workspace.
   *
   * Deleting a workspace cascades to all child resources (datasets, data connections, pipelines, jobs,
   * and runs), which are removed as part of the ARM delete. A workspace is not subject to active-consumer
   * dependency validation, so this delete is not blocked by references between its child resources.
   *
   * The cascade is performed asynchronously: the service returns 202 Accepted with a Location header
   * to poll, or 204 No Content when the workspace does not exist.
   */
  delete is ArmResourceDeleteWithoutOkAsync<Workspace>;
  list is ArmResourceListByParent<Workspace>;
  listBySubscription is ArmListBySubscription<Workspace>;
}
