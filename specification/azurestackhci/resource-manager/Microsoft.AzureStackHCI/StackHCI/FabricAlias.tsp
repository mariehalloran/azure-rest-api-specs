import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./StorageFabric.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Fabric Alias Resource (PRIVATE PREVIEW) ====================
//
// `fabricAliases` is a proxy child of `storageFabrics` — a named set of WWNs.
// PRIVATE PREVIEW: GET and LIST are read-only; PUT (createOrUpdate) is also
// exposed.

/**
 * A fabric alias — a named set of WWNs defined on the fabric switch.
 */
@added(Versions.v2026_03_15_preview)
@parentResource(StorageFabric)
model FabricAlias
  is Azure.ResourceManager.ProxyResource<FabricAliasProperties> {
  ...ResourceNameParameter<
    Resource = FabricAlias,
    KeyName = "fabricAliasName",
    SegmentName = "fabricAliases",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for fabric aliases. GET and LIST are read-only; PUT (createOrUpdate)
 * edits the settings.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" "Fabric aliases are discovered from the storage fabric and cannot be created or deleted through ARM; PUT only edits the settings of an existing fabric alias."
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface FabricAliases {
  /** Get a fabric alias. */
  get is ArmResourceRead<FabricAlias>;

  /** List fabric aliases on a storage fabric. */
  list is ArmResourceListByParent<FabricAlias>;

  /** Create or update a fabric alias. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<FabricAlias>;
}
