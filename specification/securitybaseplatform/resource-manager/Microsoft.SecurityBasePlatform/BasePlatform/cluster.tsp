import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./shared-models.tsp";
import "./workspace.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.SecurityBasePlatform;

@doc("""
  Represents a Cluster - the platform's compute environment abstraction.
  
  A Cluster abstracts a unit of compute capacity onto which workloads
  (Services, Jobs, CronJobs) are scheduled. Today the only backing kind is
  Kubernetes (see `clusterKind`), but the resource is modeled so additional
  compute backends can be introduced without changing the workload contract.
  Backend-specific settings are isolated under the optional `kubernetes` block.
  """)
model Cluster is TrackedResource<ClusterProperties> {
  @doc("The name of the Cluster.")
  @key("clusterName")
  @segment("clusters")
  @pattern("^[a-z0-9]([-a-z0-9]{1,22}[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "SKU is part of the established resource envelope."
  @doc("The SKU for this cluster.")
  sku?: ClusterSku;
}

@doc("Represents the SKU for a Cluster.")
model ClusterSku {
  @doc("The SKU name.")
  name: ClusterSkuName;
}

@doc("Represents the SKU name for a Cluster.")
union ClusterSkuName {
  string,

  @doc("A fully managed cluster SKU where infrastructure is managed by the platform.")
  FullyManaged: "FullyManaged",

  @doc("A customizable cluster SKU allowing user-defined node pool configurations.")
  Customizable: "Customizable",
}

scalar WorkspaceResourceId
  extends Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.SecurityBasePlatform/workspaces",
    }
  ]>;

@doc("Properties of the Cluster.")
@discriminator("clusterKind")
model ClusterProperties {
  @doc("The resource ID of the Workspace.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  workspaceId: WorkspaceResourceId;

  @doc("The kind of this cluster.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  clusterKind: ClusterKind;

  @doc("Default observability settings inherited by namespaces and workloads unless overridden at a lower scope.")
  observability?: ObservabilityConfiguration;

  @doc("Networking configuration.")
  networkConfig?: NetworkingConfig;

  @doc("Ingress configuration for the cluster. When omitted or disabled, the cluster has no ingress.")
  ingress?: ClusterIngressConfig;

  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @visibility(Lifecycle.Read)
  @doc("Configuration of the managed resource group associated with the resource.")
  managedResourceGroupConfiguration?: ManagedResourceGroupConfiguration;

  @visibility(Lifecycle.Read)
  @doc("Managed On Behalf Of Configuration.")
  managedOnBehalfOfConfiguration?: CommonTypes.ManagedOnBehalfOfConfiguration;
}

@doc("Properties for a Dk8s (dedicated Kubernetes) Cluster.")
model Dk8sClusterProperties extends ClusterProperties {
  @doc("The kind of this cluster.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  clusterKind: ClusterKind.Dk8s;
}

@doc("Represents the kind of a Cluster.")
union ClusterKind {
  string,

  @doc("A Dk8s (dedicated Kubernetes) cluster kind.")
  Dk8s: "Dk8s",
}

@doc("""
  Cluster-level default observability configuration.
  
  These settings are inherited by namespaces in the cluster unless the Namespace
  resource supplies its own `observability` override. Workloads can still provide
  narrower workload-level observability overrides.
  """)
model ObservabilityConfiguration {
  @doc("Telemetry account/destination for metrics emitted by this cluster.")
  metricsAccount?: string;

  @doc("Telemetry account/destination for logs and traces emitted by this cluster.")
  logsAccount?: string;

  ...ObservabilityDefaults;
}

@doc("Networking configuration.")
model NetworkingConfig {
  @doc("The service tag used to identify the cluster's egress NAT IP addresses. Always applied; defaults per-region if omitted.")
  egressIpTag?: string;

  @doc("The service tag used to identify the cluster's network. Always applied; defaults per-region if omitted.")
  networkIdentifierIpTag?: string;
}

@doc("""
  Cluster-level ingress configuration.
  
  Ingress must be enabled here before any Service in the cluster can be exposed
  with `Public` visibility; a `Public` Service in a cluster without ingress
  enabled is rejected at provisioning time.
  """)
model ClusterIngressConfig {
  @doc("Whether the platform provisions ingress (controller and public IP / load balancer) for this cluster. Defaults to false.")
  enabled?: boolean;

  @doc("The service tag stamped on the ingress public IP. Only relevant when ingress is enabled.")
  ipTag?: string;
}

@armResourceOperations(Cluster)
interface Clusters {
  get is ArmResourceRead<Cluster>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Cluster>;
  update is ArmCustomPatchAsync<Cluster, ClusterUpdate>;
  delete is ArmResourceDeleteWithoutOkAsync<Cluster>;
  listByResourceGroup is ArmResourceListByParent<Cluster>;
  listBySubscription is ArmListBySubscription<Cluster>;
}
