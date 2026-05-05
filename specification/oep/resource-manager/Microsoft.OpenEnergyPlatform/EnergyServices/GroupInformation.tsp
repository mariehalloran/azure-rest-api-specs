import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./EnergyService.tsp";

using TypeSpec.Rest;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.OpenEnergyPlatform;
/**
 * The group information for creating a private endpoint on an Account
 */
@parentResource(EnergyService)
model GroupInformation
  is Azure.ResourceManager.ProxyResource<GroupInformationProperties, false> {
  ...ResourceNameParameter<
    Resource = GroupInformation,
    KeyName = "groupId",
    SegmentName = "privateLinkResources",
    NamePattern = ""
  >;
}

/**
 * The available private link resources for an Account
 */
model PrivateLinkResourceListResult {
  /**
   * The list of available private link resources for an Account
   */
  @pageItems
  value?: GroupInformation[];

  /**
   * The URI that can be used to request the next list of private link resources.
   */
  @nextLink
  nextLink?: string;
}

@armResourceOperations
interface PrivateLinkResources {
  /**
   * Get the specified private link resource associated with the OAK instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PrivateLinkResources_Get")
  get is ArmResourceRead<GroupInformation>;

  /**
   * List all private link resources in a OAK instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/casing-style" "Preserving existing operationId casing (OAK acronym)."
  @operationId("PrivateLinkResources_ListByOAKInstance")
  listByOAKInstance is ArmResourceListByParent<
    GroupInformation,
    Response = ArmResponse<PrivateLinkResourceListResult>
  >;
}

@@doc(GroupInformation.name, "The group ID of the private link resource.");
@@doc(GroupInformation.properties,
  "The properties for a group information object"
);
