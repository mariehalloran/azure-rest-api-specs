import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.Proposal;

@added(Versions.v2026_05_01_preview)
@doc("A subscription-scoped BundleProviderHub resource")
model SubscriptionBundleResource
  is ProxyResource<SubscriptionBundleResourceProperties> {
  @doc("The name of the subscription bundle")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @key("name")
  @segment("subscriptionBundles")
  @path
  name: string;
}

@added(Versions.v2026_05_01_preview)
@doc("Details of the Subscription Bundle Item.")
model SubscriptionBundleResourceProperties {
  @visibility(Lifecycle.Read)
  @doc("The status of the last operation.")
  provisioningState?: ProvisioningState;

  @doc("The bundle product code.")
  productCode: string;

  @doc("The bundle status.")
  status?: ProposalStatus;

  @doc("The list of line items associated with the bundle.")
  @identifiers(#["productCode"])
  lineItems?: LineItem[];
}

@added(Versions.v2026_05_01_preview)
@armResourceOperations(SubscriptionBundleResource)
interface SubscriptionBundleResources {
  get is ArmResourceRead<SubscriptionBundleResource>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<SubscriptionBundleResource>;
  delete is ArmResourceDeleteSync<SubscriptionBundleResource>;
  listByResourceGroup is ArmResourceListByParent<SubscriptionBundleResource>;
}
