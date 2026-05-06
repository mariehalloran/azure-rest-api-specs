import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.OpenEnergyPlatform;

/**
 * The reason why the given name is not available.
 */
union CheckNameAvailabilityReason {
  string,

  /**
   * Invalid
   */
  Invalid: "Invalid",

  /**
   * AlreadyExists
   */
  AlreadyExists: "AlreadyExists",
}

/** Provisioning state of the resource. */
union ProvisioningState {
  string,

  /** The provisioning state is unknown. */
  Unknown: "Unknown",

  /** The resource has been successfully provisioned. */
  Succeeded: "Succeeded",

  /** Resource provisioning has failed. */
  Failed: "Failed",

  /** Resource provisioning was canceled. */
  Canceled: "Canceled",

  /** The resource is being created. */
  Creating: "Creating",

  /** The resource is being deleted. */
  Deleting: "Deleting",

  /** The resource is being updated. */
  Updating: "Updating",
}

/**
 * The encryption keySource (provider). Possible values (case-insensitive):  Microsoft.Keyvault
 */
union KeySource {
  string,

  /** Use Microsoft Key Vault as the key provider for encryption. */
  `Microsoft.Keyvault`: "Microsoft.Keyvault",
}

/**
 * Whether or not public network access is allowed for the OAK resource.
 */
union PublicNetworkAccess {
  string,

  /** Public network access is allowed for the resource. */
  Enabled: "Enabled",

  /** Public network access is denied; the resource is reachable only via private endpoints. */
  Disabled: "Disabled",
}

/**
 * The type of identity that created the resource.
 */
union CreatedByType {
  string,

  /**
   * User
   */
  User: "User",

  /**
   * Application
   */
  Application: "Application",

  /**
   * ManagedIdentity
   */
  ManagedIdentity: "ManagedIdentity",

  /**
   * Key
   */
  Key: "Key",
}

/** Allowed HTTP methods. */
union AllowedMethods {
  string,

  /** Allow HTTP DELETE requests. */
  DELETE: "DELETE",

  /** Allow HTTP GET requests. */
  GET: "GET",

  /** Allow HTTP HEAD requests. */
  HEAD: "HEAD",

  /** Allow HTTP MERGE requests. */
  MERGE: "MERGE",

  /** Allow HTTP POST requests. */
  POST: "POST",

  /** Allow HTTP OPTIONS requests. */
  OPTIONS: "OPTIONS",

  /** Allow HTTP PUT requests. */
  PUT: "PUT",

  /** Allow HTTP PATCH requests. */
  PATCH: "PATCH",
}

/**
 * Specifies whether geo-redundancy is enabled or disabled for the energy service.
 */
union GeoRedundancy {
  string,

  /**
   * Geo-redundancy is enabled for the energy service, providing data replication across regions.
   */
  Enabled: "Enabled",

  /**
   * Geo-redundancy is disabled for the energy service.
   */
  Disabled: "Disabled",
}

/**
 * Ingestion method for reference data
 */
union Ingestion {
  string,

  /**
   * Ingest all available reference data values, including the FIXED, OPEN, and LOCAL data sets. Use this option when you want a complete set of reference data values ingested to each data partition
   */
  All: "All",

  /**
   * Ingest reference data values, excluding the LOCAL data set. Use this option when you want only the FIXED and OPEN reference data values ingested to each data partition.
   */
  NonLocal: "NonLocal",
}

/**
 * Specifies the upgrade policy for the service during milestone upgrade periods.
 */
union UpgradePolicy {
  string,

  /**
   * The service will be automatically upgraded during the major upgrade window.
   */
  Automatic: "Automatic",

  /**
   * Major upgrades are deferred by 30 days.
   */
  Deferred: "Deferred",
}

/**
 * Indicates the readiness status of the instance for upgrade.
 */
union ReadyForUpgrade {
  string,

  /**
   * Upgrade readiness is not applicable because the upgradePolicy is set to Automatic.
   */
  NotApplicable: "NotApplicable",

  /**
   * The service has been marked as ready for upgrade. Only valid when upgradePolicy is Deferred.
   */
  Ready: "Ready",

  /**
   * The service is not ready for upgrade. Default state when upgradePolicy is Deferred.
   */
  NotReady: "NotReady",
}

/**
 * Name of the add-on package.
 */
union AddOnPackageName {
  string,

  /**
   * External Data Services add-on package.
   */
  ExternalDataServices: "ExternalDataServices",

