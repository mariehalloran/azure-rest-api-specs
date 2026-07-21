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

@doc("Represents the kind of workload a deployment projection belongs to.")
union WorkloadKind {
  string,

  @doc("The deployment belongs to a Service workload.")
  Service: "Service",

  @doc("The deployment belongs to a Job workload.")
  Job: "Job",

  @doc("The deployment belongs to a CronJob workload.")
  CronJob: "CronJob",
}

@doc("""
  Common properties of an aggregate deployment projection.
  
  This is the "one for all" read-only view of the actual, cluster-observed
  deployments across every workload kind (Service, Job, CronJob) within a
  Namespace. The concrete shape is discriminated by workloadKind.
  """)
@discriminator("workloadKind")
model DeploymentProperties {
  @doc("The kind of workload this deployment projection belongs to.")
  workloadKind: WorkloadKind;

  @doc("Name of the owning workload (Service, Job, or CronJob) within the Namespace.")
  workloadName?: string;

  @doc("The provisioning state of the deployment projection resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Aggregate deployment projection for a Service workload.")
model ServiceWorkloadDeployment extends DeploymentProperties {
  @doc("The kind of workload this deployment projection belongs to.")
  workloadKind: WorkloadKind.Service;

  ...ServiceDeploymentStatus;
}

@doc("Aggregate deployment projection for a Job workload.")
model JobWorkloadDeployment extends DeploymentProperties {
  @doc("The kind of workload this deployment projection belongs to.")
  workloadKind: WorkloadKind.Job;

  ...JobExecutionStatus;
}

@doc("Aggregate deployment projection for a CronJob workload.")
model CronJobWorkloadDeployment extends DeploymentProperties {
  @doc("The kind of workload this deployment projection belongs to.")
  workloadKind: WorkloadKind.CronJob;

  ...CronJobExecutionStatus;
}

@doc("""
  Read-only aggregate projection of the actual deployments running in the
  cluster for every workload kind within a Namespace.
  """)
@parentResource(Namespace)
model Deployment is ProxyResource<DeploymentProperties> {
  @doc("The name of the deployment projection.")
  @key("deploymentName")
  @segment("deployments")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@armResourceOperations(Deployment)
interface Deployments {
  get is ArmResourceRead<Deployment>;
  listByNamespace is ArmResourceListByParent<Deployment>;
}
