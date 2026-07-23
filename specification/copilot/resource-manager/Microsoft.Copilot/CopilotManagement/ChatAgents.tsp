import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.Copilot;

@doc("A resource-group-scoped chat agent under Microsoft.Copilot. Supports managed identity for autonomous workload execution.")
model ChatAgentResource is TrackedResource<ChatAgentProperties> {
  @doc("The name of the chat agent.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-_]{2,63}$")
  @key("chatAgentName")
  @segment("chatAgents")
  @path
  name: string;

  ...ManagedServiceIdentityProperty;
}

@armResourceOperations
interface ChatAgents {
  get is ArmResourceRead<ChatAgentResource>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ChatAgentResource>;
  update is ArmCustomPatchSync<ChatAgentResource, ChatAgentUpdate>;
  delete is ArmResourceDeleteSync<ChatAgentResource>;
  listByResourceGroup is ArmResourceListByParent<ChatAgentResource>;
  listBySubscription is ArmListBySubscription<ChatAgentResource>;
}
