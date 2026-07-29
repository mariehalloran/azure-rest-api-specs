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
 * The Private Endpoint Connection resource.
 */
model PrivateEndpointConnection is PrivateEndpointConnectionResource;
alias PrivateEndpointOperations = PrivateEndpoints<PrivateEndpointConnection>;

@armResourceOperations
interface PrivateEndpointConnections {
  /**
   * Get the specified private endpoint connection associated with the ADME Instance.
   */
  get is PrivateEndpointOperations.Read<
    EnergyService,
    PrivateEndpointConnection
  >;

  /**
   * Update the state of specified private endpoint connection associated with the ADME Instance.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "Preserving original response shape for backward compatibility."
  createOrUpdate is PrivateEndpointOperations.CreateOrReplaceAsync<
    EnergyService,
    PrivateEndpointConnection,
    Response = ArmResourceCreatedResponse<Azure.ResourceManager.CommonTypes.PrivateEndpointConnection>
  >;

  /**
   * Deletes the specified private endpoint connection associated with the ADME Instance.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "Preserving original response shape for backward compatibility."
  delete is PrivateEndpointOperations.DeleteAsync<
    EnergyService,
    PrivateEndpointConnection,
    Response =
      | ArmDeletedResponse
      | ArmDeleteAcceptedLroResponse
      | ArmDeletedNoContentResponse
  >;

  /**
   * List all private endpoint connections in a ADME instance.
   */
  #suppress "@azure-tools/typespec-azure-core/casing-style" "Preserving existing operationId casing (OAK acronym)."
  listByOAKInstance is PrivateEndpointOperations.ListByParent<
    EnergyService,
    PrivateEndpointConnection,
    Response = ArmResponse<Azure.ResourceManager.CommonTypes.PrivateEndpointConnectionListResult>
  >;
}

@@doc(PrivateEndpointConnection.properties, "Resource properties.");
@@doc(
  PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "The parameters for creating a private endpoint connection."
);
