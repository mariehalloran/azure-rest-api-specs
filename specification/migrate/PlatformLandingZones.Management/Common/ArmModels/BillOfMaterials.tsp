import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "./PlatformLandingZone.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

@parentResource(PlatformLandingZone)
@singleton("default")
@doc("Bill of Materials for a Platform Landing Zone. A read-only, cost-bearing inventory of the Azure resources implied by the parent landing zone design, aggregated by (resourceType, sku, location).")
model BillOfMaterials is ProxyResource<BillOfMaterialsProperties> {
  @doc("Bill of Materials name. Only the singleton value 'default' is supported.")
  @segment("billOfMaterials")
  @key("billOfMaterialsName")
  @path
  @pattern("^default$")
  name: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Bill of Materials is a read-only projection derived from the parent Platform Landing Zone; it has no independent lifecycle and therefore no provisioning state."
@doc("Properties of the Bill of Materials. Generated as part of the parent Platform Landing Zone's async PUT; to refresh prices, re-PUT the parent. While the parent is Creating with no prior success, GET returns 404; while Updating/Failed/Canceled after at least one successful generation, GET returns the previous Bill of Materials.")
model BillOfMaterialsProperties {
  @visibility(Lifecycle.Read)
  @doc("ISO-4217 currency for all amounts in this Bill of Materials. Echoed from the parent Platform Landing Zone's costManagement.currency.")
  @pattern("^[A-Z]{3}$")
  currency: string;

  @visibility(Lifecycle.Read)
  @doc("Total estimated monthly cost across all items, in the declared currency.")
  @minValue(0)
  totalEstimatedMonthlyCost: decimal128;

  @visibility(Lifecycle.Read)
  @doc("Aggregated Bill of Materials line items.")
  @identifiers(#["resourceType", "sku", "location"])
  items: BillOfMaterialsItem[];
}

@doc("A single aggregated line item in the Bill of Materials. Identical resources across subscriptions/spokes are collapsed into a single row whose quantity reflects the multiplicity.")
model BillOfMaterialsItem {
  @doc("ARM resource type, for example 'Microsoft.KeyVault/vaults'.")
  resourceType: string;

  @doc("SKU of the resource, for example 'standard' or 'Standard_D2s_v5'.")
  sku: string;

  @doc("Azure region for this aggregated row.")
  location: string;

  @doc("Number of resources of this (resourceType, sku, location) implied by the landing zone design.")
  @minValue(1)
  quantity: int32;

  @doc("Estimated total monthly cost for this row in the declared currency (line total = unit price x quantity).")
  @minValue(0)
  estimatedMonthlyCost: decimal128;
}
