import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

namespace Microsoft.DataMigration;

@doc("The mode of the database migration.")
union MigrationMode {
  string,

  @doc("Offline migration mode")
  Offline: "offline",

  @doc("Online migration mode")
  Online: "online",
}

@doc("The source database engine type for migration service.")
union SourceDatabaseEngine {
  string,

  @doc("Oracle database engine")
  Oracle: "Oracle",

  @doc("PostgreSQL database engine")
  PostgreSQL: "PostgreSQL",
}

@doc("The target database engine type for migration service.")
union TargetDatabaseEngine {
  string,

  @doc("Azure Database for PostgreSQL")
  AzureDatabaseForPostgreSQL: "Azure Database for PostgreSQL",
}

@doc("The database engine type for connectivity testing.")
union DatabaseEngine {
  string,

  @doc("Oracle database engine")
  Oracle: "Oracle",

  @doc("PostgreSQL database engine")
  PostgreSQL: "PostgreSQL",

  @doc("Azure Database for PostgreSQL")
  AzureDatabaseForPostgreSQL: "Azure Database for PostgreSQL",
}

@doc("The source platform type for database migration.")
union MigrationSourceType {
  string,

  @doc("Amazon Web Services")
  AWS: "AWS",

  @doc("Google Cloud Platform")
  GCP: "GCP",

  @doc("Oracle Cloud")
  Oracle: "Oracle",

  @doc("On-premises")
  OnPrem: "OnPrem",
}

@doc("The target platform type for database migration.")
union MigrationTargetType {
  string,

  @doc("Azure PostgreSQL Flexible Server")
  AzurePostgreSQLFlexibleServer: "AzurePostgreSQLFlexibleServer",

  @doc("Azure PostgreSQL Horizon DB")
  AzurePostgreSQLHorizonDb: "AzurePostgreSQLHorizonDb",
}

@doc("The authentication method for database connection.")
union AuthenticationMethod {
  string,

  @doc("SQL authentication with username and password")
  SqlAuthentication: "sql_authentication",

  @doc("Password authentication")
  Password: "password",

  @doc("Windows authentication for SQL Server")
  WindowsAuthentication: "windows_authentication",

  @doc("Azure Active Directory integrated authentication")
  ActiveDirectoryIntegrated: "active_directory_integrated",

  @doc("Azure Active Directory authentication with username and password")
  ActiveDirectoryPassword: "active_directory_password",
}

@doc("The SSL mode for database connection.")
union SslMode {
  string,

  @doc("SslMode: None")
  None: "none",

  @doc("SSL is disabled. If the server requires SSL, the connection will fail.")
  Disable: "disable",

  @doc("Prefer non-SSL connections if the server allows them, but allow SSL connections.")
  Allow: "allow",

  @doc("Prefer SSL connections if the server allows them, but allow connections without SSL.")
  Prefer: "prefer",

  @doc("Fail the connection if the server doesn't support SSL.")
  Require: "require",

  @doc("Fail the connection if the server doesn't support SSL. Also verifies server certificate.")
  VerifyCA: "verify_ca",

  @doc("Fail the connection if the server doesn't support SSL. Also verifies server certificate with host's name.")
  VerifyFull: "verify_full",
}

@doc("The scope of the mapping.")
union MappingScope {
  string,

  @doc("Schema level mapping")
  Schema: "schema",

  @doc("Database level mapping")
  Database: "database",
}

@doc("The provisioning state of the resource.")
union ProvisioningState {
  string,

  @doc("Resource is being provisioned")
  Provisioning: "Provisioning",

  @doc("Resource provisioning succeeded")
  Succeeded: "Succeeded",

  @doc("Resource provisioning failed")
  Failed: "Failed",

  @doc("Resource provisioning was canceled")
  Canceled: "Canceled",

  @doc("Resource is being updated")
  Updating: "Updating",

  @doc("Resource is being deleted")
  Deleting: "Deleting",
}

@doc("The migration status state.")
union MigrationState {
  string,

  @doc("Migration is in progress")
  InProgress: "InProgress",

  @doc("Migration succeeded")
  Succeeded: "Succeeded",

  @doc("Migration failed")
  Failed: "Failed",

