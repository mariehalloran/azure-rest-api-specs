import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "./common.tsp";
import "./ContextCaches/contextCacheModels.tsp";
import "./ContextCacheContainers/contextCacheContainerModels.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

/** Microsoft.Storage Context Cache Resource Provider management API. */
@armProviderNamespace("Microsoft.Storage")
@service(#{ title: "Storage Context Cache Resource Provider" })
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
namespace Microsoft.Storage;

/** The available API versions. */
enum Versions {
  /** 2026-01-01-preview version */
  @useDependency(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_01_01_preview: "2026-01-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}

/** A Context Cache resource */
model ContextCache is TrackedResource<ContextCacheProperties, false> {
  /** The name of the context cache */
  @pattern("^[a-z0-9][a-z0-9-]{1,22}[a-z0-9]$")
  @key("contextCacheName")
  @segment("contextCaches")
  @path
  name: string;

  ...ManagedSystemAssignedIdentityProperty;
}

@armResourceOperations(ContextCache)
interface ContextCaches {
  /** Get a Context Cache. */
  get is ArmResourceRead<ContextCache>;

  /** Create or update a Context Cache. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ContextCache>;

  /** Update a Context Cache. */
  update is ArmCustomPatchAsync<ContextCache, ContextCacheUpdate>;

  /** Delete a Context Cache. */
  delete is ArmResourceDeleteWithoutOkAsync<ContextCache>;

  /** List Context Caches by resource group. */
  listByResourceGroup is ArmResourceListByParent<ContextCache>;

  /** List Context Caches by subscription. */
  listBySubscription is ArmListBySubscription<ContextCache>;
}

/** A container resource within a Context Cache */
@parentResource(ContextCache)
model ContextCacheContainer
  is ProxyResource<ContextCacheContainerProperties, false> {
  /** The name of the context cache container */
  @pattern("^[a-z0-9](?!.*--)[a-z0-9-]{1,61}[a-z0-9]$")
  @key("contextCacheContainerName")
  @segment("contextCacheContainers")
  @path
  name: string;
}

@armResourceOperations(ContextCacheContainer)
interface ContextCacheContainers {
  /** Get a container in a Context Cache. */
  get is ArmResourceRead<ContextCacheContainer>;

  /** Create or update a container in a Context Cache. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ContextCacheContainer>;

  /** Update a container in a Context Cache. */
  update is ArmCustomPatchAsync<
    ContextCacheContainer,
    ContextCacheContainerUpdate
  >;

  /** Delete a container from a Context Cache. */
  delete is ArmResourceDeleteWithoutOkAsync<ContextCacheContainer>;

  /** List all containers in a Context Cache. */
  listByContextCache is ArmResourceListByParent<ContextCacheContainer>;
}
