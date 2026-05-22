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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<PrivateEndpointConnectionProxy>;

  /**
   * (INTERNAL - DO NOT USE) Deletes the specified private endpoint connection proxy associated with the OAK Instance.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "Preserving original response shape for backward compatibility."
  delete is ArmResourceDeleteWithoutOkAsync<
    PrivateEndpointConnectionProxy,
    Response =
      | ArmDeletedResponse
      | ArmDeleteAcceptedLroResponse
      | ArmDeletedNoContentResponse
  >;

  /**
   * (INTERNAL - DO NOT USE) List all private endpoint connection proxies in a OAK instance.
   */
  #suppress "@azure-tools/typespec-azure-core/casing-style" "Preserving existing operationId casing (OAK acronym)."
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

@@doc(
  PrivateEndpointConnectionProxy.name,
  "The ID of the private endpoint connection proxy object."
);
@@doc(
  PrivateEndpointConnectionProxy.properties,
  "Private endpoint connection proxy object property bag."
);
@@doc(
  PrivateEndpointConnectionProxies.createOrUpdate::parameters.resource,
  "The parameters for creating a private endpoint connection proxy."
);
@@doc(
  PrivateEndpointConnectionProxies.validate::parameters.body,
  "The parameters for creating a private endpoint connection proxy."
);
