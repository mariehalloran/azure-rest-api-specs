import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "../common.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.Storage;

/** Properties linking the internal container resource back to the originating customer-facing Context Cache container resource. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheContainerResourceProperties {
  /** The ARM resource ID of the customer-facing Context Cache container resource. */
  resourceId?: string;

  /** The resource type of the customer-facing container resource (e.g., Microsoft.Storage/contextCaches/contextCacheContainers). */
  resourceType?: string;

  /** The base location (region) where the customer-facing resource resides. */
  baseLocation?: string;

  /** The ARM resource ID of the parent internal Context Cache resource. */
  parentResourceId?: string;
}

/** Details of a container within an internal Azure Context Cache Service Account. This resource is hidden from end users via AFEC and is managed internally by the resource provider. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheContainerProperties {
  /** Container description. */
  @maxLength(250)
  description?: string;

  /** The model name associated with this container (e.g., gpt-4, claude-3). */
  modelName: string;

  /** The AI provider associated with this container (e.g., OpenAI). */
  provider: AiProvider;

  /** Time to live in days after last access before container blobs are deleted. Must be between 1 and 30. */
  @minValue(1)
  @maxValue(30)
  timeToLive?: int32;

  /** The status of the last operation. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** Properties linking this internal container to the originating customer-facing Context Cache container resource. */
  resourceProperties: InternalContextCacheContainerResourceProperties;
}

/** The updatable properties of an internal Azure Context Cache container resource. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheContainerPropertiesUpdate {
  /** Container description. */
  @maxLength(250)
  description?: string;

  /** Time to live in days after last access before container blobs are deleted. Must be between 1 and 30. */
  @minValue(1)
  @maxValue(30)
  timeToLive?: int32;

  /** Properties linking this internal container to the originating customer-facing Context Cache container resource. */
  resourceProperties?: InternalContextCacheContainerResourceProperties;
}

/** The type used for update operations of an internal Azure Context Cache container resource. */
@added(Versions.v2026_02_01_preview)
model InternalContextCacheContainerUpdate {
  /** The updatable properties of the internal Azure Context Cache container resource. */
  properties?: InternalContextCacheContainerPropertiesUpdate;
}
