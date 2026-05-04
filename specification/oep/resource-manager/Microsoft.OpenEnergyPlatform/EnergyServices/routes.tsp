// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Microsoft.OpenEnergyPlatform;

@armResourceOperations
interface LocationsOperationGroup {
  /**
   * Checks the name availability of the resource with requested resource name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Preserve manual operationId for backward compatibility."
  @operationId("Locations_CheckNameAvailability")
  @autoRoute
  checkNameAvailability is ArmProviderActionSync<
    Request = Azure.ResourceManager.CommonTypes.CheckNameAvailabilityRequest,
    Response = Azure.ResourceManager.CommonTypes.CheckNameAvailabilityResponse,
    Scope = SubscriptionActionScope
  >;
}
