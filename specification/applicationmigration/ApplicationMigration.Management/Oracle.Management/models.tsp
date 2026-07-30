import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@typespec/openapi";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using Versioning;

namespace Microsoft.ApplicationMigration;

@doc("Definition of Server Parameter")
model ServerParameter {
  @doc("Property key")
  key?: string;

  @doc("Property value")
  value?: string;
}

@doc("Base tracked resource type for PATCH updates.")
model TagsUpdate {
  ...ArmTagsProperty;
}

/**
 * Represents the Provisioning State of a resource.
 * Gets or sets the provisioning state.
 */
@doc("The status of the current operation.")
union ProvisioningState {
  string,

  @doc("Unknown provisioning state.")
  Unknown: "Unknown",

  @doc("Succeeded provisioning state.")
  Succeeded: "Succeeded",

  @doc("Failed provisioning state.")
  Failed: "Failed",

  @doc("Canceled provisioning state.")
  Canceled: "Canceled",

  @doc("Creating provisioning state.")
  Creating: "Creating",

  @doc("Deleting provisioning state.")
  Deleting: "Deleting",

  @doc("Updating provisioning state.")
  Updating: "Updating",
}

@doc("Common properties for all azure tracked and proxy resources.")
model AzureResourceProperties {
  @doc("The status of the last operation.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/**
 * Represents an Enum with boolean values.
 */
union BoolValue {
  @doc("Represents an unknown value.")
  Unknown: "Unknown",

  @doc("Represents a true boolean value.")
  True: "True",

  @doc("Represents a false boolean value.")
  False: "False",

  string,
}

/**
 * Represents the Support status of the Oracle instance.
 */
union SupportStatus {
  string,

  /**
   * Unknown support status.
   */
  Unknown: "Unknown",

  /**
   * Premier support status.
   */
  Premier: "Premier",

  /**
   * Mainstream support status.
   */
  Mainstream: "Mainstream",

  /**
   * Extended support status.
   */
  Extended: "Extended",

  /**
   * Sustaining support status.
   */
  Sustaining: "Sustaining",

  /**
   * Out of support status.
   */
  OutOfSupport: "OutOfSupport",

  /**
   * Desupported support status.
   */
  Desupported: "Desupported",
}

/**
 * Custom property with mixed value types
 */
@doc("Custom property with mixed value types")
@added(Versions.v2026_02_01_preview)
model CustomProperties {
  @doc("Property key")
  key: string;

  @doc("Property value - string")
  value: string;
}

/**
 * Software-specific attributes and metadata
 */
@doc("Software-specific attributes and metadata")
@added(Versions.v2026_02_01_preview)
model SoftwareAttributes {
  @doc("Name of the software (e.g., Oracle)")
  softwareName?: string;

  @doc("Name of the software provider or vendor")
  providerName?: string;

  @doc("Version of the software")
  softwareVersion?: string;

  @doc("Unique identifier for the software instance")
  softwareId?: string;

  @doc("List of additional custom properties with string value types")
  @identifiers(#["key"])
  customProperties?: CustomProperties[];
}

/**
 * Represents the Edition of the Oracle instance.
 */
union Edition {
  string,

  /**
   * Unknown edition.
   */
  Unknown: "Unknown",

  /**
   * Standard edition.
   */
  Standard: "Standard",

  /**
   * Enterprise edition.
   */
  Enterprise: "Enterprise",

  /**
   * Express edition.
   */
  Express: "Express",

  /**
   * Personal edition.
   */
  Personal: "Personal",
}

/**
 * Represents the Collation Provider for Oracle.
 */
union CollationProvider {
  string,

  /**
   * UNKNOWN collation provider.
   */
  UNKNOWN: "UNKNOWN",

  /**
   * DEFAULT collation provider.
   */
  DEFAULT: "DEFAULT",

  /**
   * NLS_SORT collation provider.
   */
  NLS_SORT: "NLS_SORT",

  /**
   * NLS_COMP collation provider.
   */
  NLS_COMP: "NLS_COMP",
}

/**
 * Represents the supported character sets in Oracle (NLS_CHARACTERSET).
 */
union Encoding {
  string,

  /**
   * Unknown Encoding.
   */
  UNKNOWN: "UNKNOWN",

  /**
   * Unicode UTF-8 Universal character set (recommended for new databases).
   */
  AL32UTF8: "AL32UTF8",

  /**
   * Unicode UTF-16 Universal character set.
   */
  AL16UTF16: "AL16UTF16",

  /**
   * US 7-bit ASCII character set.
   */
  US7ASCII: "US7ASCII",

  /**
   * Western European ISO 8859-1.
   */
  WE8ISO8859P1: "WE8ISO8859P1",

  /**
   * Western European ISO 8859-15 (with Euro sign).
   */
  WE8ISO8859P15: "WE8ISO8859P15",

  /**
   * Western European Windows code page 1252.
   */
  WE8MSWIN1252: "WE8MSWIN1252",

  /**
   * Eastern European ISO 8859-2.
   */
  EE8ISO8859P2: "EE8ISO8859P2",

  /**
   * Eastern European Windows code page 1250.
   */
  EE8MSWIN1250: "EE8MSWIN1250",

  /**
   * Cyrillic ISO 8859-5.
   */
  CL8ISO8859P5: "CL8ISO8859P5",

  /**
   * Cyrillic Windows code page 1251.
   */
  CL8MSWIN1251: "CL8MSWIN1251",

  /**
   * Cyrillic KOI8-R for Russian.
   */
  CL8KOI8R: "CL8KOI8R",

  /**
   * Cyrillic KOI8-U for Ukrainian.
   */
  CL8KOI8U: "CL8KOI8U",

  /**
   * Arabic ISO 8859-6.
   */
  AR8ISO8859P6: "AR8ISO8859P6",

  /**
   * Arabic Windows code page 1256.
   */
  AR8MSWIN1256: "AR8MSWIN1256",

  /**
   * Greek ISO 8859-7.
   */
  EL8ISO8859P7: "EL8ISO8859P7",

  /**
   * Greek Windows code page 1253.
   */
  EL8MSWIN1253: "EL8MSWIN1253",

  /**
   * Hebrew ISO 8859-8.
   */
  IW8ISO8859P8: "IW8ISO8859P8",

  /**
   * Hebrew Windows code page 1255.
   */
  IW8MSWIN1255: "IW8MSWIN1255",

  /**
   * Turkish ISO 8859-9.
   */
  TR8ISO8859P9: "TR8ISO8859P9",

  /**
   * Turkish Windows code page 1254.
   */
  TR8MSWIN1254: "TR8MSWIN1254",

  /**
   * Baltic ISO 8859-13.
   */
  BLT8ISO8859P13: "BLT8ISO8859P13",

  /**
   * Baltic Windows code page 1257.
   */
  BLT8MSWIN1257: "BLT8MSWIN1257",

  /**
   * Vietnamese Windows code page 1258.
   */
  VN8MSWIN1258: "VN8MSWIN1258",

  /**
   * Thai Windows code page 874.
   */
  TH8TISASCII: "TH8TISASCII",

  /**
   * Japanese Shift-JIS.
   */
  JA16SJIS: "JA16SJIS",

  /**
   * Japanese Shift-JIS (TILDE variant).
   */
  JA16SJISTILDE: "JA16SJISTILDE",

  /**
   * Japanese EUC.
   */
  JA16EUC: "JA16EUC",

  /**
   * Japanese EUC (TILDE variant).
   */
  JA16EUCTILDE: "JA16EUCTILDE",

  /**
   * Simplified Chinese GBK.
   */
  ZHS16GBK: "ZHS16GBK",

  /**
   * Simplified Chinese GB18030.
   */
  ZHS32GB18030: "ZHS32GB18030",

  /**
   * Traditional Chinese Big5.
   */
  ZHT16BIG5: "ZHT16BIG5",

  /**
   * Traditional Chinese HKSCS (Hong Kong Supplementary Character Set).
   */
  ZHT16HKSCS: "ZHT16HKSCS",

  /**
   * Traditional Chinese Microsoft Windows code page 950.
   */
  ZHT16MSWIN950: "ZHT16MSWIN950",

  /**
   * Korean KSC5601.
   */
  KO16KSC5601: "KO16KSC5601",

  /**
   * Korean Windows code page 949.
   */
  KO16MSWIN949: "KO16MSWIN949",

  /**
   * Russian Windows code page 866.
   */
  RU8PC866: "RU8PC866",
}

/**
 * Represents the Language supported by Oracle.
 */
union Language {
  string,

  /**
   * UNKNOWN edition.
   */
  UNKNOWN: "UNKNOWN",

  /**
   * SQL language.
   */
  SQL: "SQL",

  /**
   * PLSQL language
   */
  PLSQL: "PLSQL",

  /**
   * JAVA language.
   */
  JAVA: "JAVA",

  /**
   * C language.
   */
  /**
   * C language.
   */
  C: "C",
}

/**
 * Represents the TLS version.
 */
union TlsVersion {
  string,

  /**
   * UNKNOWN TLS version.
   */
  UNKNOWN: "UNKNOWN",

  /**
   * TLS version 1.0.
   */
  Tls1_0: "Tls1_0",

  /**
   * TLS version 1.1.
   */
  Tls1_1: "Tls1_1",

  /**
   * TLS version 1.2.
   */
  Tls1_2: "Tls1_2",

  /**
   * TLS version 1.3.
   */
  Tls1_3: "Tls1_3",
}

/**
 * Represents the Auth method.
 */
union OracleAuthenticationMethod {
  string,

  /**
   * UNKNOWN Authentication method version.
   */
  UNKNOWN: "UNKNOWN",

  /**
   * Password-based authentication.
   */
  PASSWORD: "PASSWORD",

  /**
   * External authentication (e.g., certificates, third-party).
   */
  EXTERNAL: "EXTERNAL",

  /**
   * Kerberos network authentication protocol.
   */
  KERBEROS: "KERBEROS",

  /**
   * Secure Sockets Layer (SSL) authentication.
   */
  SSL: "SSL",

  /**
   * RADIUS (Remote Authentication Dial-In User Service).
   */
  RADIUS: "RADIUS",

  /**
   * Operating system authentication.
   */
  OS: "OS",

  /**
   * Global authentication (shared across systems).
   */
  GLOBAL: "GLOBAL",
}

/**
 * Represents the configuration of the database.
 */
union DataBasePlatformType {
  string,

  /**
   * Unknown .
   */
  Unknown: "Unknown",

  /**
   * Standalone .
   */
  STANDALONE: "STANDALONE",

  /**
   * Real Application Cluster (RAC) .
   */
  RAC: "RAC",

  /**
   * Real Application Cluster One Node (RAC ONE NODE) .
   */
  RAC_ONE_NODE: "RAC_ONE_NODE",

  /**
   * Oracle Restart (Single Instance High Availability).
   */
  ORACLE_RESTART: "ORACLE_RESTART",
}

/**
 * Represents the infrastructure type of the database. i.e standard, exadata, autonomous.
 */
union DatabaseInfrastructureType {
  string,

  /**
   * Unknown .
   */
  Unknown: "Unknown",

  /**
   * Oracle running on standard infrastructure
   * (VMware, Hyper-V, Physical, Azure VM, AWS, OCI Compute, etc.)
   */
  STANDARD: "STANDARD",

  /**
   * Oracle running on Exadata infrastructure.
   */
  EXADATA: "EXADATA",

  /**
   * Oracle Autonomous Database.
   */
  AUTONOMOUS: "AUTONOMOUS",
}

/**
 * List of Sites.
 */
model OracleSiteList is Azure.Core.Page<OracleSite>;

/**
 * Oracle Site properties
 */
model OracleSiteProperties is AzureResourceProperties {
  /**
   * The mapped master Site Id.
   */
  masterSiteId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OffAzure/masterSites";
    }
  ]>;

  /**
   * The mapped migrate project Id.
   */
  migrateProjectId: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Migrate/migrateProjects";
    }
  ]>;

  /**
   * The extended location.
   */
  extendedLocation?: ExtendedLocation;
}

