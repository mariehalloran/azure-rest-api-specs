// Subscription-level operations that are not tied to a specific ARM resource

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Microsoft.WebIQ;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Subscription-level SKU listing is not tied to a specific ARM resource"
interface SkusOperationGroup {
  /**
   * Gets the list of Microsoft.WebIQ SKUs available for the subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "Required for x-ms-pageable extension on list operation"
  @autoRoute
  @get
  @list
  @action("skus")
  list is ArmProviderActionSync<
    Response = ResourceSkusResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;

  /**
   * Check whether specific SKUs are available for the location.
   */
  @autoRoute
  @action("checkSkuAvailability")
  checkAvailability is ArmProviderActionSync<
    Request = CheckSkuAvailabilityParameter,
    Response = CheckSkuAvailabilityResultList,
    Scope = SubscriptionActionScope,
    Parameters = LocationParameter
  >;
}
