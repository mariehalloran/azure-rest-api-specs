import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.AIOps;

/** The resource provisioning state. */
@lroStatus
union ProvisioningState {
  ResourceProvisioningState,

  /** The resource is being created. */
  Creating: "Creating",

  /** The resource is being updated. */
  Updating: "Updating",

  /** The resource is being deleted. */
  Deleting: "Deleting",

  string,
}

/** Properties of the Microsoft.AIOps service resource. */
model ServiceProperties {
  /** Provisioning state of the Microsoft.AIOps service. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** Data plane endpoint URL generated during provisioning. */
  @visibility(Lifecycle.Read)
  dataplaneEndpoint?: url;
}

/** A Microsoft.AIOps service resource representing a BRAIN tenant. */
model Service is TrackedResource<ServiceProperties> {
  ...ResourceNameParameter<
    Service,
    KeyName = "serviceName",
    SegmentName = "services"
  >;

  /** The managed identity for the resource. */
  ...ManagedServiceIdentityProperty;
}

/** Operations for managing Microsoft.AIOps service resources. */
@armResourceOperations
interface Services {
  /** Get a Microsoft.AIOps service resource. */
  get is ArmResourceRead<Service>;

  /** Create or update a Microsoft.AIOps service resource. */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Service>;

  /** Delete a Microsoft.AIOps service resource. */
  delete is ArmResourceDeleteWithoutOkAsync<Service>;

  /** List Microsoft.AIOps service resources by resource group. */
  listByResourceGroup is ArmResourceListByParent<Service>;

  /** List Microsoft.AIOps service resources by subscription. */
  listBySubscription is ArmListBySubscription<Service>;

  /** Update a Microsoft.AIOps service resource. */
  @Azure.Core.useFinalStateVia("azure-async-operation")
  update is ArmResourcePatchAsync<
    Service,
    ServiceProperties,
    LroHeaders = ArmAsyncOperationHeader<FinalResult = Service> &
      ArmLroLocationHeader<FinalResult = Service> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
}