  /**
   * Petrel V2 add-on package.
   */
  PetrelV2: "PetrelV2",

  /**
   * Reservoir add-on package.
   */
  Reservoir: "Reservoir",

  /**
   * Rock and Fluid add-on package.
   */
  RockAndFluid: "RockAndFluid",

  /**
   * Seismic add-on package.
   */
  Seismic: "Seismic",

  /**
   * Wellbore add-on package.
   */
  Wellbore: "Wellbore",

  /**
   * Well Delivery add-on package.
   */
  WellDelivery: "WellDelivery",
}

/**
 * The provisioning state of private link group ID.
 */
union GroupIdProvisioningState {
  string,

  /** The private link group ID has been successfully provisioned. */
  Succeeded: "Succeeded",

  /** Provisioning of the private link group ID failed. */
  Failed: "Failed",

  /** Provisioning of the private link group ID was canceled. */
  Canceled: "Canceled",
}

/**
 * The current provisioning state.
 */
union PrivateEndpointConnectionProxyProvisioningState {
  string,

  /** The private endpoint connection proxy has been successfully provisioned. */
  Succeeded: "Succeeded",

  /** The private endpoint connection proxy is being created. */
  Creating: "Creating",

  /** The private endpoint connection proxy is being deleted. */
  Deleting: "Deleting",

  /** Provisioning of the private endpoint connection proxy failed. */
  Failed: "Failed",
}

/**
 * The intended executor of the operation; as in Resource Based Access Control (RBAC) and audit logs UX. Default value is "user,system"
 */
union Origin {
  string,

  /**
   * user
   */
  user: "user",

  /**
   * system
   */
  system: "system",

  /**
   * user,system
   */
  `user,system`: "user,system",
}

/**
 * Enum. Indicates the action type. "Internal" refers to actions that are for internal only APIs.
 */
union ActionType {
  string,

  /**
   * Internal
   */
  Internal: "Internal",
}

/**
 * Indicates whether the add-on package is enabled or disabled.
 */
union PackageState {
  string,

  /**
   * The package is enabled.
   */
  Enabled: "Enabled",

  /**
   * The package is disabled.
   */
  Disabled: "Disabled",
}

/**
 * The type of identity used for accessing the keyvault. Possible values include: 'SystemAssigned', 'UserAssigned'
 */
#suppress "@azure-tools/typespec-azure-core/no-enum" "Preserving existing wire contract."
enum IdentityType {
  /**
   * Use an implicitly created system assigned managed identity to access the specified key vault.
   */
  SystemAssigned,

  /**
   * Use a user-specified identity to access the specified key vault.
   */
  UserAssigned,
}

/**
 * Maximum autoscale capacity limit for the energy service. Must be a power of 2 between 1 and 256 (applicable for Flex SKU).
 */
#suppress "@azure-tools/typespec-azure-core/no-enum" "Preserving existing wire contract."
enum AutoScaleMaxCapacity {
  /**
   * 1 capacity unit
   */
  `1`: 1,

  /**
   * 2 capacity units
   */
  `2`: 2,

  /**
   * 4 capacity units
   */
  `4`: 4,

  /**
   * 8 capacity units
   */
  `8`: 8,

  /**
   * 16 capacity units
   */
  `16`: 16,

  /**
   * 32 capacity units
   */
  `32`: 32,

  /**
   * 64 capacity units
   */
  `64`: 64,

  /**
   * 128 capacity units
   */
  `128`: 128,

  /**
   * 256 capacity units
   */
  `256`: 256,
}

/**
 * The list of oep resources.
 */
model EnergyServiceList is Azure.Core.Page<EnergyService>;

/**
 * The properties of an Energy service resource.
 */
