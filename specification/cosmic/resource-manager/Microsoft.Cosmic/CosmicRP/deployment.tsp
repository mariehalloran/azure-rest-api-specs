import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./environment.tsp";

using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace Microsoft.Cosmic;

@doc("A singleton Deployment resource carrying which component revisions are currently active in the parent environment, and the observed per-instance apply outcome. Modeled as a child resource so deployment intent and capacity intent have independent lifecycle, RBAC, ETag, and reconciliation.")
@parentResource(Environment)
@singleton("default")
model Deployment is TrackedResource<DeploymentProperties> {
  @doc("The name of the deployment. Always 'default' - the deployment is a singleton child of its environment.")
  @key("deploymentName")
  @segment("deployments")
  @pattern("^default$")
  @path
  name: string;
}

@doc("Properties of a Deployment resource.")
model DeploymentProperties {
  @doc("Platform ring of the parent environment. Required: the APIM gateway selects the per-ring backend by reading this value out of the request body, so a deployment without it cannot be routed. Must match the parent environment's platformRing; set at create and immutable thereafter.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  platformRing: CosmicRing;

  @doc("Per-component active-revision intent, one entry per component the app deploys into this environment. Replaced atomically on every write; a component or partition the body omits reverts to no active revision.")
  @identifiers(#["component"])
  componentStates: ComponentState[];

  @doc("Observed per-instance, per-component apply outcome for this environment.")
  @visibility(Lifecycle.Read)
  status?: DeploymentStatus;

  @doc("The provisioning state of the deployment resource. Reports the ARM write lifecycle only; the observed workload apply outcome is reported separately by status.aggregateApplyState.")
  @visibility(Lifecycle.Read)
  provisioningState?: CosmicDeployingState;
}

@armResourceOperations
interface Deployments {
  get is ArmResourceRead<Deployment>;

  @doc("Create or replace the full deployment intent for the environment. This is the only verb that writes deployment intent; PATCH updates tags only, so componentStates is always replaced atomically.")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Deployment>;

  @doc("Update the tags of a deployment. Deployment intent is not patchable; only tags may be updated here.")
  update is ArmTagsPatchSync<Deployment>;

  @doc("Undeploy. Reconciles the workload off every realized instance in the environment, then removes the deployment resource, leaving the environment's capacity intact.")
  delete is ArmResourceDeleteWithoutOkAsync<Deployment>;

  @doc("List the deployment of the environment. The deployment is a singleton, so this returns at most one item.")
  listByEnvironment is ArmResourceListByParent<Deployment>;
}
