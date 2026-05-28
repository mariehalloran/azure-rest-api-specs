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
// the TCGC-based client emitters apply the renames. If these decorators lived
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
