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
@doc("A tenant-scoped BundleProviderHub resource")
@tenantResource
model TenantBundleResource is ProxyResource<TenantBundleResourceProperties> {
  @doc("The name of the tenant bundle")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @key("name")
  @segment("tenantBundles")
  @path
  name: string;
}

@added(Versions.v2026_05_01_preview)
@doc("Details of the Tenant Bundle Item.")
model TenantBundleResourceProperties {
  @visibility(Lifecycle.Read)
  @doc("The status of the last operation.")
  provisioningState?: ProvisioningState;

  @doc("The bundle product code.")
  productCode: string;

  @doc("The billing scope to use for purchasing the resource. Needs full billing scope to invoice section level like: providers/Microsoft.Billing/billingAccounts/{baId}/billingProfiles/{bfId}/invoiceSections/{isId}")
  billingScope: string;

  @doc("The bundle status.")
  status?: ProposalStatus;

  @doc("The list of line items associated with the bundle.")
  @identifiers(#["productCode"])
  lineItems?: LineItem[];
}

@added(Versions.v2026_05_01_preview)
@armResourceOperations(TenantBundleResource)
interface TenantBundleResources {
  get is ArmResourceRead<TenantBundleResource>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<TenantBundleResource>;
  delete is ArmResourceDeleteSync<TenantBundleResource>;
}
