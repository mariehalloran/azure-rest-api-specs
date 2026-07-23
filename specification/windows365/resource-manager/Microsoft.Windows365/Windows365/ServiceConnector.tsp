import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Windows365;

/** A Windows 365 service connector resource. */
model ServiceConnector is TrackedResource<ServiceConnectorProperties> {
  ...ResourceNameParameter<
    ServiceConnector,
    KeyName = "serviceConnectorName",
    SegmentName = "serviceConnectors"
  >;

  /** The managed identity used by the service connector. */
  ...ManagedServiceIdentityProperty;
}

/** The short-term service connector contract has no customer-configurable properties; configuration is expressed through the resource identity and tags. */
model ServiceConnectorProperties {
  ...DefaultProvisioningStateProperty;
}

/** Operations for Windows 365 service connector resources. */
@armResourceOperations
interface ServiceConnectors {
  /** Get a service connector resource. */
  get is ArmResourceRead<ServiceConnector>;

  /** Create or replace a service connector resource. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<ServiceConnector>;

  /** Update the tags of a service connector resource. */
  update is ArmTagsPatchSync<ServiceConnector>;

  /** Delete a service connector resource. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "ARM RPC requires the new synchronous DELETE operation to return 204 only."
  delete is ArmResourceDeleteSync<
    ServiceConnector,
    Response = ArmDeletedNoContentResponse
  >;

  /** List service connector resources by resource group. */
  listByResourceGroup is ArmResourceListByParent<ServiceConnector>;

  /** List service connector resources by subscription. */
  listBySubscription is ArmListBySubscription<ServiceConnector>;
}

@@doc(
  ServiceConnector.identity,
  "The managed identity used by the service connector. The service accepts exactly one identity: either a system-assigned identity or one user-assigned identity."
);
