import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.BillingBenefits;

/**
 * A catalog group represents a BenefitResourceType + Namespace grouping used for benefit SKU discovery.
 */
@added(Versions.v2026_02_01)
model CatalogGroup
  is Azure.ResourceManager.ProxyResource<CatalogGroupProperties> {
  ...ResourceNameParameter<
    Resource = CatalogGroup,
    KeyName = "catalogGroupName",
    SegmentName = "catalogGroups",
    NamePattern = "^[a-zA-Z0-9_\\-\\.]+$"
  >;
}

/**
 * CatalogGroups operations.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "Extension resource with scope-based routes"
@added(Versions.v2026_02_01)
interface CatalogGroupsOperationGroup {
  /**
   * List catalog groups at a given scope. Supported scopes: subscriptions, billing accounts, billing profiles.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "Extension resource with scope-based routes"
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "x-ms-pageable required for list operations with custom routes"
  @extension("x-ms-pageable", #{ nextLinkName: "nextLink" })
  @route("/{scope}/providers/Microsoft.BillingBenefits/catalogGroups")
  @get
  list(
    ...ApiVersionParameter,

    /**
     * The scope at which the catalog groups are listed. Supported scopes: subscriptions/{subscriptionId}, providers/Microsoft.Billing/billingAccounts/{billingAccountId}, providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}.
     */
    #suppress "@azure-tools/typespec-azure-core/no-openapi" "x-ms-skip-url-encoding required for scope parameter"
    @extension("x-ms-skip-url-encoding", true)
    @path
    scope: string,
  ): ArmResponse<CatalogGroupList> | ErrorResponse;

  /**
   * Get a specific catalog group at a given scope.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "Extension resource with scope-based routes"
  @route("/{scope}/providers/Microsoft.BillingBenefits/catalogGroups/{catalogGroupName}")
  @get
  get(
    ...ApiVersionParameter,

    /**
     * The scope at which the catalog group is retrieved.
     */
    #suppress "@azure-tools/typespec-azure-core/no-openapi" "x-ms-skip-url-encoding required for scope parameter"
    @extension("x-ms-skip-url-encoding", true)
    @path
    scope: string,

    /**
     * The name of the catalog group (e.g., reservations.VirtualMachines, credits.default).
     */
    @pattern("^[a-zA-Z0-9_\\-\\.]+$")
    @path
    catalogGroupName: string,
  ): ArmResponse<CatalogGroup> | ErrorResponse;
}