model EnergyServiceProperties {
  /** DNS name of the OAK service. */
  @visibility(Lifecycle.Read)
  dnsName?: string;

  /** Provisioning state of the resource. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** App ID of the application used for authentication. */
  authAppId?: string;

  /** Data partition names. */
  @identifiers(#[])
  dataPartitionNames?: DataPartitionNames[];

  /**
   * Properties to configure Encryption
   */
  encryption?: Encryption;

  /**
   * Properties to configure EDS
   */
  eds?: Eds;

  /**
   * Whether or not public network access is allowed for the OAK resource.
   */
  publicNetworkAccess?: PublicNetworkAccess = PublicNetworkAccess.Enabled;

  /**
   * List of private endpoint connections associated with the OAK resource.
   */
  privateEndpointConnections?: PrivateEndpointConnection[];

  /**
   * List of cors rules
   */
  @identifiers(#[])
  corsRules?: CorsRulesList[];

  /**
   * The resource model definition representing SKU
   */
  sku?: Azure.ResourceManager.CommonTypes.Sku;

  /**
   * Maximum autoscale capacity limit for the energy service. Must be a power of 2 between 1 and 256 (applicable for Flex SKU).
   */
  autoScaleMaxCapacity?: AutoScaleMaxCapacity;

  /**
   * Specifies whether geo-redundancy is enabled or disabled for the energy service.
   */
  geoRedundancy?: GeoRedundancy = GeoRedundancy.Enabled;

  /**
   * Defines the properties related to reference data ingestion.
   */
  referenceData?: ReferenceDataProperties;

  /**
   * The milestone version of the service.
   */
  @visibility(Lifecycle.Read)
  milestoneVersion?: string;

  /**
   * The upgrade settings for the energy services instance.
   */
  upgradeSettings?: UpgradeSettings;

  /**
   * List of add-on packages to be enabled for the energy service. Packages not included in the list will be considered for removal.
   */
  @identifiers(#["name"])
  addOnPackages?: AddOnPackage[];
}

/**
 * The list of Energy services resource's Data Partition Names.
 */
model DataPartitionNames {
  /** Data partition name. */
  name?: string;
}

/**
 * Properties to configure Encryption
 */
model Encryption {
  /**
   * Properties of KeyVault
   */
  keyVaultProperties?: KeyVaultProperties;

  /**
   * The encryption keySource (provider). Possible values (case-insensitive):  Microsoft.Keyvault
   */
  keySource?: KeySource = KeySource.`Microsoft.Keyvault`;
}

/**
 * Properties of KeyVault
 */
model KeyVaultProperties {
  /**
   * The name of the key vault key.
   */
  keyName: string;

  /**
   * The version of the key vault key.
   */
  keyVersion?: string;

  /**
   * The Uri of the key vault.
   */
  keyVaultUri: string;

  /**
   * The user assigned identity (ARM resource id) that has access to the key.
   */
  userIdentity?: string;
}

/**
 * Properties to configure EDS
 */
model Eds {
  /**
   * Properties of KeyVault
   */
  keyVaultProperties?: EdsKeyVaultProperties;
}

/**
 * Properties of KeyVault
 */
model EdsKeyVaultProperties {
  /**
   * The Uri of the key vault.
   */
  keyVaultUri: string;

  /**
   * The identity used to access the key vault.
   */
  identity: EdsKeyVaultPropertiesIdentity;
}

/**
 * The identity used to access the key vault.
 */
model EdsKeyVaultPropertiesIdentity {
  /**
   * The type of identity used for accessing the keyvault. Possible values include: 'SystemAssigned', 'UserAssigned'
   */
  identityType?: IdentityType;

  /**
   * The user assigned identity (ARM resource id) that has access to the key. This property is required if identityType is 'UserAssigned'.
   */
  userAssignedIdentityId?: string;
}

/**
 * List of cors rules
 */
model CorsRulesList {
  /**
   * List of allowed headers
   */
  allowedHeaders?: string[];

  /**
   * List of allowed HTTP methods
   */
  allowedMethods?: AllowedMethods[];

  /**
   * List of allowed origin endpoints
   */
  allowedOrigins?: string[];

  /**
   * List of exposed headers
   */
  exposedHeaders?: string[];

  /**
   * Max amount of time that a browser than cache the preflight OPTIONS request
   */
  maxAgeInSeconds?: int32;
}

/**
 * Defines the properties related to reference data ingestion.
 */
model ReferenceDataProperties {
  /**
   * Ingestion method for reference data
   */
  ingestion?: Ingestion = Ingestion.All;
}

/**
 * The upgrade settings for the energy services instance.
 */
model UpgradeSettings {
  /**
   * Specifies the upgrade policy for the service during milestone upgrade periods.
   */
  upgradePolicy?: UpgradePolicy = UpgradePolicy.Automatic;

  /**
   * Indicates the readiness status of the instance for upgrade.
   */
  readyForUpgrade?: ReadyForUpgrade = ReadyForUpgrade.NotApplicable;

  /**
   * The date after which the instance will be automatically upgraded if it doesn't get marked as ready for upgrade.
   */
  @visibility(Lifecycle.Read)
  autoUpgradeAfterDate?: plainDate;
}

/**
 * An add-on package configuration for the energy service. Use the 'name' field to specify the package type.
 */
@discriminator("name")
model AddOnPackage {
  /**
   * Name of the add-on package.
   */
  name: AddOnPackageName;
}

/**
 * The resource model definition used for updating a tracked ARM resource.
 */
model EnergyResourceUpdate {
  /**
   * The properties of an Energy service resource patch.
   */
  properties?: EnergyServiceUpdateProperties;

  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Preserving existing wire contract."
  tags?: Record<string>;

  /**
   * The type of identity used for the resource.
   */
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentity;
}

/**
 * The properties of an Energy service resource patch.
 */
model EnergyServiceUpdateProperties {
  /**
   * Properties to configure Encryption
   */
  encryption?: Encryption;

  /**
   * List of add-on packages to be enabled for the energy service. Packages not included in the list will be considered for removal.
   */
  @identifiers(#["name"])
  addOnPackages?: AddOnPackage[];
}

/**
 * Defines the partition add/ delete action properties.
 */
model DataPartitionAddOrRemoveRequest {
  /**
   * The list of Energy services resource's Data Partition Names.
   */
  name?: DataPartitionNames;
}

/**
 * List of data partitions.
 */
model DataPartitionsListResult {
  /**
   * List of data partitions along with their properties in a given OEP resource.
   */
  @identifiers(#[])
  dataPartitionInfo?: DataPartitionProperties[];
}

/**
 * Defines the properties of an individual data partition.
 */
model DataPartitionProperties {
  /**
   * Name of the data partition
   */
  name?: string;

  /**
   * The provisioning state of the data partition resource.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/**
 * The properties for a group information object
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model GroupInformationProperties
  extends Azure.ResourceManager.CommonTypes.PrivateLinkResourceProperties {
  /**
   * The provisioning state of private link group ID.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: GroupIdProvisioningState;
}

/**
 * Private endpoint connection proxy object properties.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Preserving existing wire contract."
model PrivateEndpointConnectionProxyProperties {
  /**
   * ETag from NRP.
   */
  eTag?: string;

  /**
   * Remote private endpoint details.
   */
  remotePrivateEndpoint?: RemotePrivateEndpoint;

  /**
   * Operation status.
   */
  status?: string;
}

/**
 * Remote private endpoint details.
 */
model RemotePrivateEndpoint {
  /**
   * Remote endpoint resource ID.
   */
  id?: string;

  /**
   * ARM location of the remote private endpoint.
   */
  location?: string;

  /**
   * Original subscription ID needed by Microsoft.Network.
   */
  immutableSubscriptionId?: string;

  /**
   * Original resource ID needed by Microsoft.Network.
   */
  immutableResourceId?: string;

  /**
   * Virtual network traffic tag.
   */
  vnetTrafficTag?: string;

  /**
   * List of private link service connections that need manual approval.
   */
  @identifiers(#[])
  manualPrivateLinkServiceConnections?: PrivateLinkServiceConnection[];

  /**
   * List of automatically approved private link service connections.
   */
  @identifiers(#[])
  privateLinkServiceConnections?: PrivateLinkServiceConnection[];

  /**
   * List of private link service proxies.
   */
  privateLinkServiceProxies?: PrivateLinkServiceProxy[];

  /**
   * List of connection details.
   */
  connectionDetails?: ConnectionDetails[];
}

/**
 * Private link service connection details.
 */
model PrivateLinkServiceConnection {
  /**
   * Private link service connection name.
   */
  name?: string;

  /**
   * List of group IDs.
   */
  groupIds?: string[];

  /**
   * Request message.
   */
  requestMessage?: string;
}

/**
 * Private link service proxy details.
 */
model PrivateLinkServiceProxy {
  /**
   * NRP resource ID.
   */
  id?: string;

  /**
   * Remote private link service connection state
   */
  remotePrivateLinkServiceConnectionState?: Azure.ResourceManager.CommonTypes.PrivateLinkServiceConnectionState;

  /**
   * Remote private endpoint connection details.
   */
  remotePrivateEndpointConnection?: PrivateLinkServiceProxyRemotePrivateEndpointConnection;

  /**
   * Group connectivity information.
   */
  @identifiers(#[])
  groupConnectivityInformation?: GroupConnectivityInformation[];
}

/**
 * Remote private endpoint connection details.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/no-empty-model" "Preserving existing wire contract."
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model PrivateLinkServiceProxyRemotePrivateEndpointConnection
  extends RemotePrivateEndpointConnection {}

/**
 * Remote private endpoint connection details.
 */
model RemotePrivateEndpointConnection {
  /**
   * Remote private endpoint connection ID.
   */
  id?: string;
}

/**
 * Group connectivity details.
 */
model GroupConnectivityInformation {
  /**
   * Group ID.
   */
  groupId?: string;

  /**
   * Member name.
   */
  memberName?: string;

  /**
   * List of customer visible FQDNs.
   */
  customerVisibleFqdns?: string[];

  /**
   * Internal FQDN.
   */
  internalFqdn?: string;

  /**
   * Redirect map ID.
   */
  redirectMapId?: string;

  /**
   * PrivateLinkService ARM region.
   */
  privateLinkServiceArmRegion?: string;
}

/**
 * Private endpoint connection proxy object properties.
 */
model ConnectionDetails {
  /**
   * Connection details ID.
   */
  id?: string;

  /**
   * Private IP address.
   */
  privateIpAddress?: string;

  /**
   * Link ID.
   */
  linkIdentifier?: string;

  /**
   * Group ID.
   */
  groupId?: string;

  /**
   * Member name.
   */
  memberName?: string;
}

/**
 * Localized display information for this particular operation.
 */
model OperationDisplay {
  /**
   * The localized friendly form of the resource provider name, e.g. "Microsoft Monitoring Insights" or "Microsoft Compute".
   */
  @visibility(Lifecycle.Read)
  provider?: string;

  /**
   * The localized friendly name of the resource type related to this operation. E.g. "Virtual Machines" or "Job Schedule Collections".
   */
  @visibility(Lifecycle.Read)
  resource?: string;

  /**
   * The concise, localized friendly name for the operation; suitable for dropdowns. E.g. "Create or Update Virtual Machine", "Restart Virtual Machine".
   */
  @visibility(Lifecycle.Read)
  operation?: string;

  /**
   * The short, localized friendly description of the operation; suitable for tool tips and detailed views.
   */
  @visibility(Lifecycle.Read)
  description?: string;
}

/**
 * List of data partitions
 */
model DataPartitionsList {
  /** List of data partition names. */
  @identifiers(#[])
  dataPartitionNames?: DataPartitionNames[];
}

/**
 * External Data Services add-on package configuration.
 */
model ExternalDataServicesAddOnPackage extends AddOnPackage {
  /**
   * Common properties for an add-on package.
   */
  properties?: AddOnPackageItemProperties;

  /**
   * Name of the add-on package.
   */
  name: "ExternalDataServices";
}

/**
 * Common properties for an add-on package.
 */
model AddOnPackageItemProperties {
  /**
   * Indicates whether the add-on package is enabled or disabled.
   */
  state?: PackageState;
}

/**
 * Petrel V2 add-on package configuration.
 */
model PetrelV2AddOnPackage extends AddOnPackage {
  /**
   * Common properties for an add-on package.
   */
  properties?: AddOnPackageItemProperties;

  /**
   * Name of the add-on package.
   */
  name: "PetrelV2";
}

/**
 * Reservoir add-on package configuration.
 */
model ReservoirAddOnPackage extends AddOnPackage {
  /**
   * Common properties for an add-on package.
   */
  properties?: AddOnPackageItemProperties;

  /**
   * Name of the add-on package.
   */
  name: "Reservoir";
}

/**
 * Rock and Fluid add-on package configuration.
 */
model RockAndFluidAddOnPackage extends AddOnPackage {
  /**
   * Common properties for an add-on package.
   */
  properties?: AddOnPackageItemProperties;

  /**
   * Name of the add-on package.
   */
  name: "RockAndFluid";
}

/**
 * Seismic add-on package configuration.
 */
model SeismicAddOnPackage extends AddOnPackage {
  /**
   * Common properties for an add-on package.
   */
  properties?: AddOnPackageItemProperties;

  /**
   * Name of the add-on package.
   */
  name: "Seismic";
}

/**
 * Wellbore add-on package configuration.
 */
model WellboreAddOnPackage extends AddOnPackage {
  /**
   * Common properties for an add-on package.
   */
  properties?: AddOnPackageItemProperties;

  /**
   * Name of the add-on package.
   */
  name: "Wellbore";
}

/**
 * Well Delivery add-on package configuration.
 */
model WellDeliveryAddOnPackage extends AddOnPackage {
  /**
   * Common properties for an add-on package.
   */
  properties?: AddOnPackageItemProperties;

  /**
   * Name of the add-on package.
   */
  name: "WellDelivery";
}
