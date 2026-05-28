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

// NOTE: body-parameter @@clientName overrides for the swagger migration
// (Bucket A) were moved to back-compatible.tsp so that typespec-autorest
// also sees them. See contract-preservation-summary.md.
