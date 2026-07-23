import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./Models.tsp";
import "./MigrationService.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

@armProviderNamespace
namespace Microsoft.DataMigration;

@doc("A database migration resource.")
@resource("migrations")
@parentResource(MigrationService)
model DatabaseMigration is ProxyResource<DatabaseMigrationProperties> {
  @doc("The database migration identifier.")
  @key("databaseMigrationId")
  @segment("migrations")
  @path
  @pattern("^[a-zA-Z0-9-_]*$")
  name: string;
}

@doc("A database-level migration status child resource.")
@resource("databaseStatuses")
@parentResource(DatabaseMigration)
model DatabaseStatusResource is ProxyResource<DatabaseStatusProperties> {
  @doc("The source database name.")
  @key("sourceDatabaseName")
  @segment("databaseStatuses")
  @path
  @pattern("^[a-zA-Z0-9-_.*]*$")
  name: string;
}

@doc("A schema-level migration status child resource.")
@resource("schemaStatuses")
@parentResource(DatabaseMigration)
model SchemaStatusResource is ProxyResource<SchemaStatusProperties> {
  @doc("The source schema identifier.")
  @key("sourceSchemaName")
  @segment("schemaStatuses")
  @path
  @pattern("^[a-zA-Z0-9-_.*]*$")
  name: string;
}

@doc("A table-level migration status child resource.")
@resource("tableStatuses")
@parentResource(DatabaseMigration)
model TableStatusResource is ProxyResource<TableStatusProperties> {
  @doc("The source table identifier.")
  @key("sourceTableName")
  @segment("tableStatuses")
  @path
  @pattern("^[a-zA-Z0-9-_.*]*$")
  name: string;
}
