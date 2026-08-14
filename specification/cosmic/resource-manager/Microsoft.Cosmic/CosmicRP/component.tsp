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

@doc("A Component resource representing an independently-deployable part of the app that the parent namespace identifies. Each component owns its own revision lineage, rollout, and rollback.")
@parentResource(Namespace)
model Component is TrackedResource<ComponentProperties> {
  @doc("The name of the component.")
  @key("componentName")
  @segment("components")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @minLength(1)
  @maxLength(63)
  @path
  name: string;
}

@doc("Properties of a Component resource.")
model ComponentProperties {
  @doc("Whether the component carries deployable code or a configuration feature. Set at create and immutable thereafter; every revision under the component inherits this kind.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  componentKind: ComponentKind;

  @doc("The provisioning state of the component resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: CosmicProvisioningState;
}

@armResourceOperations
interface Components {
  get is ArmResourceRead<Component>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<Component>;

  @doc("Update the tags of a component. Component properties are immutable; only tags may be patched.")
  update is ArmTagsPatchSync<Component>;

  delete is ArmResourceDeleteSync<Component>;
  listByNamespace is ArmResourceListByParent<Component>;
}
