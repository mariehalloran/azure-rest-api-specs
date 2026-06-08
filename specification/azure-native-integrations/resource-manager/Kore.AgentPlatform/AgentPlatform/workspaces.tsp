import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Kore.AgentPlatform;

/**
 * A Workspace resource in the Kore.AgentPlatform provider.
 *
 * Child proxy resource type under an Organization. Workspaces are not tracked
 * (no `location`/`tags`). Workspaces do not expose PUT/PATCH/DELETE on the
 * child URL; create/delete are performed by invoking the corresponding
 * action on the parent Organization:
 *
 *   - createWorkspace  : POST .../organizations/{org}/createWorkspace
 *   - deleteWorkspace  : POST .../organizations/{org}/deleteWorkspace
 *
 * GET and LIST are exposed on the child URL and routed through ARM/RPaaS to the
 * Liftr resource provider.
 */
@parentResource(OrganizationResource)
model WorkspaceResource
  is Azure.ResourceManager.ProxyResource<WorkspaceProperties> {
  /** Name of the Workspace. */
  @key("workspaceName")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-]{0,98}[a-zA-Z0-9]$")
  @segment("workspaces")
  @minLength(2)
  @maxLength(100)
  @path
  @visibility(Lifecycle.Read)
  name: string;
}

/** Read operations on the Workspace child resource type. */
@armResourceOperations
interface Workspaces {
  /** Get a Workspace under an Organization. */
  get is ArmResourceRead<WorkspaceResource>;

  /** List Workspaces under an Organization. */
  listByOrganization is ArmResourceListByParent<WorkspaceResource>;
}
