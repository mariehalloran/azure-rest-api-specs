import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./shared-models.tsp";
import "./namespace.tsp";
import "./workload-models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.SecurityBasePlatform;

@doc("Represents a scheduled, recurring CronJob workload.")
@parentResource(Namespace)
model CronJob is TrackedResource<CronJobProperties> {
  ...ManagedServiceIdentityProperty;

  @doc("The name of the CronJob.")
  @key("cronJobName")
  @segment("cronjobs")
  @pattern("^[a-z0-9]([-a-z0-9]{1,22}[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@doc("Properties of a CronJob workload.")
model CronJobProperties {
  ...WorkloadProperties;

  @doc("Cron schedule expression (e.g. '0 * * * *').")
  schedule: string;

  @doc("Job specific configuration for each scheduled run.")
  jobProfile?: JobProfile;
}

@armResourceOperations(CronJob)
interface CronJobs {
  get is ArmResourceRead<CronJob>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CronJob>;
  update is ArmCustomPatchAsync<
    CronJob,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<CronJob, Update<CronJobProperties>>
  >;
  delete is ArmResourceDeleteWithoutOkAsync<CronJob>;
  listByNamespace is ArmResourceListByParent<CronJob>;
}

@doc("Properties of a CronJob deployment (execution) projection.")
model CronJobDeploymentProperties {
  ...CronJobExecutionStatus;

  @doc("The provisioning state of the deployment projection resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Read-only projection of a CronJob's actual executions in the cluster.")
@parentResource(CronJob)
model CronJobDeployment is ProxyResource<CronJobDeploymentProperties> {
  @doc("The name of the CronJob deployment (execution set).")
  @key("deploymentName")
  @segment("deployments")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@armResourceOperations(CronJobDeployment)
interface CronJobDeployments {
  get is ArmResourceRead<CronJobDeployment>;
  listByCronJob is ArmResourceListByParent<CronJobDeployment>;
}
