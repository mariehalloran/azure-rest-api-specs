import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.OpenEnergyPlatform;

// SDK-only renames. back-compatible.tsp renames these same targets to
// "EdsKeyVaultProperties"/"UserAssignedIdentity" for the swagger (autorest)
// contract; these client-only camelCase names must therefore be scoped away
// from autorest so importing client.tsp into main.tsp leaves the swagger
// unchanged. "!autorest" cannot be used here because a negated scope resets
// the autorest name instead of falling back to the back-compatible.tsp value.
@@clientName(
  Eds.keyVaultProperties,
  "edsKeyVaultProperties",
  "csharp,python,java,javascript,go"
);

@@clientName(
  EdsKeyVaultPropertiesIdentity.userAssignedIdentityId,
  "userAssignedIdentity",
  "csharp,python,java,javascript,go"
);

// Disambiguate the local PrivateEndpointConnection from the Azure.ResourceManager.CommonTypes
// model of the same name (referenced in createOrUpdate / listByADMEInstance response overrides).
// JS/Go scope namespaces differently and do not collide; C#/Python/Java flatten to a single
// client namespace and need an explicit rename to avoid duplicate-client-name errors.
@@clientName(
  PrivateEndpointConnection,
  "EnergyServicePrivateEndpointConnection",
  "csharp,python,java"
);

// NOTE: body-parameter @@clientName overrides for the swagger migration
// (Bucket A) were moved to back-compatible.tsp so that typespec-autorest
// also sees them. See contract-preservation-summary.md.