  @doc("Migration is pending")
  Pending: "Pending",

  @doc("Migration is cancelled")
  Cancelled: "Cancelled",

  @doc("Migration is being cancelled")
  Cancelling: "Cancelling",

  @doc("Cutover is in progress")
  CutoverInProgress: "CutoverInProgress",
}

@doc("The type of migration operation.")
union MigrationOperationType {
  string,

  @doc("Cancel the migration")
  Cancel: "cancel",

  @doc("Perform cutover")
  Cutover: "cutover",
}

@doc("The connection status.")
union ConnectionStatus {
  string,

  @doc("Connection test in progress")
  InProgress: "InProgress",

  @doc("Connection test succeeded")
  Succeeded: "Succeeded",

  @doc("Connection test failed")
  Failed: "Failed",
}

@doc("The connection endpoint type.")
union ConnectionType {
  string,

  @doc("Source connection")
  Source: "Source",

  @doc("Target connection")
  Target: "Target",
}

@doc("The migration phase.")
union MigrationPhase {
  string,

  @doc("Data migration phase")
  DataMigration: "DataMigration",

  @doc("Schema migration phase")
  SchemaMigration: "SchemaMigration",

  @doc("Validation phase")
  Validation: "Validation",

  @doc("Cutover phase")
  Cutover: "Cutover",
}

@doc("Error severity level.")
union ErrorSeverity {
  string,

  @doc("Critical error")
  Critical: "Critical",

  @doc("Error level severity")
  Error: "Error",

  @doc("Warning level severity")
  Warning: "Warning",

  @doc("Information")
  Info: "Info",
}

@doc("The readiness state of validation.")
union ValidationState {
  string,

  @doc("The validation is currently in progress.")
  InProgress: "InProgress",

  @doc("The validation has completed successfully.")
  Succeeded: "Succeeded",

  @doc("The validation has failed.")
  Failed: "Failed",
}

@doc("The readiness status of a check.")
union ValidationStatus {
  string,

  @doc("The check completed successfully without issues.")
  Succeeded: "Succeeded",

  @doc("The check failed with errors.")
  Failed: "Failed",

  @doc("The check completed with warnings.")
  Warning: "Warning",
}

@doc("Diagnostic severity level.")
union DiagnosticSeverity {
  string,

  @doc("Warning level diagnostic")
  Warning: "Warning",

  @doc("Error level diagnostic")
  Error: "Error",
}

@doc("SSL configuration for database connection.")
model SslConfiguration {
  @doc("SSL mode")
  mode: SslMode;
}

@doc("Credentials for database authentication.")
model DatabaseCredentials {
  @doc("Authentication method")
  authenticationMethod: AuthenticationMethod;

  @doc("User name for authentication")
  userName: string;

  @doc("Password for authentication")
  @secret
  password: string;
}

@doc("Connection endpoint for database.")
model ConnectionEndpoint {
  @doc("Connection name")
  connectionName: string;

  @doc("Host name of the database server")
  hostName: string;

  @doc("Port number")
  port: int32;

  @doc("Service name (for Oracle)")
  serviceName?: string;

  @doc("Database name")
  databaseName?: string;

  @doc("Database credentials")
  credentials: DatabaseCredentials;

  @doc("SSL configuration")
  ssl: SslConfiguration;
}

@doc("Connection endpoint for connectivity testing with type indicator.")
model CheckConnectivityEndpoint {
  ...ConnectionEndpoint;

  @doc("Database engine type for this endpoint")
  engine: DatabaseEngine;

  @doc("Server resource ID")
  serverResourceId?: string;

  @doc("Connection endpoint type")
  type: ConnectionType;
}

@doc("Source database configuration.")
model SourceConfiguration {
  @doc("Source database engine type")
  sourceEngine: SourceDatabaseEngine;

  @doc("Server resource ID")
  serverResourceId?: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "connectionName is the identifier"
  @doc("List of connection endpoints")
  connectionEndPoints: ConnectionEndpoint[];
}

