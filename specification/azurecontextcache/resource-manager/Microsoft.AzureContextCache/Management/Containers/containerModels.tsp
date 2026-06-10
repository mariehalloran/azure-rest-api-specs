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

namespace Microsoft.AzureContextCache;

/** Details of a container within a Context Cache Account. */
model ContainerProperties {
  /** Container description. */
  @maxLength(250)
  description?: string;

  /** The model name associated with this container (e.g., gpt-4, claude-3). */
  @visibility(Lifecycle.Create, Lifecycle.Read)
  modelName: string;

  /** The AI provider associated with this container. */
  @visibility(Lifecycle.Create, Lifecycle.Read)
  provider: AiProvider;

  /** The Time to Live (TTL) in days between 1-30 days for this container, after which it will be automatically deleted. If not specified at creation time, it defaults to 1 day. */
  @minValue(1)
  @maxValue(30)
  timeToLive?: int32 = 1;

  /** The status of the last operation. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** Updatable properties of a container within a Context Cache Account. */
model ContainerPropertiesUpdate {
  /** Container description. */
  @maxLength(250)
  description?: string;

  /** Time to live in days after last access before container blobs are deleted. Must be between 1 and 30. */
  @minValue(1)
  @maxValue(30)
  timeToLive?: int32;
}

/** The type used for update operations of the Container. */
model ContainerUpdate {
  /** The updatable properties of the Container. */
  properties?: ContainerPropertiesUpdate;
}
