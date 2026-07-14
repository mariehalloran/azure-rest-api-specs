import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./shared-models.tsp";
import "./cluster.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.SecurityBasePlatform;

@doc("""
  Represents a Namespace within a Cluster.
  
  A Namespace is the platform's isolation and tenancy boundary for workloads:
  Services, Jobs, and CronJobs are created within a Namespace. On a Kubernetes
  backend this maps to a Kubernetes namespace, but the concept is intended to
  remain the isolation unit regardless of the backing compute kind.
  """)
@parentResource(Cluster)
model Namespace is TrackedResource<NamespaceProperties> {
  @doc("The name of the Namespace.")
  @key("namespaceName")
  @segment("namespaces")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@doc("Properties of the Namespace.")
model NamespaceProperties {
  @doc("Observability overrides for this namespace. Omitted settings inherit from the parent cluster observability defaults.")
  observability?: NamespaceObservability;

  @doc("Named storage definitions available to workloads in this namespace.")
  @identifiers(#["name"])
  storageDefinitions?: NamespaceStorageDefinition[];

  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("""
  Namespace-level observability configuration.
  
  Omitted settings inherit from the parent Cluster `observability` defaults.
  Workloads in this namespace inherit these settings unless they provide their
  own workload-level `observability` override.
  """)
model NamespaceObservability {
  @doc("Telemetry namespace (table set) for metrics within the cluster's metrics account.")
  metricsNamespace?: string;

  @doc("Telemetry namespace (table set) for logs and traces within the cluster's logs account.")
  logsNamespace?: string;

  ...ObservabilityDefaults;
}

@doc("A named storage definition that workloads in the namespace can mount by name.")
@discriminator("kind")
model NamespaceStorageDefinition {
  @doc("Storage definition name used by workload storage mounts.")
  @pattern("^[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?$")
  name: string;

  @doc("Storage kind.")
  kind: NamespaceStorageKind;
}

@doc("Persistent storage definition backed by a Kubernetes PersistentVolumeClaim.")
model PersistentNamespaceStorageDefinition extends NamespaceStorageDefinition {
  @doc("Storage kind.")
  kind: NamespaceStorageKind.Persistent;

  @doc("Storage class to use. When omitted, the platform uses the default storage class for the namespace or cluster.")
  storageClassName?: string;

  @doc("Requested storage size, for example `10Gi`.")
  size: string;

  @doc("Access modes. Defaults to the storage class default when omitted.")
  accessModes?: StorageAccessMode[];
}

@doc("Ephemeral storage definition scoped to each workload instance.")
model EphemeralNamespaceStorageDefinition extends NamespaceStorageDefinition {
  @doc("Storage kind.")
  kind: NamespaceStorageKind.Ephemeral;

  @doc("Optional size limit, for example `2Gi`.")
  sizeLimit?: string;
}

@doc("Storage kind for a namespace storage definition.")
union NamespaceStorageKind {
  string,

  @doc("Persistent storage backed by a Kubernetes PersistentVolumeClaim.")
  Persistent: "Persistent",

  @doc("Ephemeral storage scoped to the workload instance.")
  Ephemeral: "Ephemeral",
}

@doc("Supported storage access modes.")
union StorageAccessMode {
  string,

  @doc("Mounted read-write by a single node.")
  ReadWriteOnce: "ReadWriteOnce",

  @doc("Mounted read-only by many nodes.")
  ReadOnlyMany: "ReadOnlyMany",

  @doc("Mounted read-write by many nodes.")
  ReadWriteMany: "ReadWriteMany",
}

@armResourceOperations(Namespace)
interface Namespaces {
  get is ArmResourceRead<Namespace>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Namespace>;
  update is ArmCustomPatchAsync<
    Namespace,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      Namespace,
      NamespaceProperties
    >
  >;
  delete is ArmResourceDeleteWithoutOkAsync<Namespace>;
  listByCluster is ArmResourceListByParent<Namespace>;
}
