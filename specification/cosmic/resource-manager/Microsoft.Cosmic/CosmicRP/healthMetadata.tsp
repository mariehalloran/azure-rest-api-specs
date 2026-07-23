import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./namespace.tsp";

using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace Microsoft.Cosmic;

@doc("Health metadata for COSMIC monitoring, scoped under a namespace and consumed by HealthService.")
@parentResource(Namespace)
model HealthMetadata is ProxyResource<HealthMetadataProperties> {
  @doc("The name of the health metadata resource.")
  @key("healthMetadataName")
  @segment("healthMetadatas")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @minLength(3)
  @maxLength(63)
  @path
  name: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "HealthMetadata is a pure proxy resource backed by Inventory; it has no RP-owned provisioning lifecycle."
@doc("Properties of a HealthMetadata resource.")
model HealthMetadataProperties {
  @doc("Platform ring this health metadata applies to.")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  platformRing: CosmicRing;

  @doc("Regions this health metadata applies to. Empty means all regions.")
  regions?: string[];

  @doc("Partition labels this health metadata applies to. Empty means all partitions.")
  partitionLabels?: string[];

  @doc("Geneva/MDM account name used for monitor lookups.")
  @minLength(1)
  genevaAccount: string;

  @doc("Geneva environment where the monitors are defined.")
  genevaEnvironment?: GenevaEnvironment;

  @doc("Default mapping from COSMIC dimension keys to partner Geneva dimension names.")
  dimensionMap: HealthMetadataDimensionMap;

  @doc("Monitors configured for health evaluation.")
  @identifiers(#["monitorName"])
  monitors: HealthMetadataMonitor[];
}

@doc("Mapping from COSMIC dimension keys to partner Geneva dimension names.")
model HealthMetadataDimensionMap {
  @doc("Partner dimension name for the COSMIC ring.")
  cosmicRing?: string;

  @doc("Partner dimension name for the COSMIC geo.")
  cosmicGeo?: string;

  @doc("Partner dimension name for the COSMIC region.")
  cosmicRegion?: string;

  @doc("Partner dimension name for the COSMIC partition.")
  cosmicPartition?: string;

  @doc("Partner dimension name for the COSMIC cluster.")
  cosmicCluster?: string;
}

@doc("A Geneva monitor configured for health evaluation.")
model HealthMetadataMonitor {
  @doc("Unique monitor name within this health metadata resource.")
  @minLength(1)
  monitorName: string;

  @doc("Geneva monitor identifier.")
  @pattern("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")
  monitorId: string;

  @doc("Human-readable monitor description.")
  description?: string;

  @doc("Optional monitor-level Geneva account override.")
  genevaAccount?: string;

  @doc("Optional monitor-level Geneva environment override.")
  genevaEnvironment?: GenevaEnvironment;

  @doc("Optional monitor-level dimension map override.")
  dimensionMap?: HealthMetadataDimensionMap;

  @doc("Regions this monitor applies to. Empty means all regions.")
  regions?: string[];

  @doc("Partition labels this monitor applies to. Empty means all partitions.")
  partitionLabels?: string[];

  @doc("Weight of this monitor for health scoring.")
  @minValue(0)
  weight: int32;
}

@doc("Geneva environment where monitor metadata is defined.")
union GenevaEnvironment {
  @doc("Geneva PPE environment.")
  Ppe: "ppe",

  @doc("Geneva production environment.")
  Prod: "prod",

  string,
}

@armResourceOperations
interface HealthMetadatas {
  get is ArmResourceRead<HealthMetadata>;
  // Synchronous proxy CRUD: MetaRP routes the call to RP, while RP persists the source of truth in Inventory.
  createOrUpdate is ArmResourceCreateOrReplaceSync<HealthMetadata>;
  update is ArmCustomPatchSync<
    HealthMetadata,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      HealthMetadata,
      HealthMetadataProperties
    >
  >;
  delete is ArmResourceDeleteSync<HealthMetadata>;
  // Lists are projected from Inventory rather than MetaRP cache because this is a pure proxy resource.
  listByNamespace is ArmResourceListByParent<HealthMetadata>;
}
