import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using Microsoft.OpenEnergyPlatform;

// =============================================================================
// Backward-compatibility overrides for the Swagger -> TypeSpec migration.
//
// These augment decorators preserve the legacy swagger body-parameter names
// from the hand-authored 2026-02-02-preview spec. Placing them here (in a file
// imported by main.tsp) ensures BOTH typespec-autorest (swagger emission) AND
// the client-generator-core based emitters apply the renames. If these decorators lived
// only in client.tsp, the swagger would carry the new ARM-template defaults
// ("resource", "properties") and produce spurious BreakingChange OAD
// violations even though the wire contract is unchanged.
//
// Wire impact: NONE. The Swagger body.name is a swagger/SDK identifier; it
// never appears in the HTTP request bytes. See contract-preservation-summary.md
// Bucket A.
// =============================================================================

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

// -----------------------------------------------------------------------------
// Bucket L: preserve legacy camelCase x-ms-enum.name values from the
// hand-authored swagger. TypeSpec autogenerates PascalCase names from the
// union identifier (KeySource, AllowedMethods, ReadyForUpgrade). The
// pre-migration swagger used camelCase (keySource, allowedMethods,
// readyForUpgrade). Renaming via @@clientName here ensures both
// typespec-autorest (swagger x-ms-enum.name) AND client emitters preserve
// the legacy identifiers. Wire impact: NONE — the enum string values on the
// wire are unchanged.
// -----------------------------------------------------------------------------

@@clientName(KeySource, "keySource");
@@clientName(AllowedMethods, "allowedMethods");
@@clientName(ReadyForUpgrade, "readyForUpgrade");

// -----------------------------------------------------------------------------
// A5.2: preserve the legacy `Identity` SDK type name for the inline
// keyvault-access identity object — scoped to CLIENT emitters only.
//
// In the hand-authored swagger, this was an anonymous inline object under
// `EdsKeyVaultProperties.identity`. TypeSpec requires the model to be named
// (`EdsKeyVaultPropertiesIdentity`) and the autorest emitter produces a
// `#/definitions/EdsKeyVaultPropertiesIdentity` $ref.
//
// We CANNOT rename it globally because common-types/v3/types.json defines a
// top-level `Identity` schema (principalId/tenantId/type) that is transitively
// reachable from this spec; renaming our model to `Identity` in swagger
// causes OAD to do name-based matching across the reachable definition pool
// and diff our shape against the unrelated v3 Identity, producing 5 spurious
// schema-shape violations.
//
// Scoping the rename to client emitters only (python, csharp, java,
// javascript, go) preserves the historic SDK class name without touching the
// swagger that OAD compares. Wire impact: NONE. Swagger schema name:
// unchanged (still EdsKeyVaultPropertiesIdentity). SDK class name in each
// language: restored to Identity.
// -----------------------------------------------------------------------------

@@clientName(
  EdsKeyVaultPropertiesIdentity,
  "Identity",
  "python,csharp,java,javascript,go"
);

// -----------------------------------------------------------------------------
// SME c1: restore legacy SDK-shaping metadata dropped by the swagger->TypeSpec
// conversion in the keyvault/encryption area. The hand-authored 2026-02-02-preview
// swagger carried x-ms-client-name renames on these properties and
// x-ms-client-flatten on the Encryption/Eds models. Re-applying them here (in a
// file imported by main.tsp) ensures typespec-autorest re-emits the same
// SDK-shaping metadata so the converted swagger matches the base contract.
// Wire impact: NONE — x-ms-client-name / x-ms-client-flatten are SDK identifiers
// and never appear in the HTTP request bytes.
// -----------------------------------------------------------------------------

@@clientName(Encryption.keyVaultProperties, "KeyVaultProperties");
@@clientName(KeyVaultProperties.keyName, "KeyName");
@@clientName(KeyVaultProperties.keyVersion, "KeyVersion");
@@clientName(KeyVaultProperties.keyVaultUri, "KeyVaultUri");
@@clientName(KeyVaultProperties.userIdentity, "UserIdentity");
@@clientName(Eds.keyVaultProperties, "EdsKeyVaultProperties");
@@clientName(EdsKeyVaultProperties.keyVaultUri, "KeyVaultUri");
@@clientName(
  EdsKeyVaultPropertiesIdentity.userAssignedIdentityId,
  "UserAssignedIdentity"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Preserve legacy SDK flattening from the hand-authored swagger (back-compat)."
@@Azure.ClientGenerator.Core.Legacy.flattenProperty(Encryption.keyVaultProperties);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Preserve legacy SDK flattening from the hand-authored swagger (back-compat)."
@@Azure.ClientGenerator.Core.Legacy.flattenProperty(Eds.keyVaultProperties);