/**
 * The extended location for off-azure resources.
 */
model ExtendedLocation {
  /**
   * The extended location type.
   */
  type?: string;

  /**
   * The extended location name.
   */
  name?: string;
}

/**
 * Object containing tags updates for patch operations.
 */
model OracleSitesResourcePatch {
  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record"
  tags?: Record<string>;

  /**
   * The OracleSites resource definition.
   */
  properties?: OracleSiteProperties;
}

/**
 * List of Servers.
 */
model OracleInstanceList is Azure.Core.Page<OracleInstance>;

/**
 * Oracle Server properties
 */
model OracleInstanceProperties is AzureResourceProperties {
  /**
   * The Server IP/host name.
   */
  hostName: string;

  /**
   *The Server IP in ipv4/ipv6 format.
   */
  hostIp?: string[];

  /**
   * discovery Machine Ids
   */
  machineArmIds?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OffAzure/serverSites/machines";
    }
  ]>[];

  /**
   * The host machine properties.
   */
  hostMachineProperties?: HostMachineProperties;

  /**
   * Oracle Server port number
   */
  portNumber: int32;

  /**
   * The oracle server version.
   */
  version?: string;

  /**
   * The number of database.
   */
  numberOfDatabase?: int64;

  /**
   * oracle version support status.
   */
  supportStatus?: SupportStatus;

  /**
   * Oracle instance edition.
   */
  edition?: Edition;

  /**
   * Time when oracle instance version support end.
   */
  endOfSupportDate?: plainDate;

  /**
   * The list of errors.
   */
  errors?: Error[];

  /**
   * The number of errors.
   */
  errorCount?: int64;

  /**
   * The list of collations in the database.
   */
  @identifiers(#["name", "locale", "collationProvider", "isDeterministic"])
  collations?: Collation[];

  /**
   * Dictionary of server parameters for the instance
   */
  @identifiers(#["key", "value"])
  serverParameters?: ServerParameter[];

  /**
   * List of tablespaces in the instance.
   */
  tableSpaces?: string[];

  /**
   * List of non-default tablespaces in the instance.
   */
  nonDefaultTableSpaces?: string[];

  /**
   * Gets or sets storage size of Oracle instance.
   */
  storageSizeInMb?: float32;

  /**
   * The maximum number of connections allowed in the instance
   */
  maxConnections?: int64;

  /**
   * Specifies the TLS version used by the system.
   */
  tlsVersion?: TlsVersion;

  /**
   * Specifies the Oracle authentication method used by the system.
   */
  oracleAuthMethod?: OracleAuthenticationMethod;

  /**
   * Indicates whether the system supports SSL connections.
   */
  supportsSsl?: BoolValue;

  /**
   * Indicates whether the system supports IPv6 connections.
   */
  supportsIpv6Connections?: BoolValue;

  /**
   * Indicates whether the system supports IPv4 connections.
   */
  supportsIpv4Connections?: BoolValue;

  /**
   * Indicates whether Deep Discovery has been performed on the instance.
   */
  deepDiscoveryPerformed?: BoolValue;

  /**
   * Indicates whether disaster recovery (DR) functionality is enabled.
   */
  isDrEnabled?: BoolValue;

  /**
   * Indicates whether the super user access is enabled on the instance.
   */
  isSuperUserAccessEnabled?: BoolValue;

  /**
   * Software-specific attributes and metadata for the discovered Oracle instance.
   */
  @doc("Software-specific attributes and metadata for the discovered Oracle instance.")
  @added(Versions.v2026_02_01_preview)
  softwareAttributes?: SoftwareAttributes;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record"
  tags?: Record<string>;

  /**
   * The display name of the Oracle instance.
   */
  displayName?: string;

  /**
   * The Oracle System Identifier (serviceId) for the instance.
   */
  serviceId: string;

  /**
   * The number of pluggable databases (PDBs) in the instance.
   */
  pdbCount?: int64;

  /**
   * The database type (e.g., Container Database (CDB) or Non-Container Database (NON-CDB)).
   */
  dbType?: string;

  /**
   * The database Name
   */
  dbName?: string;

  /**
   * The unique name of the database.
   */
  dbUniqueName?: string;

  /**
   * The CPU count of the database.
   */
  dbCpuCount?: int64;

  /**
   * The CPU core count of the database.
   */
  dbCpuCoreCount?: int64;

  /**
   * The database platform type, i.e standlone, RAC.
   */
  dbPlatformType?: DataBasePlatformType;

  /**
   * The database infrastructure type, i.e standard, exadata, autonomous.
   */
  dbInfrastructureType?: DatabaseInfrastructureType;

  /**
   * The list of database features, i.e. partitioning, olap, spatial, inmemory, asm, dataguard, multitenant etc.
   */
  dbFeatures?: string[];

  /**
   * The size of the SGA memory.
   */
  memSgaSize?: int64;

  /**
   * The size of the PGA memory.
   */
  memPgaSize?: int64;

  /**
   * The log mode of the database.
   */
  dbLogMode?: string;

  /**
   * The operating mode of the database.
   */
  dbOperatingMode?: string;

  /**
   * The data protection mode of the database.
   */
  dbDataProtectionMode?: string;

  /**
   * Indicates whether HA/DR broker is enabled.
   */
  dbHaDrBroker?: string;

  /**
   * The database deployment configuration.
   */
  dbConfiguration?: string;

  /**
   * The role of the database in a cluster.
   */
  dbDatabaseRole?: string;

  /**
   * The flashback status of the database.
   */
  dbFlashbackStatus?: string;

  /**
   * Current system change number for the database.
   */
  dbCurrentScn?: int64;

  /**
   * Count of database file segments on storage disks.
   */
  dbFileSegmentCount?: int64;

  /**
   * Total size of database file segments in MB.
   */
  dbFileSegmentSize?: float32;

  /**
   * The count of OS processes for the CPU.
   */
  cpuOsProcessCount?: int64;

  /**
   * The process limit for the CPU.
   */
  cpuProcessLimit?: float32;

  /**
   * The recent critical errors of the database.
   */
  recentCriticalErrors?: string[];
}

/**
 * Oracle Server properties
 */
model OracleInstanceResourcePatchProperties {
  /**
   * Oracle Instance resource patch properties object.
   */
  properties?: OracleInstanceResourcePatch;
}

/**
 * Oracle Server properties
 */
model OracleInstanceResourcePatch {
  /**
   * The Server IP/host name.
   */
  hostName?: string;

  /**
   * The Server IP in ipv4/ipv6 format.
   */
  hostIp?: string[];

  /**
   * discovery Machine Ids
   */
  machineArmIds?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OffAzure/serverSites/machines";
    }
  ]>[];

  /**
   * The host machine properties.
   */
  hostMachineProperties?: HostMachineProperties;

  /**
   * Oracle Server port number
   */
  portNumber?: int32;

  /**
   * The oracle server version.
   */
  version?: string;

  /**
   * The number of database.
   */
  numberOfDatabase?: int64;

  /**
   * oracle version support status.
   */
  supportStatus?: SupportStatus;

  /**
   * Oracle instance edition.
   */
  edition?: Edition;

  /**
   * Time when oracle instance version support end.
   */
  endOfSupportDate?: plainDate;

  /**
   * The list of errors.
   */
  errors?: Error[];

  /**
   * The number of errors.
   */
  errorCount?: int64;

  /**
   * The list of collations in the database.
   */
  @identifiers(#["name", "locale", "collationProvider", "isDeterministic"])
  collations?: Collation[];

  /**
   * Dictionary of server parameters for the instance
   */
  @identifiers(#["key", "value"])
  serverParameters?: ServerParameter[];

  /**
   * List of tablespaces in the instance.
   */
  tableSpaces?: string[];

  /**
   * List of non-default tablespaces in the instance.
   */
  nonDefaultTableSpaces?: string[];

  /**
   * Gets or sets storage size of Oracle instance.
   */
  storageSizeInMb?: float32;

  /**
   * The maximum number of connections allowed in the instance
   */
  maxConnections?: int64;

  /**
   * Specifies the TLS version used by the system.
   */
  tlsVersion?: TlsVersion;

  /**
   * Specifies the Oracle authentication method used by the system.
   */
  oracleAuthMethod?: OracleAuthenticationMethod;

  /**
   * Indicates whether the system supports SSL connections.
   */
  supportsSsl?: BoolValue;

  /**
   * Indicates whether the system supports IPv6 connections.
   */
  supportsIpv6Connections?: BoolValue;

  /**
   * Indicates whether the system supports IPv4 connections.
   */
  supportsIpv4Connections?: BoolValue;

  /**
   * Indicates whether Deep Discovery has been performed on the instance.
   */
  deepDiscoveryPerformed?: BoolValue;

  /**
   * Indicates whether disaster recovery (DR) functionality is enabled.
   */
  isDrEnabled?: BoolValue;

  /**
   * Indicates whether the super user access is enabled on the instance.
   */
  isSuperUserAccessEnabled?: BoolValue;

  /**
   * Software-specific attributes and metadata for the discovered Oracle instance.
   */
  @doc("Software-specific attributes and metadata for the discovered Oracle instance.")
  @added(Versions.v2026_02_01_preview)
  softwareAttributes?: SoftwareAttributes;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record"
  tags?: Record<string>;

  /**
   * The display name of the Oracle instance.
   */
  displayName?: string;

  /**
   * The Oracle System Identifier (serviceId) for the instance.
   */
  serviceId?: string;

  /**
   * The number of pluggable databases (PDBs) in the instance.
   */
  pdbCount?: int64;

  /**
   * The database type (e.g., Container Database (CDB) or Non-Container Database (NON-CDB)).
   */
  dbType?: string;

  /**
   * The database Name
   */
  dbName?: string;

  /**
   * The unique name of the database.
   */
  dbUniqueName?: string;

  /**
   * The CPU count of the database.
   */
  dbCpuCount?: int64;

  /**
   * The CPU core count of the database.
   */
  dbCpuCoreCount?: int64;

  /**
   * The database platform type, i.e standlone, RAC.
   */
  dbPlatformType?: DataBasePlatformType;

  /**
   * The database infrastructure type, i.e standard, exadata, autonomous.
   */
  dbInfrastructureType?: DatabaseInfrastructureType;

  /**
   * The list of database features, i.e. partitioning, olap, spatial, inmemory, asm, dataguard, multitenant etc.
   */
  dbFeatures?: string[];

  /**
   * The size of the SGA memory.
   */
  memSgaSize?: int64;

  /**
   * The size of the PGA memory.
   */
  memPgaSize?: int64;

  /**
   * The log mode of the database.
   */
  dbLogMode?: string;

  /**
   * The operating mode of the database.
   */
  dbOperatingMode?: string;

  /**
   * The data protection mode of the database.
   */
  dbDataProtectionMode?: string;

  /**
   * Indicates whether HA/DR broker is enabled.
   */
  dbHaDrBroker?: string;

  /**
   * The database deployment configuration.
   */
  dbConfiguration?: string;

  /**
   * The role of the database in a cluster.
   */
  dbDatabaseRole?: string;

  /**
   * The flashback status of the database.
   */
  dbFlashbackStatus?: string;

  /**
   * Current system change number for the database.
   */
  dbCurrentScn?: int64;

  /**
   * Count of database file segments on storage disks.
   */
  dbFileSegmentCount?: int64;

  /**
   * Total size of database file segments in MB.
   */
  dbFileSegmentSize?: float32;

  /**
   * The count of OS processes for the CPU.
   */
  cpuOsProcessCount?: int64;

  /**
   * The process limit for the CPU.
   */
  cpuProcessLimit?: float32;

  /**
   * The recent critical errors of the database.
   */
  recentCriticalErrors?: string[];
}

/**
 * Defines the error.
 */
model Error {
  /**
   * The error ID.
   */
  id?: string;

  /**
   * The error code.
   */
  code?: string;

  /**
   * The summarized error message.
   */
  summaryMessage?: string;

  /**
   * The account ID used to login.
   */
  runAsAccountId?: string;

  /**
   * The detailed error message.
   */
  message?: string;

  /**
   * The error possible cause.
   */
  possibleCause?: string;

  /**
   * Gets description of the checkpoint.
   */
  recommendedAction?: string;

  /**
   * Gets description of the severity.
   */
  severity?: string;

  /**
   * UTC Time(yyyy-MM-ddTHH:mm:ssZ) when this error was last updated.
   */
  updatedTimeStamp?: utcDateTime;
}

/**
 * Represents a Collation in Oracle.
 */
model Collation {
  /**
   * The name of the collation.
   */
  name?: string;

  /**
   * The locale of the collation.
   */
  locale?: string;

  /**
   * The provider of the collation.
   */
  collationProvider?: CollationProvider;

  /**
   * A value indicating whether the collation is deterministic.
   */
  isDeterministic?: boolean;
}

/**
 * List of Databases.
 */
model OracleDatabaseList is Azure.Core.Page<OracleDatabase>;

/**
 * Oracle Database properties
 */
model OracleDatabaseProperties is AzureResourceProperties {
  /**
   * The database name.
   */
  databaseDisplayName?: string;

  /**
   * discovered Oracle Instance Ids
   */
  oracleInstanceArmIds?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ApplicationMigration/oracleSites/oracleInstances";
    }
  ]>[];

  /**
   * Oracle database encoding.
   */
  encoding?: Encoding;

  /**
   * The list of collations in the database.
   */
  @identifiers(#["name", "locale", "collationProvider", "isDeterministic"])
  collations?: Collation[];

  /**
   * The list of extensions in the database.
   */
  @identifiers(#["name", "version"])
  extensions?: Extension[];

  /**
   * List of languages in the database.
   */
  languages?: Language[];

  /**
   * The audit status of the database.
   */
  dbAudit?: string;

  /**
   * Whether advanced queues feature is enabled.
   */
  dbAdvanceQueues?: string;

  /**
   * Whether block change tracking is enabled.
   */
  dbBlockChangeTracking?: string;

  /**
   * Whether change data capture is enabled.
   */
  dbCdc?: string;

  /**
   * Whether column encryption is enabled.
   */
  dbColumnEncryption?: string;

  /**
   * Whether global temporary tables feature is enabled.
   */
  dbGlobalTempTables?: string;

  /**
   * Whether linked servers support is enabled.
   */
  dbLinkedServers?: string;

  /**
   * Whether database mail feature is enabled.
   */
  dbMail?: string;

  /**
   * The multibyte data byte order.
   */
  dbMultibyteByteorder?: string;

  /**
   * Whether parallel buffers are enabled.
   */
  dbParallelBuffers?: string;

  /**
   * Whether parallel queries are enabled.
   */
  dbParallelQueries?: string;

  /**
   * Whether point-in-time recovery is enabled.
   */
  dbPointIntimeRecovery?: string;

  /**
   * Whether row-level security is enabled.
   */
  dbRowLevelSecurity?: string;

  /**
   * Whether scheduler jobs are enabled.
   */
  dbScheduledJob?: string;

  /**
   * Whether stream feature is enabled.
   */
  dbStream?: string;

  /**
   * Whether supplemental logging is enabled.
   */
  dbSupplementalLog?: string;

  /**
   * Whether database trace files feature is enabled.
   */
  dbTraceFiles?: string;

  /**
   * Whether transparent application failover is enabled.
   */
  dbTransparentAppFailover?: string;

  /**
   * The vault status of the database.
   */
  dbVault?: string;

  /**
   * The partitioning status of the database.
   */
  dbPartitioning?: boolean;

  /**
   * The OLAP status of the database.
   */
  dbOlap?: boolean;

  /**
   * The spatial status of the database.
   */
  dbSpatial?: boolean;

  /**
   * The in-memory status of the database.
   */
  dbInmemory?: string;

  /**
   * Gets or sets storage size of Oracle database.
   */
  storageSizeInMb?: float32;

  /**
   * Indicates whether the access to the machine's file system is enabled for the database objects.
   */
  fileSystemAccessEnabled?: BoolValue;

  /**
   * The number of errors.
   */
  errorCount?: int64;

  /**
   * The list of errors.
   */
  errors?: Error[];

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record"
  tags?: Record<string>;
}

/**
 * Oracle Database properties
 */
model OracleDatabaseResourcePatchProperties {
  /**
   * The database resource patch properties.
   */
  properties?: OracleDatabaseResourcePatch;
}

/**
 * Oracle Database patch object
 */
model OracleDatabaseResourcePatch {
  /**
   * The database name.
   */
  databaseDisplayName?: string;

  /**
   * discovered Oracle Instance Ids
   */
  oracleInstanceArmIds?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ApplicationMigration/oracleSites/oracleInstances";
    }
  ]>[];

  /**
   * Oracle database encoding.
   */
  encoding?: Encoding;

  /**
   * The list of collations in the database.
   */
  @identifiers(#["name", "locale", "collationProvider", "isDeterministic"])
  collations?: Collation[];

  /**
   * The list of extensions in the database.
   */
  @identifiers(#["name", "version"])
  extensions?: Extension[];

  /**
   * List of languages in the database.
   */
  languages?: Language[];

  /**
   * The audit status of the database.
   */
  dbAudit?: string;

  /**
   * Whether advanced queues feature is enabled.
   */
  dbAdvanceQueues?: string;

  /**
   * Whether block change tracking is enabled.
   */
  dbBlockChangeTracking?: string;

  /**
   * Whether change data capture is enabled.
   */
  dbCdc?: string;

  /**
   * Whether column encryption is enabled.
   */
  dbColumnEncryption?: string;

  /**
   * Whether global temporary tables feature is enabled.
   */
  dbGlobalTempTables?: string;

  /**
   * Whether linked servers support is enabled.
   */
  dbLinkedServers?: string;

  /**
   * Whether database mail feature is enabled.
   */
  dbMail?: string;

  /**
   * The multibyte data byte order.
   */
  dbMultibyteByteorder?: string;

  /**
   * Whether parallel buffers are enabled.
   */
  dbParallelBuffers?: string;

  /**
   * Whether parallel queries are enabled.
   */
  dbParallelQueries?: string;

  /**
   * Whether point-in-time recovery is enabled.
   */
  dbPointIntimeRecovery?: string;

  /**
   * Whether row-level security is enabled.
   */
  dbRowLevelSecurity?: string;

  /**
   * Whether scheduler jobs are enabled.
   */
  dbScheduledJob?: string;

  /**
   * Whether stream feature is enabled.
   */
  dbStream?: string;

  /**
   * Whether supplemental logging is enabled.
   */
  dbSupplementalLog?: string;

  /**
   * Whether database trace files feature is enabled.
   */
  dbTraceFiles?: string;

  /**
   * Whether transparent application failover is enabled.
   */
  dbTransparentAppFailover?: string;

  /**
   * The vault status of the database.
   */
  dbVault?: string;

  /**
   * The partitioning status of the database.
   */
  dbPartitioning?: boolean;

  /**
   * The OLAP status of the database.
   */
  dbOlap?: boolean;

  /**
   * The spatial status of the database.
   */
  dbSpatial?: boolean;

  /**
   * The in-memory status of the database.
   */
  dbInmemory?: string;

  /**
   * Gets or sets storage size of Oracle database.
   */
  storageSizeInMb?: float32;

  /**
   * Indicates whether the access to the machine's file system is enabled for the database objects.
   */
  fileSystemAccessEnabled?: BoolValue;

  /**
   * The number of errors.
   */
  errorCount?: int64;

  /**
   * The list of errors.
   */
  errors?: Error[];

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record"
  tags?: Record<string>;
}

/**
 * Represents an Extension.
 */
model Extension {
  /**
   * The name of the extension.
   */
  name?: string;

  /**
   * The version of the extension.
   */
  version?: string;
}

// /**
//  * Object containing tags updates for patch operations.
//  */
// model OracleDatabaseResourcePatch {
//   /**
//    * Resource tags
//    */
//    tags?: Record<string>;
// }

/**
 * List of Agents.
 */
model OracleAgentList is Azure.Core.Page<OracleAgent>;

/**
 * Agent properties
 */
model AgentProperties is AzureResourceProperties {
  /**
   * Service principal identity details used by agent for communication to the service.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  servicePrincipalIdentityDetails: AgentSpnProperties;

  /**
   * Name of the appliance on which agent is running.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  migrateApplianceName: string;

  /**
   * Health details of the agent.
   */
  healthDetails?: AgentHealthProperties;

  /**
   * Name of the appliance on which agent is running.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  fabricSiteName: string;
}

/**
 * Class for agent spn properties.
 */
model AgentSpnProperties {
  /**
   * Tenant Id for the service principal with which the on-premise management/data plane components would communicate with our Azure services.
   */
  tenantId?: string;

  /**
   * Application/client Id for the service principal with which the on-premise management/data plane components would communicate with our Azure services.
   */
  applicationId?: string;

  /**
   * Object Id of the service principal with which the on-premise management/data plane components would communicate with our Azure services.
   */
  objectId?: string;
}

/**
 * Class for agent health properties.
 */
model AgentHealthProperties {
  /**
   * Version of the agent.
   */
  version?: string;

  /**
   * Last heartbeat time of the agent in UTC.
   */
  lastHeartBeatUtc?: utcDateTime;
}

/**
 * Object containing tags updates for patch operations.
 */
model AgentResourcePatch {
  /**
   * The Agent properties resource definition.
   */
  properties?: AgentResourcePatchProperties;
}

/**
 * Agent resource patch properties
 */
model AgentResourcePatchProperties {
  /**
   * Health details of the agent.
   */
  healthDetails?: AgentHealthProperties;
}

@doc("The Site Tags patch resource definition.")
model SiteTagsPatch {
  ...TagsUpdate;
}

/**
 * Represents the properties of the machine where the Oracle instance is running.
 */
model HostMachineProperties {
  /**
   * The machine vCore count.
   */
  vCores?: int64;

  /**
   * The allocated RAM in Machine.
   */
  allocatedMemoryInMb?: int64;

  /**
   * The machine storage size in GB.
   */
  totalStorageInGb?: int64;

  /**
   * The number of Oracle instances on the machine.
   */
  oracleInstanceCount?: int64;
}
