import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-resource-manager";
import "./common.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.SecurityContext;

/** A weakness observed in source code. */
@tenantResource
model CodeWeakness is ProxyResource<CodeWeaknessProperties, false> {
  /** The stable human-readable resource name: `{source-system-slug}--{source-record-slug}`. */
  @key("codeWeaknessName")
  @path
  @segment("codeWeaknesses")
  @visibility(Lifecycle.Read)
  @minLength(4)
  @maxLength(256)
  @pattern("^[a-z0-9]+(?:-[a-z0-9]+)*--[a-z0-9]+(?:-[a-z0-9]+)*$")
  name: string;
}

/** Properties of a code weakness observation. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "This read-only observation is computed by the service and is not provisioned through ARM."
model CodeWeaknessProperties {
  ...ObservationProperties;

  /** The identifier of the rule that detected the weakness. */
  @visibility(Lifecycle.Read)
  @minLength(1)
  @maxLength(256)
  ruleId: string;

  /** Standard weakness identifiers, such as CWE identifiers. */
  @visibility(Lifecycle.Read)
  @maxItems(32)
  weaknessIds: string[];

  /** The programming language reported by the source. */
  @visibility(Lifecycle.Read)
  @maxLength(128)
  language?: string;

  /** The source-control revision at which the weakness was observed. */
  @visibility(Lifecycle.Read)
  @maxLength(256)
  repositoryRevision?: string;

  /** A privacy-preserving SHA-256 hash of the repository-relative file path. */
  @visibility(Lifecycle.Read)
  @minLength(64)
  @maxLength(64)
  @pattern("^[0-9a-f]{64}$")
  relativePathHash?: string;

  /** The first one-based source line associated with the weakness. */
  @visibility(Lifecycle.Read)
  @minValue(1)
  startLine?: int32;

  /** The last one-based source line associated with the weakness. */
  @visibility(Lifecycle.Read)
  @minValue(1)
  endLine?: int32;
}

/** Read-only operations for code weakness observations. */
@armResourceOperations
interface CodeWeaknesses {
  /** Gets a code weakness observation. */
  get is ArmResourceRead<CodeWeakness>;

  /** Lists code weakness observations in the tenant. */
  list is ArmResourceListByParent<
    CodeWeakness,
    Azure.ResourceManager.Foundations.TenantBaseParameters
  >;
}
