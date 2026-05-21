import "@azure-tools/typespec-azure-core";
import "@typespec/versioning";
import "@typespec/rest";
import "@azure-tools/typespec-client-generator-core";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using Azure.ClientGenerator.Core;
using OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.BareMetal;

/**
 * Operations for ManagedConsoleConnection resource.
 */
@added(Versions.v2026_04_01_preview)
@armResourceOperations
interface ManagedConsoleConnections {
  /** Get the ManagedConsoleConnection. */
  get is ArmResourceRead<ManagedConsoleConnection>;

  /** Create or replace the ManagedConsoleConnection (LRO). */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ManagedConsoleConnection>;

  /** Patch the ManagedConsoleConnection. Only the tags may be updated. */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    ManagedConsoleConnection,
    ManagedConsoleConnectionUpdate
  >;

  /** Delete the resource (LRO). */
  delete is ArmResourceDeleteWithoutOkAsync<ManagedConsoleConnection>;

  /** List by resource group. */
  listResourceGroup is ArmResourceListByParent<ManagedConsoleConnection>;

  /** List by subscription. */
  listSubscription is ArmListBySubscription<ManagedConsoleConnection>;
}

@@Azure.ClientGenerator.Core.clientName(
  ManagedConsoleConnections.createOrUpdate::parameters.resource,
  "managedConsoleConnectionObject"
);
@@clientName(
  ManagedConsoleConnections.createOrUpdate::parameters.resource,
  "managedConsoleConnectionObject"
);

@@Azure.ClientGenerator.Core.clientName(
  ManagedConsoleConnections.update::parameters.properties,
  "managedConsoleConnectionObject"
);
@@clientName(
  ManagedConsoleConnections.update::parameters.properties,
  "managedConsoleConnectionObject"
);
