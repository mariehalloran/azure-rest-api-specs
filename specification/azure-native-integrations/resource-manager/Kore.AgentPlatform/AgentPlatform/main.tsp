import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@azure-tools/typespec-liftr-base";
import "@azure-tools/typespec-autorest";

import "./models.tsp";
import "./organizations.tsp";
import "./workspaces.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using LiftrBase;

/**
 * Kore.AgentPlatform Resource Provider for managing Kore AI Agent Platform
 * Organizations and their Workspaces.
 *
 * Organizations are top-level tracked ARM resources. Each Organization is
 * provisioned together with a default Workspace. Additional Workspaces are
 * managed through POST actions on the parent Organization
 * (`createWorkspace`, `deleteWorkspace`, `restoreWorkspace`).
 * GET and LIST on workspaces are exposed as a child proxy resource type.
 *
 * Service-to-service authentication between Liftr and Kore uses federated
 * Microsoft Entra credentials and is enforced at the runtime layer
 * (not on the ARM surface).
 */
@armProviderNamespace
@service(#{ title: "Kore.AgentPlatform" })
@versioned(Kore.AgentPlatform.Versions)
namespace Kore.AgentPlatform;

/** Supported API versions for the Kore.AgentPlatform resource provider. */
@doc("Supported versions for the Kore.AgentPlatform resource model")
enum Versions {
  /** 2026-06-01 preview version */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  @useDependency(LiftrBase.Versions.v3_preview)
  v2026_06_01_preview: "2026-06-01-preview",
}
