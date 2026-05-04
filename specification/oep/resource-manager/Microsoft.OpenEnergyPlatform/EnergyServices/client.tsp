import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.OpenEnergyPlatform;

@@clientName(Eds.keyVaultProperties, "edsKeyVaultProperties");

@@clientName(EdsKeyVaultPropertiesIdentity.userAssignedIdentityId,
  "userAssignedIdentity"
);

@@clientLocation(PrivateLinkResources.get, "PrivateLinkResources");
@@clientLocation(PrivateLinkResources.listByOAKInstance, "PrivateLinkResources");

@@clientLocation(LocationsOperationGroup.checkNameAvailability, "Locations");

// Preserve original SDK body parameter names from the prior swagger contract.
// These do not affect the HTTP wire (the body name is cosmetic in OpenAPI 2.0),
// but keeping them stable avoids breaking keyword-arg callers in generated SDKs.
@@clientName(EnergyServices.create::parameters.resource, "body");
@@clientName(EnergyServices.update::parameters.properties, "body");
@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "privateEndpointConnection"
);
@@clientName(PrivateEndpointConnectionProxies.createOrUpdate::parameters.resource,
  "privateEndpointConnectionProxy"
);
@@clientName(PrivateEndpointConnectionProxies.validate::parameters.body,
  "privateEndpointConnectionProxy"
);
