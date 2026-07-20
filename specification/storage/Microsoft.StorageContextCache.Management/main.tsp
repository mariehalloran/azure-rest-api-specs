import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "./common.tsp";
import "./ContextCaches/contextCacheModels.tsp";
import "./ContextCacheContainers/contextCacheContainerModels.tsp";
import "./InternalContextCaches/internalContextCacheModels.tsp";
import "./InternalContextCacheContainers/internalContextCacheContainerModels.tsp";

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

  /** 2026-02-01-preview version */
  @useDependency(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_02_01_preview: "2026-02-01-preview",
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
model ContextCacheContainer is ProxyResource<
  ContextCacheContainerProperties,
  false
> {
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

// ─── Internal (location-based, ProxyOnly) resource types ────────────────────
// Hidden from end users via AFEC flag AllowInternalUserRPResourceTypes.
// RoutingType: ProxyOnly, LocationBased. Regionality: Regional.
// ARM metadata is stored in RPaaS (MetaRP), not tracked by ARM.
// ─────────────────────────────────────────────────────────────────────────────

/** An internal Azure Context Cache resource. This is a ProxyOnly, location-based resource hidden from end users via AFEC. Metadata is stored in RPaaS. */
@added(Versions.v2026_02_01_preview)
@parentResource(ResourceGroupLocationResource)
model InternalContextCache is ProxyResource<
  InternalContextCacheProperties,
  false
> {
  /** The name of the internal Azure Context Cache resource. */
  @pattern("^[a-z0-9][a-z0-9-]{1,22}[a-z0-9]$")
  @key("internalContextCacheName")
  @segment("internalContextCaches")
  @path
  name: string;
}

@added(Versions.v2026_02_01_preview)
@armResourceOperations(InternalContextCache)
interface InternalContextCaches {
  /** Get an internal Azure Context Cache resource. */
  get is ArmResourceRead<InternalContextCache>;

  /** List internal Azure Context Cache resources by location. */
  listByLocation is ArmResourceListByParent<InternalContextCache>;

  /** Create or update an internal Azure Context Cache resource. For RPaaS-internal use only. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<InternalContextCache>;

  /** Update an internal Azure Context Cache resource. For RPaaS-internal use only. */
  update is ArmCustomPatchAsync<
    InternalContextCache,
    InternalContextCacheUpdate
  >;

  /** Delete an internal Azure Context Cache resource. For RPaaS-internal use only. */
  delete is ArmResourceDeleteWithoutOkAsync<InternalContextCache>;
}

/** An internal container resource within an internal Azure Context Cache resource. This is a ProxyOnly resource hidden from end users via AFEC. */
@added(Versions.v2026_02_01_preview)
@parentResource(InternalContextCache)
model InternalContextCacheContainer is ProxyResource<
  InternalContextCacheContainerProperties,
  false
> {
  /** The name of the internal container. */
  @pattern("^[a-z0-9](?!.*--)[a-z0-9-]{1,61}[a-z0-9]$")
  @key("internalContextCacheContainerName")
  @segment("internalContextCacheContainers")
  @path
  name: string;
}

@added(Versions.v2026_02_01_preview)
@armResourceOperations(InternalContextCacheContainer)
interface InternalContextCacheContainers {
  /** Get a container in an internal Azure Context Cache resource. */
  get is ArmResourceRead<InternalContextCacheContainer>;

  /** List all containers in an internal Azure Context Cache resource. */
  listByAccount is ArmResourceListByParent<InternalContextCacheContainer>;

  /** Create or update a container in an internal Azure Context Cache resource. For RPaaS-internal use only. */
  createOrUpdate is ArmResourceCreateOrUpdateAsync<InternalContextCacheContainer>;

  /** Update a container in an internal Azure Context Cache resource. For RPaaS-internal use only. */
  update is ArmCustomPatchAsync<
    InternalContextCacheContainer,
    InternalContextCacheContainerUpdate
  >;

  /** Delete a container from an internal Azure Context Cache resource. For RPaaS-internal use only. */
  delete is ArmResourceDeleteWithoutOkAsync<InternalContextCacheContainer>;
}
