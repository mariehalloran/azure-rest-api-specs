import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./EnergyService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.OpenEnergyPlatform;
/**
 * Private endpoint connection proxy details.
 */
@parentResource(EnergyService)
model PrivateEndpointConnectionProxy
  is Azure.ResourceManager.ProxyResource<PrivateEndpointConnectionProxyProperties> {
  ...ResourceNameParameter<
    Resource = PrivateEndpointConnectionProxy,
    KeyName = "privateEndpointConnectionProxyId",
    SegmentName = "privateEndpointConnectionProxies",
    NamePattern = ""
  >;

  /**
   * ETag from NRP.
   */
  eTag?: string;

  /**
   * Remote private endpoint details.
   */
  remotePrivateEndpoint?: RemotePrivateEndpoint;

  /**
   * Operation status.
   */
  status?: string;
}

@armResourceOperations
interface PrivateEndpointConnectionProxies {
  /**
   * (INTERNAL - DO NOT USE) Get the specified private endpoint connection proxy associated with the OAK Instance.
   */
  get is ArmResourceRead<PrivateEndpointConnectionProxy>;

  /**
   * (INTERNAL - DO NOT USE) Creates or updates the specified private endpoint connection proxy resource associated with the OAK instance.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    PrivateEndpointConnectionProxy,
    Response = ArmResourceCreatedResponse<PrivateEndpointConnectionProxy>
  >;

  /**
   * (INTERNAL - DO NOT USE) Deletes the specified private endpoint connection proxy associated with the OAK Instance.
   */
  delete is ArmResourceDeleteWithoutOkAsync<
    PrivateEndpointConnectionProxy,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * (INTERNAL - DO NOT USE) List all private endpoint connection proxies in a OAK instance.
   */
  listByOAKInstance is ArmResourceListByParent<PrivateEndpointConnectionProxy>;

  /**
   * (INTERNAL - DO NOT USE) Validates a private endpoint connection proxy object.
   */
  validate is ArmResourceActionSync<
    PrivateEndpointConnectionProxy,
    PrivateEndpointConnectionProxy,
    OkResponse
  >;
}

@@doc(PrivateEndpointConnectionProxy.name,
  "The ID of the private endpoint connection proxy object."
);
@@doc(PrivateEndpointConnectionProxy.properties,
  "Private endpoint connection proxy object property bag."
);
@@doc(PrivateEndpointConnectionProxies.createOrUpdate::parameters.resource,
  "The parameters for creating a private endpoint connection proxy."
);
@@doc(PrivateEndpointConnectionProxies.validate::parameters.body,
  "The parameters for creating a private endpoint connection proxy."
);
