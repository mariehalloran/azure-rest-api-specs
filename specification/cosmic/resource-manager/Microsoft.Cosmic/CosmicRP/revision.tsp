import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./component.tsp";

using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace Microsoft.Cosmic;

@doc("A Revision resource representing an immutable, digest-pinned artifact version of its parent component. A revision carries no scope; where it is applied is governed by an environment's deployment resource.")
@parentResource(Component)
model Revision is TrackedResource<RevisionProperties> {
  @doc("The name of the revision. Caller-chosen and authored by the orchestrator; the RP does not generate revision names.")
  @key("revisionName")
  @segment("revisions")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @minLength(1)
  @maxLength(63)
  @path
  name: string;
}

@doc("Properties of a Revision resource. All spec properties are immutable once the revision is created.")
model RevisionProperties {
  @doc("Digest-pinned reference to the deployable artifact. Content is opaque to the RP, which records the reference as metadata and never dereferences it. Tag-only or version-only references are rejected.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  @minLength(1)
  artifactReference: string;

  @doc("Container-image digests the artifact references, declared by the orchestrator at publish. Metadata only - the RP validates digest-pinning and never pulls, copies, or otherwise dereferences them. Empty when the artifact references no container image.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  @identifiers(#["reference"])
  images?: ImageReference[];

  @doc("Source metadata describing where this revision came from.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  provenance?: RevisionProvenance;

  @doc("The referential state of the revision.")
  @visibility(Lifecycle.Read)
  status?: RevisionStatus;

  @doc("The provisioning state of the revision resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: CosmicProvisioningState;
}

@armResourceOperations
interface Revisions {
  get is ArmResourceRead<Revision>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<Revision>;

  @doc("Update the tags of a revision. Revision spec properties are immutable; only tags may be patched.")
  update is ArmTagsPatchSync<Revision>;

  delete is ArmResourceDeleteSync<Revision>;
  listByComponent is ArmResourceListByParent<Revision>;
}
