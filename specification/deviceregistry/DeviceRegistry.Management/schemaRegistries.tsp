import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./common/provisioningState.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;
using OpenAPI;

namespace Microsoft.DeviceRegistry;

@added(Versions.v2024_07_01_preview)
@doc("Schema registry definition.")
model SchemaRegistry is TrackedResource<SchemaRegistryProperties> {
  @doc("Schema registry name parameter.")
  @key("schemaRegistryName")
  @segment("schemaRegistries")
  @pattern("^[a-z0-9][a-z0-9-]*[a-z0-9]$")
  @path
  @minLength(3)
  @maxLength(63)
  name: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Explicit identity property required for @typeChangedFrom versioning"
  @doc("The managed service identities assigned to this resource.")
  @typeChangedFrom(
    Versions.v2026_11_01_preview,
    Azure.ResourceManager.CommonTypes.SystemAssignedServiceIdentity
  )
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentity;
}

@added(Versions.v2024_07_01_preview)
@doc("Defines the schema registry properties.")
model SchemaRegistryProperties {
  @doc("Globally unique, immutable, non-reusable ID.")
  @visibility(Lifecycle.Read)
  uuid?: string;

  @doc("Schema registry namespace. Uniquely identifies a schema registry within a tenant.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @pattern("^[a-z0-9][a-z0-9-]*[a-z0-9]$")
  @maxLength(32)
  `namespace`: string;

  @doc("Human-readable display name.")
  displayName?: string;

  @doc("Human-readable description of the schema registry.")
  description?: string;

  @doc("The Storage Account's Container URL where schemas will be stored.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  storageAccountContainerUrl: string;

  @added(Versions.v2026_11_01_preview)
  @doc("The identity used for outbound calls from the ADR schema registry. If not specified and the schema registry has a system-assigned identity enabled, the system-assigned identity is used by default.")
  outboundIdentity?: OutboundIdentity;

  @doc("Provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2024_07_01_preview)
@parentResource(SchemaRegistry)
@doc("Schema definition.")
model Schema is ProxyResource<SchemaProperties> {
  @doc("Schema name parameter.")
  @key("schemaName")
  @segment("schemas")
  @pattern("^[a-z0-9][a-z0-9-]*[a-z0-9]$")
  @path
  @minLength(3)
  @maxLength(64)
  name: string;
}

@added(Versions.v2024_07_01_preview)
@doc("Defines the schema properties.")
model SchemaProperties {
  @doc("Globally unique, immutable, non-reusable ID.")
  @visibility(Lifecycle.Read)
  uuid?: string;

  @doc("Human-readable display name.")
  displayName?: string;

  @doc("Human-readable description of the schema.")
  description?: string;

  @doc("Format of the schema.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  format: Format;

  @doc("Type of the schema.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  schemaType: SchemaType;

  @doc("Provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" ""
  @doc("Schema tags.")
  // Allowed scenario as per user-defined tags: https://github.com/Azure/azure-openapi-validator/blob/main/docs/avoid-additional-properties.md
  tags?: Record<string>;
}

@added(Versions.v2024_07_01_preview)
@doc("Defines the schema format.")
union Format {
  @doc("JSON Schema version draft 7 format")
  JsonSchema_draft7: "JsonSchema/draft-07",

  @doc("Delta format")
  Delta_1_0: "Delta/1.0",

  @added(Versions.v2026_11_01_preview)
  @doc("W3C Web of Things JSON-LD format")
  JsonLD_1_1: "JsonLD/1.1",

  string,
}

@added(Versions.v2024_07_01_preview)
@doc("Defines the schema type.")
union SchemaType {
  @doc("Message Schema schema type")
  MessageSchema: "MessageSchema",

  @added(Versions.v2026_11_01_preview)
  @doc("W3C Web of Things Thing Model document")
  ThingModel: "ThingModel",

  @added(Versions.v2026_11_01_preview)
  @doc("W3C Web of Things Thing Description document")
  ThingDescription: "ThingDescription",

  string,
}

@added(Versions.v2024_07_01_preview)
@parentResource(Schema)
@doc("Schema version's definition.")
model SchemaVersion is ProxyResource<SchemaVersionProperties> {
  @doc("Schema version name parameter.")
  @key("schemaVersionName")
  @segment("schemaVersions")
  @pattern("^[0-9]*$")
  @path
  @minLength(1)
  @maxLength(10)
  name: string;
}

@added(Versions.v2024_07_01_preview)
@doc("Defines the schema version properties.")
model SchemaVersionProperties {
  @doc("Globally unique, immutable, non-reusable ID.")
  @visibility(Lifecycle.Read)
  uuid?: string;

  @doc("Human-readable description of the schema.")
  description?: string;

  @doc("Schema content.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  schemaContent: string;

  @doc("Hash of the schema content.")
  @visibility(Lifecycle.Read)
  hash?: string;

  @doc("Provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@added(Versions.v2024_07_01_preview)
@armResourceOperations
interface SchemaRegistries {
  get is ArmResourceRead<SchemaRegistry>;
  createOrReplace is ArmResourceCreateOrReplaceAsync<SchemaRegistry>;
  update is ArmResourcePatchAsync<SchemaRegistry, SchemaRegistryProperties>;
  delete is ArmResourceDeleteWithoutOkAsync<SchemaRegistry>;
  listByResourceGroup is ArmResourceListByParent<SchemaRegistry>;
  listBySubscription is ArmListBySubscription<SchemaRegistry>;
}

@added(Versions.v2024_07_01_preview)
@armResourceOperations
interface Schemas {
  get is ArmResourceRead<Schema>;
  createOrReplace is ArmResourceCreateOrReplaceSync<Schema>;
  @added(Versions.v2024_07_01_preview)
  @removed(Versions.v2026_02_01_preview)
  @sharedRoute
  @renamedFrom(Versions.v2026_02_01_preview, "delete")
  deleteSync is ArmResourceDeleteSync<Schema>;

  @added(Versions.v2026_02_01_preview)
  @sharedRoute
  delete is ArmResourceDeleteWithoutOkAsync<Schema>;
  listBySchemaRegistry is ArmResourceListByParent<Schema>;
}

@added(Versions.v2024_07_01_preview)
@armResourceOperations
interface SchemaVersions {
  get is ArmResourceRead<SchemaVersion>;
  createOrReplace is ArmResourceCreateOrReplaceSync<SchemaVersion>;
  @added(Versions.v2024_07_01_preview)
  @removed(Versions.v2026_02_01_preview)
  @sharedRoute
  @renamedFrom(Versions.v2026_02_01_preview, "delete")
  deleteSync is ArmResourceDeleteSync<SchemaVersion>;

  @added(Versions.v2026_02_01_preview)
  @sharedRoute
  delete is ArmResourceDeleteWithoutOkAsync<SchemaVersion>;
  listBySchema is ArmResourceListByParent<SchemaVersion>;
}
