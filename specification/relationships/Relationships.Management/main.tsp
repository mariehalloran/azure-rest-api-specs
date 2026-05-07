import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

@armProviderNamespace
@service(#{ title: "Microsoft.Relationships Management Service" })
@doc("Microsoft.Relationships Resource Provider management API.")
@versioned(Versions)
namespace Microsoft.Relationships;

/** Relationships RP API Versions */
enum Versions {
  /** 2023-09-01-preview version */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  `2023-09-01-preview`,

  /** 2026-03-01-preview version */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  `2026-03-01-preview`,
}

/*
 * Base relationship types definitions
 */

@doc("Provides information about the relationship properties.")
model RelationshipMetadata {
  @doc("The type of the relationship source resource.")
  @visibility(Lifecycle.Read)
  sourceType: string;

  @doc("The type of the relationship target resource.")
  @visibility(Lifecycle.Read)
  targetType: string;
}

@doc("The possible origins of a relationship.")
union RelationshipOrigins {
  @doc("The relationship was explicitly created by a system.")
  ServiceExplicitlyCreated: "ServiceExplicitlyCreated",

  @doc("The relationship was discovered by a system-created rule.")
  SystemDiscoveredByRule: "SystemDiscoveredByRule",

  @doc("The relationship was explicitly created by a user.")
  UserExplicitlyCreated: "UserExplicitlyCreated",

  @doc("The relationship was discovered by a user-created rule.")
  UserDiscoveredByRule: "UserDiscoveredByRule",

  string,
}

@doc("Provides information about the origin of a relationship.")
model RelationshipOriginInformation {
  @doc("Identifies the origin type of the relationship.")
  @visibility(Lifecycle.Read)
  relationshipOriginType: RelationshipOrigins;

  @doc("The name of the discovery engine that created the relationship.")
  @visibility(Lifecycle.Read)
  discoveryEngine?: string;
}

@doc("The provisioning state of the resource.")
@lroStatus
union ProvisioningState {
  ResourceProvisioningState,

  /** The resource is being provisioned. */
  Provisioning: "Provisioning",

  /** The resource is being updated. */
  Updating: "Updating",

  /** The resource is being deleted. */
  Deleting: "Deleting",

  /** The resource provisioning request has been accepted. */
  Accepted: "Accepted",

  string,
}

@doc("Base relationship properties.")
model BaseRelationshipProperties<AllowedTargetResourceTypes extends ArmResourceIdentifierAllowedResource[] = never> {
  @doc("The relationship source resource id.")
  @visibility(Lifecycle.Read)
  @madeOptional(Versions.`2026-03-01-preview`)
  sourceId?: armResourceIdentifier;

  @doc("The relationship target resource id.")
  targetId: armResourceIdentifier<AllowedTargetResourceTypes>;

  @doc("The relationship target tenant id.")
  targetTenant?: string;

  @doc("Information about the origin of the relationship.")
  @visibility(Lifecycle.Read)
  @madeOptional(Versions.`2026-03-01-preview`)
  originInformation?: RelationshipOriginInformation;

  @doc("Metadata about the relationship.")
  @visibility(Lifecycle.Read)
  @madeOptional(Versions.`2026-03-01-preview`)
  metadata?: RelationshipMetadata;

  @doc("The provisioning state of the relationship.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/*
 * dependencyOf relationship type definition
 */

@doc("dependencyOf relationship properties.")
model DependencyOfRelationshipProperties is BaseRelationshipProperties;

@doc("Defines a dependencyOf relationship resource.")
model DependencyOfRelationship
  is ExtensionResource<DependencyOfRelationshipProperties> {
  @doc("Name of dependencyOf relationship.")
  @pattern("^[a-zA-Z0-9]{3,64}$")
  @visibility(Lifecycle.Read)
  @key
  @path
  @segment("dependencyOf")
  name: string;
}

/*
 * serviceGroupMember relationship type definition
 */

@doc("ServiceGroupMember relationship properties.")
model ServiceGroupMemberRelationshipProperties is BaseRelationshipProperties;

@doc("Defines a ServiceGroupMember relationship resource.")
model ServiceGroupMemberRelationship
  is ExtensionResource<ServiceGroupMemberRelationshipProperties> {
  @doc("Name of ServiceGroupMember relationship.")
  @pattern("^[a-zA-Z0-9]{3,64}$")
  @visibility(Lifecycle.Read)
  @key
  @path
  @segment("serviceGroupMember")
  name: string;
}

/*
 * memberOf relationship type definition
 */

@doc("memberOf relationship properties.")
@added(Versions.`2026-03-01-preview`)
model MemberOfRelationshipProperties
  is BaseRelationshipProperties<[
    {
      type: "Microsoft.Resources/subscriptions";
      scopes: ["Subscription"];
    },
    {
      type: "Microsoft.Resources/resourceGroups";
      scopes: ["ResourceGroup"];
    }
  ]>;

@doc("Defines a memberOf relationship resource.")
@added(Versions.`2026-03-01-preview`)
model MemberOfRelationship
  is ExtensionResource<MemberOfRelationshipProperties> {
  @doc("Name of memberOf relationship.")
  @pattern("^[a-zA-Z0-9]{3,64}$")
  @visibility(Lifecycle.Read)
  @key
  @path
  @segment("memberOf")
  name: string;
}

/*
 * Microsoft.Relationships RP interface definitions
 */

interface Operations extends Azure.ResourceManager.Operations {}

@armResourceOperations
interface DependencyOfRelationships {
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DependencyOfRelationship>;
  get is ArmResourceRead<DependencyOfRelationship>;
  delete is ArmResourceDeleteWithoutOkAsync<DependencyOfRelationship>;
  @added(Versions.`2026-03-01-preview`)
  listByParent is ArmResourceListByParent<DependencyOfRelationship>;
}

@armResourceOperations
interface ServiceGroupMemberRelationships {
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ServiceGroupMemberRelationship>;
  get is ArmResourceRead<ServiceGroupMemberRelationship>;
  delete is ArmResourceDeleteWithoutOkAsync<ServiceGroupMemberRelationship>;
  @added(Versions.`2026-03-01-preview`)
  listByParent is ArmResourceListByParent<ServiceGroupMemberRelationship>;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "MemberOfRelationships only has list operations — @armResourceOperations would apply @autoRoute which corrupts the manually specified route for the resource group scoped endpoint"
@added(Versions.`2026-03-01-preview`)
interface MemberOfRelationships {
  @doc("List MemberOfRelationship resources by subscription ID")
  listBySubscription is ArmListBySubscription<
    MemberOfRelationship,
    {
      @doc("Filters the results by source resource type. Example: properties.metadata.sourceType eq 'Microsoft.Compute/virtualMachines'")
      @query("$filter")
      filter?: string;

      @doc("The maximum number of results to return.")
      @query("$top")
      top?: int32;
    }
  >;

  @doc("List MemberOfRelationship resources by resource group")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Relationships/memberOf")
  @get
  @list
  listByResourceGroup(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    @doc("Filters the results by source resource type. Example: properties.metadata.sourceType eq 'Microsoft.Compute/virtualMachines'")
    @query("$filter")
    filter?: string,

    @doc("The maximum number of results to return.")
    @query("$top")
    top?: int32,
  ): ArmResponse<ResourceListResult<MemberOfRelationship>> | ErrorResponse;
}
