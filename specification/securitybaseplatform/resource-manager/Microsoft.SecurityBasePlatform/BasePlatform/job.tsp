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

@doc("Represents a run-to-completion Job workload.")
@parentResource(Namespace)
model Job is TrackedResource<JobProperties> {
  ...ManagedServiceIdentityProperty;

  @doc("The name of the Job.")
  @key("jobName")
  @segment("jobs")
  @pattern("^[a-z0-9]([-a-z0-9]{1,22}[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@doc("Properties of a Job workload.")
model JobProperties {
  ...WorkloadProperties;

  @doc("Job specific configuration.")
  jobProfile?: JobProfile;
}

@armResourceOperations(Job)
interface Jobs {
  get is ArmResourceRead<Job>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Job>;
  update is ArmCustomPatchAsync<
    Job,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      Job,
      Update<JobProperties>
    >
  >;
  delete is ArmResourceDeleteWithoutOkAsync<Job>;
  listByNamespace is ArmResourceListByParent<Job>;
}

@doc("Properties of a Job deployment (execution) projection.")
model JobDeploymentProperties {
  ...JobExecutionStatus;

  @doc("The provisioning state of the deployment projection resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Read-only projection of a Job's actual execution in the cluster.")
@parentResource(Job)
model JobDeployment is ProxyResource<JobDeploymentProperties> {
  @doc("The name of the Job deployment (execution).")
  @key("deploymentName")
  @segment("deployments")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@armResourceOperations(JobDeployment)
interface JobDeployments {
  get is ArmResourceRead<JobDeployment>;
  listByJob is ArmResourceListByParent<JobDeployment>;
}
