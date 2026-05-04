import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.OpenEnergyPlatform;

@@clientName(Eds.keyVaultProperties, "edsKeyVaultProperties");

@@clientName(EdsKeyVaultPropertiesIdentity.userAssignedIdentityId,
  "userAssignedIdentity"
);

@@clientLocation(GroupInformations.get, "PrivateLinkResources");
@@clientLocation(GroupInformations.listByOAKInstance, "PrivateLinkResources");

@@clientLocation(LocationsOperationGroup.checkNameAvailability, "Locations");
