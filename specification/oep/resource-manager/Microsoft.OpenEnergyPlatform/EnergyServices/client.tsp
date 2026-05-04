import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.OpenEnergyPlatform;

@@clientName(Eds.keyVaultProperties, "edsKeyVaultProperties");

@@clientName(EdsKeyVaultPropertiesIdentity.userAssignedIdentityId,
  "userAssignedIdentity"
);

@@clientLocation(LocationsOperationGroup.checkNameAvailability, "Locations");
