import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "@azure-tools/typespec-azure-resource-manager";
import "./SaasResourceModels.tsp";
import "./CloudServiceModels.tsp";
import "@typespec/versioning";
import "./SharedModels.tsp";
import "./SaasResource.tsp";
import "./CloudService.tsp";
import "./versions.tsp";

using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;
using TypeSpec.Rest;
using TypeSpec.Versioning;

namespace Microsoft.SaaSHub;

@armResourceOperations
interface ProviderLevelActions {
  /**
   * Evaluates whether the request payload can create a new SaaS resource.
   * Not available in API versions 2023-01-01-preview.
   */
  @route("/providers/Microsoft.SaaSHub")
  @post
  @armResourceAction(Microsoft.SaaSHub.SaasResource)
  tenantLevelCanCreate(
    ...ApiVersionParameter,

    /**
     * Request parameters that are provided to the create SaaSHub SaaS resource operation.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.CanCreateSaasResourceRequest,
  ): ArmResponse<Microsoft.SaaSHub.CanCreateResult> | ErrorResponse;

  /**
   * Evaluates customer eligibility for promotions on one or more products.
   * Only available starting in API version 2026-03-31-preview.
   */
  @added(SaaSHubVersions.v2026_03_31_preview)
  @route("/providers/Microsoft.SaaSHub/validatePromotions")
  @post
  @tag("ProviderLevelActions")
  validatePromotions(
    ...ApiVersionParameter,

    /**
     * Request parameters containing products to evaluate for promotion eligibility.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.ValidatePromotionsRequest,
  ): ArmResponse<Microsoft.SaaSHub.ValidatePromotionsResponse> | ErrorResponse;

  /**
   * Evaluates customer eligibility for one or more add-ons.
   * Only available starting in API version 2026-03-31-preview.
   */
  @added(SaaSHubVersions.v2026_03_31_preview)
  @route("/providers/Microsoft.SaaSHub/validateAddOnEligibility")
  @post
  @tag("ProviderLevelActions")
  validateAddOnEligibility(
    ...ApiVersionParameter,

    /**
     * Request parameters containing add-ons to evaluate for eligibility.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.ValidateAddOnEligibilityRequest,
  ):
    | ArmResponse<Microsoft.SaaSHub.ValidateAddOnEligibilityResponse>
    | ErrorResponse;

  /**
   * Evaluates customer eligibility for promotional renewal pricing on the purchase line items
   * in a quote, cart or order for a customer who is renewing their agreement or contract.
   * Only available starting in API version 2026-03-31-preview.
   */
  @added(SaaSHubVersions.v2026_03_31_preview)
  @route("/providers/Microsoft.SaaSHub/validateRenewalPricingEligibility")
  @post
  @tag("ProviderLevelActions")
  validateRenewalPricingEligibility(
    ...ApiVersionParameter,

    /**
     * Request parameters containing purchase line items to evaluate for promotional renewal pricing.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.ValidateRenewalPricingEligibilityRequest,
  ):
    | ArmResponse<Microsoft.SaaSHub.ValidateRenewalPricingEligibilityResponse>
    | ErrorResponse;

  /**
   * Evaluates whether customers qualify for future price concessions when purchasing Microsoft 365 products.
   * On each evaluated product, hydrates the catalog product SKU for the constraints and checks whether
   * the sum of new and existing resources would meet the requirements for concessions.
   * Only available starting in API version 2026-03-31-preview.
   */
  @added(SaaSHubVersions.v2026_03_31_preview)
  @route("/providers/Microsoft.SaaSHub/validateFuturePriceEligibility")
  @post
  @tag("ProviderLevelActions")
  validateFuturePriceEligibility(
    ...ApiVersionParameter,

    /**
     * Request parameters containing products to evaluate for future price eligibility.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.ValidateFuturePriceEligibilityRequest,
  ):
    | ArmResponse<Microsoft.SaaSHub.ValidateFuturePriceEligibilityResponse>
    | ErrorResponse;

  /**
   * Returns customer-owned SaaS resources that are eligible for consolidation to a target product.
   * Only available starting in API version 2026-03-31-preview.
   */
  @added(SaaSHubVersions.v2026_03_31_preview)
  @route("/providers/Microsoft.SaaSHub/listConsolidableResources")
  @post
  @list
  @tag("ProviderLevelActions")
  listConsolidableResources(
    ...ApiVersionParameter,

    /**
     * Request payload containing target SKU and scope for consolidation discovery.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.ListConsolidableResourcesRequest,
  ):
    | ArmResponse<Microsoft.SaaSHub.ListConsolidableResourcesResponse>
    | ErrorResponse;

  /**
   * Gets coterm end dates for multiple resources at tenant level.
   * Only available in API version 2025-07-01-preview.
   */
  @renamedFrom(
    SaaSHubVersions.v2025_07_01_preview,
    "tenantLevelGetCotermEndDates"
  )
  @removed(SaaSHubVersions.v2026_03_31_preview)
  @sharedRoute
  @route("/providers/Microsoft.SaaSHub/tenantLevelCoterminousDates")
  @post
  @tag("ProviderLevelActions")
  tenantLevelGetCotermEndDates(
    ...ApiVersionParameter,

    /**
     * Request parameters that are provided to the GetCotermEndDates operation.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.CotermEndDatesRequest,
  ): ArmResponse<Microsoft.SaaSHub.CotermResponseItem[]> | ErrorResponse;

  /**
   * Gets coterm end dates for multiple resources at tenant level.
   * Only available starting in API version 2026-03-31-preview.
   */
  @added(SaaSHubVersions.v2026_03_31_preview)
  @sharedRoute
  @route("/providers/Microsoft.SaaSHub/tenantLevelCoterminousDates")
  @post
  @tag("ProviderLevelActions")
  tenantLevelGetCotermEndDatesBulk(
    ...ApiVersionParameter,

    /**
     * Request parameters that are provided to the GetCotermEndDates operation.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.CotermEndDatesRequest,
  ):
    | ArmResponse<Microsoft.SaaSHub.CotermResponseItemBulkResponse>
    | ErrorResponse;

  /**
   * Evaluates whether multiple transaction requests can be processed at tenant level.
   * Only available starting in API version 2025-07-01-preview.
   */
  @route("/providers/Microsoft.SaaSHub/tenantLevelCanTransact")
  @post
  @tag("ProviderLevelActions")
  tenantLevelCanTransact(
    ...ApiVersionParameter,

    /**
     * Request parameters that are provided to the tenant level canTransact operation.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.TenantLevelCanTransactBulkRequest,
  ):
    | ArmResponse<Microsoft.SaaSHub.TenantLevelCanTransactBulkResponse>
    | ErrorResponse;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Resource group level provider actions don't follow standard ARM resource patterns"
@removed(SaaSHubVersions.v2026_03_31_preview)
interface ResourceGroupLevelProviderActions {
  /**
   * Evaluates whether the request payload can create a new cloud service resource.
   * Only available starting in API version 2025-07-01-preview.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SaaSHub/canCreate")
  @tag("ResourceGroupLevelProviderActions")
  @post
  canCreate(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Request parameters that are provided to the create SaaSHub cloud service operation.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.CanCreateCloudServiceRequest,
  ): ArmResponse<Microsoft.SaaSHub.CanCreateResult> | ErrorResponse;

  /**
   * Gets coterm end dates for multiple resources at resource group level.
   * Only available in API version 2025-07-01-preview.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SaaSHub/coterminousDates")
  @tag("ResourceGroupLevelProviderActions")
  @post
  getCotermEndDates(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Request parameters that are provided to the GetCotermEndDates operation.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.CotermEndDatesRequest,
  ): ArmResponse<Microsoft.SaaSHub.CotermResponseItem[]> | ErrorResponse;

  /**
   * Evaluates whether multiple transaction requests can be processed at resource group level.
   * Only available in API version 2025-07-01-preview.
   */
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SaaSHub/canTransact")
  @tag("ResourceGroupLevelProviderActions")
  @post
  canTransact(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * Request parameters that are provided to the resource group level canTransact operation.
     */
    @bodyRoot
    body: Microsoft.SaaSHub.ResourceGroupLevelCanTransactBulkRequest,
  ):
    | ArmResponse<Microsoft.SaaSHub.ResourceGroupLevelCanTransactBulkResponse>
    | ErrorResponse;
}
