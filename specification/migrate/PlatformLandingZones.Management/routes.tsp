import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "./Common/ArmModels/PlatformLandingZone.tsp";
import "./Common/ArmModels/BillOfMaterials.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

@armResourceOperations
interface PlatformLandingZones {
  @doc("Get a Platform Landing Zone resource by name.")
  get is ArmResourceRead<PlatformLandingZone>;

  @doc("Create or update a Platform Landing Zone resource.")
  create is ArmResourceCreateOrUpdateAsync<PlatformLandingZone>;

  @doc("List Platform Landing Zone resources under a migrate project.")
  listByParent is ArmResourceListByParent<PlatformLandingZone>;

  @doc("Delete a Platform Landing Zone resource.")
  delete is ArmResourceDeleteWithoutOkAsync<PlatformLandingZone>;
}

@armResourceOperations
interface BillOfMaterialsOperations {
  @doc("Get the Bill of Materials for a Platform Landing Zone.")
  get is ArmResourceRead<BillOfMaterials>;
}
