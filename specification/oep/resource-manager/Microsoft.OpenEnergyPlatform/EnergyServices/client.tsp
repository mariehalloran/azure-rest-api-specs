import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.OpenEnergyPlatform;

@@clientName(Eds.keyVaultProperties, "edsKeyVaultProperties");

@@clientName(EdsKeyVaultPropertiesIdentity.userAssignedIdentityId,
  "userAssignedIdentity"
);

@@clientLocation(LocationsOperationGroup.checkNameAvailability, "Locations");

// Preserve SDK source-compat with the previously published preview by keeping
// the legacy body-parameter names on the generated client. The wire contract
// (HTTP request body JSON) is unchanged; these names only affect the SDK
// method signature parameter identifier.
@@clientName(EnergyServices.create::parameters.resource, "body");
@@clientName(PrivateEndpointConnectionProxies.createOrUpdate::parameters.resource,
  "privateEndpointConnectionProxy"
);
@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "privateEndpointConnection"
);
