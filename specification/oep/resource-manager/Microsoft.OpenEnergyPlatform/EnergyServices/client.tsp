import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.OpenEnergyPlatform;

@@clientName(Eds.keyVaultProperties, "edsKeyVaultProperties");

@@clientName(
  EdsKeyVaultPropertiesIdentity.userAssignedIdentityId,
  "userAssignedIdentity"
);

@@clientLocation(LocationsOperationGroup.checkNameAvailability, "Locations");

// Disambiguate the local PrivateEndpointConnection from the Azure.ResourceManager.CommonTypes
// model of the same name (referenced in createOrUpdate / listByOAKInstance response overrides).
// JS/Go scope namespaces differently and do not collide; Python/Java flatten to a single
// client namespace and need an explicit rename to avoid duplicate-client-name errors.
@@clientName(
  PrivateEndpointConnection,
  "EnergyServicePrivateEndpointConnection",
  "python,java"
);

// Preserve SDK source-compat with the previously published preview by keeping
// the legacy body-parameter names on the generated client. The wire contract
// (HTTP request body JSON) is unchanged; these names only affect the SDK
// method signature parameter identifier.
@@clientName(EnergyServices.create::parameters.resource, "body");
@@clientName(EnergyServices.update::parameters.properties, "body");
@@clientName(
  PrivateEndpointConnectionProxies.createOrUpdate::parameters.resource,
  "privateEndpointConnectionProxy"
);
@@clientName(
  PrivateEndpointConnectionProxies.validate::parameters.body,
  "privateEndpointConnectionProxy"
);
@@clientName(
  PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "privateEndpointConnection"
);
