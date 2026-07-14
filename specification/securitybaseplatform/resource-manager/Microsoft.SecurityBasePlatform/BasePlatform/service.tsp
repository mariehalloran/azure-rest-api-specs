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

@doc("Represents a long-running Service workload.")
@parentResource(Namespace)
model Service is TrackedResource<ServiceProperties> {
  ...ManagedServiceIdentityProperty;

  @doc("The name of the Service.")
  @key("serviceName")
  @segment("services")
  @pattern("^[a-z0-9]([-a-z0-9]{1,22}[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@doc("Properties of a Service workload.")
model ServiceProperties {
  ...WorkloadProperties;

  @doc("Scaling configuration.")
  scalingProfile?: ScalingProfile;

  @doc("Ports the Service listens on.")
  @identifiers(#["containerPort"])
  ports?: ContainerPortConfig[];

  @doc("Ingress configuration for the Service. When omitted or disabled, the Service is not exposed through ingress.")
  ingress?: ServiceIngressConfig;
}

@armResourceOperations(Service)
interface Services {
  get is ArmResourceRead<Service>;
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Service>;
  update is ArmCustomPatchAsync<
    Service,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      Service,
      ServiceProperties
    >
  >;
  delete is ArmResourceDeleteWithoutOkAsync<Service>;
  listByNamespace is ArmResourceListByParent<Service>;
}

@doc("Properties of a Service deployment projection.")
model ServiceDeploymentProperties {
  ...ServiceDeploymentStatus;

  @doc("The provisioning state of the deployment projection resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Read-only projection of a Service's actual deployment currently running in the cluster.")
@parentResource(Service)
model ServiceDeployment is ProxyResource<ServiceDeploymentProperties> {
  @doc("The name of the Service deployment.")
  @key("deploymentName")
  @segment("deployments")
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}

@armResourceOperations(ServiceDeployment)
interface ServiceDeployments {
  get is ArmResourceRead<ServiceDeployment>;
  listByService is ArmResourceListByParent<ServiceDeployment>;
}
