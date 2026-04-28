import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "@typespec/versioning";
import "./models.tsp";
import "./StorageSite.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.ApplicationMigration;

/**
 * The NAS resource definition.
 */
@added(Versions.v2026_05_01_preview)
@parentResource(StorageSite)
model Nas is Azure.ResourceManager.ProxyResource<NasProperties, false> {
  ...ResourceNameParameter<
    Resource = Nas,
    KeyName = "nasName",
    SegmentName = "nas",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9-]*$"
  >;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "NAS is an acronym"
@added(Versions.v2026_05_01_preview)
@armResourceOperations
interface NAS {
  /**
   * Gets the NAS resource.
   */
  get is ArmResourceRead<Nas>;

  /**
   * Puts the NAS resource.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<Nas>;

  /**
   * Patch the NAS resource.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<Nas, NasResourcePatchProperties>;

  /**
   * Deletes the NAS resource.
   */
  delete is ArmResourceDeleteSync<Nas>;

  /**
   * Lists the NAS resources in StorageSites.
   */
  listBySite is ArmResourceListByParent<Nas, Response = ArmResponse<NasList>>;
}

@@maxLength(Nas.name, 100);
@@minLength(Nas.name, 3);
@@doc(Nas.name, "The name of NAS device");
@@doc(Nas.properties, "Resource properties.");
@@doc(NAS.createOrUpdate::parameters.resource,
  "The NAS resource to create or update."
);
@@doc(NAS.update::parameters.properties, "NAS patch payload.");
