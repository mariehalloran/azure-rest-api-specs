import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.DurableTask;

@doc("A disaster recovery configuration belonging to the scheduler")
@added(Versions.v2026_07_01_Preview)
@parentResource(Scheduler)
@singleton
model DisasterRecoveryConfig
  is Azure.ResourceManager.ProxyResource<DisasterRecoveryConfigProperties> {
  ...ResourceNameParameter<
    DisasterRecoveryConfig,
    "disasterRecoveryConfigName",
    "disasterRecoveryConfigs"
  >;
}

@doc("The disaster recovery configuration settings for the resource")
@added(Versions.v2026_07_01_Preview)
model DisasterRecoveryConfigProperties {
  @visibility(Lifecycle.Read)
  @doc("The status of the last operation")
  provisioningState?: ProvisioningState;

  @visibility(Lifecycle.Read)
  @doc("The replication role of the scheduler")
  replicationRole: ReplicationRole;

  @doc("The resource ID of the partner scheduler in the disaster recovery configuration")
  partnerScheduler: string;

  @visibility(Lifecycle.Read)
  @doc("The location of the partner scheduler in the disaster recovery configuration")
  partnerLocation: string;
}

@doc("The replication role of the scheduler")
@added(Versions.v2026_07_01_Preview)
union ReplicationRole {
  string,

  @doc("The scheduler is the primary in the disaster recovery configuration")
  Primary: "Primary",

  @doc("The scheduler is the secondary in the disaster recovery configuration")
  Secondary: "Secondary",
}

@added(Versions.v2026_07_01_Preview)
@armResourceOperations(DisasterRecoveryConfig)
interface DisasterRecoveryConfigs {
  @doc("Get a Disaster Recovery Configuration")
  @errorsDoc("Not found error: resource does not exist")
  get is ArmResourceRead<DisasterRecoveryConfig>;
  @doc("Create or Update a Disaster Recovery Configuration")
  @errorsDoc("Validation error: required parameters are missing")
  createOrReplace is ArmResourceCreateOrReplaceAsync<DisasterRecoveryConfig>;
  @doc("Delete a Disaster Recovery Configuration")
  delete is ArmResourceDeleteWithoutOkAsync<DisasterRecoveryConfig>;
  @doc("List Disaster Recovery Configurations")
  listByScheduler is ArmResourceListByParent<DisasterRecoveryConfig>;
}
