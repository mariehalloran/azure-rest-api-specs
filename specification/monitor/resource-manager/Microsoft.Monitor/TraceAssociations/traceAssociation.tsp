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

namespace Microsoft.Monitor;

/** The name of a TraceAssociation singleton. Always `default`. Modeled as an extensible enum so the singleton constraint is expressed as an enum path parameter (RPC-ConstrainedCollections-V1-04) rather than a regex pattern. */
union TraceAssociationName {
  string,

  /** The default and only valid singleton name. */
  Default: "default",
}

/** A trace association extension resource that maps a scope to an Azure Monitor Workspace for trace routing. Each scope can have at most one direct association. Multi-homing is achieved through inheritance from parent scopes. */
model TraceAssociation is ExtensionResource<TraceAssociationProperties> {
  ...ResourceNameParameter<
    TraceAssociation,
    KeyName = "name",
    SegmentName = "traceAssociations",
    NamePattern = "",
    Type = TraceAssociationName
  >;
}

/** Properties of a trace association that maps a scope to an Azure Monitor Workspace. */
model TraceAssociationProperties {
  /** Resource ID of the target Azure Monitor Workspace. Must exist at creation time. */
  azureMonitorWorkspaceResourceId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Monitor/accounts";
    }
  ]>;

  /** The resource provisioning state. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@armResourceOperations
interface TraceAssociations {
  /** Returns the trace association for the specified scope. */
  get is ArmResourceRead<TraceAssociation>;

  /** Creates or updates a trace association for the specified scope. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<TraceAssociation>;

  /** Deletes the trace association for the specified scope. */
  delete is ArmResourceDeleteSync<TraceAssociation>;

  /** Lists trace associations for the specified scope. */
  listByScope is ArmResourceListByParent<TraceAssociation>;
}