@doc("Target database configuration.")
model TargetConfiguration {
  @doc("Target database engine type")
  targetEngine: TargetDatabaseEngine;

  @doc("Server resource ID")
  serverResourceId?: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "connectionName is the identifier"
  @doc("List of connection endpoints")
  connectionEndPoints: ConnectionEndpoint[];
}

@doc("Mapping definition for schema or database migration.")
model DatabaseMapping {
  @doc("Scope of the mapping")
  mappingScope: MappingScope;

  @doc("Source schema name")
  sourceSchemaName?: string;

  @doc("Source database name")
  sourceDatabaseName?: string;

  @doc("Target database name")
  targetDatabaseName?: string;

  @doc("Target schema name")
  targetSchemaName?: string;

  @doc("Source connection name")
  sourceConnectionName: string;

  @doc("Target connection name")
  targetConnectionName: string;
}

@doc("Migration job setting key-value pair.")
model MigrationJobSettings {
  @doc("The setting name.")
  settingName: string;

  @doc("The setting value.")
  settingValue: string;
}

@doc("Per-database migration status summary.")
model DatabaseSummary {
  @doc("Source database name")
  sourceDatabaseName: string;

  @doc("Target database name")
  targetDatabaseName: string;

  @doc("Aggregated status")
  status: MigrationState;

  @doc("Start time")
  startedAt?: utcDateTime;

  @doc("End time")
  endedAt?: utcDateTime;

  @doc("Total schemas")
  totalSchemas: int32;

  @doc("Completed schemas")
  completedSchemas: int32;

  @doc("Failed schemas")
  failedSchemas: int32;

  @doc("In-progress schemas")
  inProgressSchemas: int32;

  @doc("Total tables")
  totalTables: int32;

  @doc("Completed tables")
  completedTables: int32;

  @doc("Failed tables")
  failedTables: int32;

  @doc("In-progress tables")
  inProgressTables: int32;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "No identifier properties for this array"
  @doc("Errors at database scope")
  errors: MigrationError[];
}

@doc("Per-schema migration status.")
model SchemaSummaryModel {
  @doc("Source database name")
  sourceDatabaseName: string;

  @doc("Source schema name")
  sourceSchemaName: string;

  @doc("Target database name")
  targetDatabaseName: string;

  @doc("Target schema name")
  targetSchemaName: string;

  @doc("Migration status")
  status: MigrationState;

  @doc("Start time")
  startedAt?: utcDateTime;

  @doc("End time")
  endedAt?: utcDateTime;

  @doc("Total tables")
  totalTables: int32;

  @doc("Completed tables")
  completedTables: int32;

  @doc("Failed tables")
  failedTables: int32;

  @doc("In-progress tables")
  inProgressTables: int32;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "No identifier properties for this array"
  @doc("Errors at schema scope")
  errors: MigrationError[];
}

@doc("Per-table migration progress.")
model TableProgressModel {
  @doc("Source database name")
  sourceDatabaseName: string;

  @doc("Source schema name")
  sourceSchemaName: string;

  @doc("Source table name")
  sourceTableName: string;

  @doc("Target database name")
  targetDatabaseName: string;

  @doc("Target schema name")
  targetSchemaName: string;

  @doc("Target table name")
  targetTableName: string;

  @doc("Migration status")
  status: MigrationState;

  @doc("Start time")
  startedAt?: utcDateTime;

  @doc("End time")
  endedAt?: utcDateTime;

  @doc("Rows copied")
  rowsCopied: int64;

  @doc("Estimated total rows")
  totalRows: int64;

  @doc("Bytes copied")
  bytesCopied: int64;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "No identifier properties for this array"
  @doc("Errors at table scope")
  errors: MigrationError[];
}

