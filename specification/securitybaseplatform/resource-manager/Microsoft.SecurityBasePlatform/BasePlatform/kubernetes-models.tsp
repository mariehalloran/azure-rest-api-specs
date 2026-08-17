import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;

namespace Microsoft.SecurityBasePlatform;

@doc("A user node pool for auto-provisioned cluster capacity.")
model NodePool {
  @doc("Workload-oriented node pool name (e.g. gpu-training, analytics, highmem).")
  @pattern("^[a-z0-9]([a-z0-9-]{0,38}[a-z0-9])?$")
  name: string;

  @doc("Eligible VM SKU series for this pool.")
  skuSeries: NodeSkuSeries[];

  @doc("Capacity types the pool may use. Defaults to on-demand.")
  capacityType?: NodeCapacityType[];

  @doc("Scheduling preference; higher is preferred. Use descending unique values across pools.")
  @minValue(11)
  weight: int32;

  @doc("Taints applied to nodes in this pool.")
  @identifiers(#["key"])
  taints?: NodeTaint[];

  @doc("Labels applied to nodes in this pool, formatted as Kubernetes label assignments such as `workload=gpu`.")
  labels?: string[];
}

@doc("Supported VM SKU series for auto-provisioned node pools.")
union NodeSkuSeries {
  string,

  @doc("D-series general purpose SKU family, version 5.")
  DasV5: "Das_v5",

  @doc("E-series memory optimized SKU family, version 6.")
  EasV6: "Eas_v6",

  @doc("N-series GPU SKU family, NCads version 5.")
  NCadsV5: "NCads_v5",
}

@doc("Capacity type for node provisioning.")
union NodeCapacityType {
  string,

  @doc("On-demand capacity.")
  OnDemand: "on-demand",

  @doc("Spot capacity.")
  Spot: "spot",
}

@doc("A Kubernetes taint applied to nodes.")
model NodeTaint {
  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "'key' is a Kubernetes taint key (a scheduling identifier), not a credential or secret."
  @doc("Taint key.")
  key: string;

  @doc("Taint value.")
  value?: string;

  @doc("Taint effect.")
  effect: TaintEffect;
}

@doc("Effect of a node taint.")
union TaintEffect {
  string,

  @doc("Pods that do not tolerate the taint are not scheduled.")
  NoSchedule: "NoSchedule",

  @doc("Scheduler avoids placing non-tolerating pods on the node.")
  PreferNoSchedule: "PreferNoSchedule",

  @doc("Non-tolerating pods are evicted from the node.")
  NoExecute: "NoExecute",
}
