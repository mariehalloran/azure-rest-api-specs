import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.SecurityBasePlatform;

// ---------------------------------------------------------------------------
// Kubernetes-specific escape hatch.
//
// Everything in this file is backend-specific: it applies only when the
// compute backend is Kubernetes and is ignored (or rejected) by other
// backends.
//
// - Cluster-level K8s config is discriminated: it lives directly on
//   Dk8sClusterProperties (the Dk8s subtype), which references the node-pool
//   models below.
// - Workload-level scheduling is exposed through the first-class `placement`
//   block so Service/Job/CronJob do not grow a backend-named wrapper.
//
// Do NOT add fields here that could be expressed neutrally.
// ---------------------------------------------------------------------------

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
  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "The property contains a Kubernetes label key, not a secret."
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

@doc("Placement and scheduling constraints for a workload.")
model PlacementConfig {
  @doc("Node labels that the workload must match.")
  nodeSelector?: StringMap;

  @doc("Node affinity scheduling preferences and requirements.")
  nodeAffinity?: NodeAffinityConfig;

  @doc("""
    Taint tolerations that allow the workload to schedule onto tainted nodes.
    
    Example for GPU nodes:
    ```json
    [
      {
        "key": "gpu",
        "operator": "Equal",
        "value": "true",
        "effect": "NoSchedule"
      }
    ]
    ```
    """)
  @identifiers(#["key"])
  tolerations?: Toleration[];
}

@doc("Node affinity scheduling constraints.")
model NodeAffinityConfig {
  @doc("Preferred node selector terms.")
  @identifiers(#[])
  preferredDuringSchedulingIgnoredDuringExecution?: PreferredNodeSelectorTerm[];

  @doc("Required node selector terms.")
  requiredDuringSchedulingIgnoredDuringExecution?: RequiredNodeSelectorTerms;
}

@doc("Preferred node selector term.")
model PreferredNodeSelectorTerm {
  @doc("Weight for this preference, from 1 to 100.")
  @minValue(1)
  @maxValue(100)
  weight: int32;

  @doc("Node selector term for this preference.")
  preference: NodeSelectorTerm;
}

@doc("Required node selector terms.")
model RequiredNodeSelectorTerms {
  @doc("Required selector terms. Terms are ORed; expressions inside a term are ANDed.")
  @identifiers(#[])
  nodeSelectorTerms: NodeSelectorTerm[];
}

@doc("Node selector term.")
model NodeSelectorTerm {
  @doc("Node selector match expressions.")
  @identifiers(#["label"])
  matchExpressions: NodeSelectorRequirement[];
}

@doc("Node selector requirement.")
model NodeSelectorRequirement {
  @doc("Node label key.")
  @encodedName("application/json", "key")
  label: string;

  @doc("Match operator.")
  operator: NodeAffinityOperator;

  @doc("Values for the match operator.")
  values?: string[];
}

@doc("Node affinity match operator exposed by ConfigGen.")
union NodeAffinityOperator {
  string,

  @doc("Node label value must be in the provided values.")
  In: "In",
}

@doc("A toleration that allows a workload to schedule onto nodes with a matching taint.")
model Toleration {
  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "The property contains a Kubernetes taint key, not a secret."
  @doc("Key of the taint to tolerate.")
  key?: string;

  @doc("How the key is matched against the taint. Defaults to Equal.")
  operator?: TolerationOperator;

  @doc("Value of the taint to match when the operator is Equal.")
  value?: string;

  @doc("Taint effect to tolerate. When omitted, tolerates all effects for the key.")
  effect?: TaintEffect;
}

@doc("Match operator for a toleration.")
union TolerationOperator {
  string,

  @doc("Tolerate a taint whose key and value both match.")
  Equal: "Equal",

  @doc("Tolerate any taint with the given key, regardless of value.")
  Exists: "Exists",
}

@doc("Restart policy.")
union RestartPolicy {
  string,

  @doc("Always restart the container regardless of exit status.")
  Always: "Always",

  @doc("Restart the container only when it exits with a non-zero status.")
  OnFailure: "OnFailure",

  @doc("Never restart the container.")
  Never: "Never",
}