@doc("Properties wrapper for DatabaseStatusResource (child proxy resource).")
model DatabaseStatusProperties {
  ...DatabaseSummary;

  @doc("Provisioning state")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Properties wrapper for SchemaStatusResource (child proxy resource).")
model SchemaStatusProperties {
  ...SchemaSummaryModel;

  @doc("Provisioning state")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Properties wrapper for TableStatusResource (child proxy resource).")
model TableStatusProperties {
  ...TableProgressModel;

  @doc("Provisioning state")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Error information.")
model MigrationError {
  @doc("Error code")
  errorCode: string;

  @doc("Error category")
  category: string;

  @doc("Error severity")
  severity: ErrorSeverity;

  @doc("Error message")
  message: string;

  @doc("Error details")
  details: string;
}

@doc("Overall migration status.")
model MigrationStatus {
  @doc("Current state of the migration")
  state: MigrationState;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "No identifier properties for this array"
  @doc("List of errors")
  errors: MigrationError[];

  @doc("Last updated timestamp")
  lastUpdatedAt: utcDateTime;
}

@doc("Diagnostic information for validation result.")
model ValidationDiagnostics {
  @doc("Diagnostic code")
  code: string;

  @doc("Diagnostic message")
  message: string;

  @doc("Severity of the diagnostic")
  severity: DiagnosticSeverity;

  @doc("Diagnostic hint to help resolve issues")
  diagnosticHint: string;
}

@doc("Validation result for a pre-migration check.")
model ValidationResult {
  @doc("Status of the validation check")
  status: ValidationStatus;

  @doc("Diagnostics information")
  diagnostics?: ValidationDiagnostics;
}

@doc("Summary of a pre-migration validation.")
model PreMigrationValidationSummary {
  @doc("Name of the validation")
  validationName: string;

  @doc("State of this specific validation")
  state: ValidationState;

  @doc("Detailed validation result for this check")
  validationResult?: ValidationResult;

  @doc("Scope of the validation check")
  scope?: string;

  @doc("Object name related to the validation")
  objectName?: string;

  @doc("Component related to the validation")
  component?: string;
}

@doc("Pre-migration validation status.")
model PreMigrationValidationStatus {
  @doc("Overall state of the pre-migration validation")
  state: ValidationState;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "validationName is the identifier"
  @doc("List of pre-migration validation summaries")
  preMigrationValidationSummaries?: PreMigrationValidationSummary[];
}

@doc("Properties of the DatabaseMigration resource.")
model DatabaseMigrationProperties {
  @doc("Migration name")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  migrationName: string;

  @doc("Migration description")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  description: string;

  @doc("Migration mode")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  migrationMode: MigrationMode;

  @doc("Migration source type")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  sourceType: MigrationSourceType;

  @doc("Migration target type")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  targetType: MigrationTargetType;

  @doc("Source database configuration")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  source: SourceConfiguration;

  @doc("Target database configuration")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  target: TargetConfiguration;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "No identifier properties for this array"
  @doc("List of mapping definitions")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  mappingDefinitions: DatabaseMapping[];

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "settingName is the identifier"
  @doc("Migration job settings")
  @visibility(Lifecycle.Create, Lifecycle.Read)
  migrationJobSettings: MigrationJobSettings[];

  @doc("The type of operation to perform on the migration")
  @visibility(Lifecycle.Create, Lifecycle.Update, Lifecycle.Read)
  operationType?: MigrationOperationType;

  @doc("Provisioning state")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @doc("Migration status")
  @visibility(Lifecycle.Read)
  migrationStatus?: MigrationStatus;

  @doc("Pre-migration validation status")
  @visibility(Lifecycle.Read)
  preMigrationValidations?: PreMigrationValidationStatus;

  @doc("Total number of databases in this migration")
  @visibility(Lifecycle.Read)
  totalDatabases?: int32;

  @doc("Number of databases that completed successfully")
  @visibility(Lifecycle.Read)
  completedDatabases?: int32;

  @doc("Number of databases that failed")
  @visibility(Lifecycle.Read)
  failedDatabases?: int32;

  @doc("Number of databases currently in progress")
  @visibility(Lifecycle.Read)
  inProgressDatabases?: int32;

  @doc("Total number of schemas in this migration")
  @visibility(Lifecycle.Read)
  totalSchemas?: int32;

  @doc("Number of schemas that completed successfully")
  @visibility(Lifecycle.Read)
  completedSchemas?: int32;

  @doc("Number of schemas that failed")
  @visibility(Lifecycle.Read)
  failedSchemas?: int32;

  @doc("Number of schemas currently in progress")
  @visibility(Lifecycle.Read)
  inProgressSchemas?: int32;

  @doc("Total number of tables in this migration")
  @visibility(Lifecycle.Read)
  totalTables?: int32;

  @doc("Number of tables that completed successfully")
  @visibility(Lifecycle.Read)
  completedTables?: int32;

  @doc("Number of tables that failed")
  @visibility(Lifecycle.Read)
  failedTables?: int32;

  @doc("Number of tables currently in progress")
  @visibility(Lifecycle.Read)
  inProgressTables?: int32;

  @doc("Migration start time")
  @visibility(Lifecycle.Read)
  startedAt?: utcDateTime;

  @doc("Migration end time")
  @visibility(Lifecycle.Read)
  endedAt?: utcDateTime;
}

@doc("The request body for updating a database migration.")
model DatabaseMigrationPatch {
  @doc("The database migration update properties.")
  properties?: DatabaseMigrationPatchProperties;
}

@doc("Properties for updating a database migration.")
model DatabaseMigrationPatchProperties {
  @doc("The type of operation to perform on the migration")
  operationType?: MigrationOperationType;
}

@doc("Request body for testing connectivity.")
model TestConnectivityRequest {
  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "No identifier properties for this array"
  @doc("Connection endpoints to test")
  connectionEndpoints: CheckConnectivityEndpoint[];
}

@doc("Connection test result for a single endpoint.")
model ConnectionTestResult {
  @doc("Connection name")
  connectionName: string;

  @doc("Connection status")
  connectionStatus: ConnectionStatus;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "No identifier properties for this array"
  @doc("List of errors encountered during connection test")
  errors: MigrationError[];
}

@doc("Properties of the connectivity test response.")
model ConnectivityTestProperties {
  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "connectionName is the identifier"
  @doc("Connection test results")
  connectionTestResults: ConnectionTestResult[];
}

@doc("Response for testing connectivity.")
model ConnectivityTestResult {
  @doc("Request identifier for tracking the operation")
  requestId: string;

  @doc("Connectivity test properties")
  properties?: ConnectivityTestProperties;
}

@doc("Request body for discovering database objects.")
model DiscoverDatabaseObjectsRequest {
  @doc("Source database configuration")
  source: SourceConfiguration;

  @doc("Target database configuration")
  target: TargetConfiguration;
}

@doc("Schema information.")
model SchemaInfo {
  @doc("Schema name")
  schemaName: string;
}

@doc("Database information with schemas.")
model DatabaseInfo {
  @doc("Database name")
  databaseName?: string;

  @doc("Service name (for Oracle)")
  serviceName?: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "schemaName is the identifier"
  @doc("List of schemas in the database")
  schemas: SchemaInfo[];
}

@doc("Discovered database objects for a connection.")
model DiscoveredDatabaseObjects {
  @doc("Connection name")
  connectionName: string;

  @doc("Database engine type")
  engine: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "databaseName and serviceName are identifiers"
  @doc("List of databases discovered")
  databases: DatabaseInfo[];
}

@doc("Response for discovering database objects.")
model DatabaseDiscoveryResult {
  @doc("Request identifier for tracking the operation")
  requestId?: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/missing-x-ms-identifiers" "connectionName is the identifier"
  @doc("Source database objects discovered")
  source: DiscoveredDatabaseObjects[];

  @doc("Target database objects discovered")
  target: DiscoveredDatabaseObjects;
}

@doc("Status response for connectivity test operation.")
model CheckConnectivityResult {
  @doc("Request identifier for tracking the operation")
  requestId?: string;

  @doc("Status properties")
  properties?: ConnectivityTestStatusProperties;
}

@doc("Properties of connectivity test status response.")
model ConnectivityTestStatusProperties {
  @doc("Operation status")
  status: OperationStatus;

  @doc("Connectivity test properties")
  testResults?: ConnectivityTestProperties;

  @doc("Error details if operation failed")
  error?: MigrationError;
}

@doc("Operation status enum.")
union OperationStatus {
  string,

  @doc("Operation is in progress")
  InProgress: "InProgress",

  @doc("Operation completed successfully")
  Succeeded: "Succeeded",

  @doc("Operation failed")
  Failed: "Failed",

  @doc("Operation was cancelled")
  Cancelled: "Cancelled",
}
