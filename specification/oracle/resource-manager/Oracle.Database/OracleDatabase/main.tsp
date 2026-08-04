import "@azure-tools/typespec-autorest";
import "./operations/exadata/exadatainfrastructureOperations.tsp";
import "./operations/exadata/dbServersOperations.tsp";
import "./operations/exadata/vmclusterOperations.tsp";
import "./operations/exadata/virtualNetworkAddressOperations.tsp";
import "./operations/exadata/systemVersionOperations.tsp";
import "./operations/oraclesubscription/oracleSubscriptionOperations.tsp";
import "./operations/exadata/dbNodesOperations.tsp";
import "./operations/exadata/giVersionOperations.tsp";
import "./operations/exadata/giMinorVersionOperations.tsp";
import "./operations/exadata/dbSystemShapeOperations.tsp";
import "./operations/exadata/dnsPrivateViewsOperations.tsp";
import "./operations/exadata/dnsPrivateZonesOperations.tsp";
import "./operations/exadata/flexComponentOperations.tsp";
import "./operations/autonomousdatabase/autonomousDatabaseOperations.tsp";
import "./operations/autonomousdatabase/autonomousDatabaseBackupOperations.tsp";
import "./operations/autonomousdatabase/autonomousDatabaseCharacterSetOperations.tsp";
import "./operations/autonomousdatabase/autonomousDatabaseNationalCharacterSetOperations.tsp";
import "./operations/autonomousdatabase/autonomousDatabaseVersionOperations.tsp";
import "./operations/exascale/exadbVmClusterOperations.tsp";
import "./operations/exascale/exascaleDbNodesOperations.tsp";
import "./operations/exascale/exascaleDbStorageVaultOperations.tsp";
import "./operations/anchors/networkAnchorOperations.tsp";
import "./operations/anchors/resourceAnchorOperations.tsp";
import "./operations/basedb/dbSystemOperations.tsp";
import "./operations/basedb/dbVersionOperations.tsp";
import "./operations/basedb/dbEditionOperations.tsp";
import "./operations/common/dbShapeOperations.tsp";
import "./operations/goldengate/connectionOperations.tsp";
import "./operations/goldengate/deploymentOperations.tsp";
import "./operations/managedidentity/managedIdentityResourceOperations.tsp";
import "./versions.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;
using OpenAPI;
using Autorest;

@armProviderNamespace
@service(#{ title: "Oracle Database Resource Manager" })
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
@versioned(Oracle.Database.Versions)
namespace Oracle.Database;

interface Operations extends Azure.ResourceManager.Operations {}

#suppress "@azure-tools/typespec-azure-core/no-openapi" "TODO FIX - DO NOT COPY - BAD PATTERN"
@@Autorest.example(
  Operations.list,
  "./examples/operations_list.json",
  "List Operations"
);

// Generated maximum-set examples retained through TypeSpec regeneration.

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbSystems.listBySubscription,
  "./examples/DbSystems_ListBySubscription_MaximumSet_Gen.json",
  "DbSystems_ListBySubscription maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbSystems.listByResourceGroup,
  "./examples/DbSystems_ListByResourceGroup_MaximumSet_Gen.json",
  "DbSystems_ListByResourceGroup maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbSystems.get,
  "./examples/DbSystems_Get_MaximumSet_Gen.json",
  "DbSystems_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbSystems.createOrUpdate,
  "./examples/DbSystems_CreateOrUpdate_MaximumSet_Gen.json",
  "DbSystems_CreateOrUpdate maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbSystems.update,
  "./examples/DbSystems_Update_MaximumSet_Gen.json",
  "DbSystems_Update maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbSystems.delete,
  "./examples/DbSystems_Delete_MaximumSet_Gen.json",
  "DbSystems_Delete maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExadbVmClusters.listBySubscription,
  "./examples/ExadbVmClusters_ListBySubscription_MaximumSet_Gen.json",
  "ExadbVmClusters_ListBySubscription maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExadbVmClusters.listByResourceGroup,
  "./examples/ExadbVmClusters_ListByResourceGroup_MaximumSet_Gen.json",
  "ExadbVmClusters_ListByResourceGroup maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExadbVmClusters.get,
  "./examples/ExadbVmClusters_Get_MaximumSet_Gen.json",
  "ExadbVmClusters_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExadbVmClusters.createOrUpdate,
  "./examples/ExadbVmClusters_CreateOrUpdate_MaximumSet_Gen.json",
  "ExadbVmClusters_CreateOrUpdate maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExadbVmClusters.update,
  "./examples/ExadbVmClusters_Update_MaximumSet_Gen.json",
  "ExadbVmClusters_Update maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExadbVmClusters.delete,
  "./examples/ExadbVmClusters_Delete_MaximumSet_Gen.json",
  "ExadbVmClusters_Delete maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExadbVmClusters.removeVms,
  "./examples/ExadbVmClusters_RemoveVms_MaximumSet_Gen.json",
  "ExadbVmClusters_RemoveVms maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbStorageVaults.listBySubscription,
  "./examples/ExascaleDbStorageVaults_ListBySubscription_MaximumSet_Gen.json",
  "ExascaleDbStorageVaults_ListBySubscription maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbStorageVaults.listByResourceGroup,
  "./examples/ExascaleDbStorageVaults_ListByResourceGroup_MaximumSet_Gen.json",
  "ExascaleDbStorageVaults_ListByResourceGroup maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbStorageVaults.get,
  "./examples/ExascaleDbStorageVaults_Get_MaximumSet_Gen.json",
  "ExascaleDbStorageVaults_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbStorageVaults.create,
  "./examples/ExascaleDbStorageVaults_Create_MaximumSet_Gen.json",
  "ExascaleDbStorageVaults_Create maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbStorageVaults.update,
  "./examples/ExascaleDbStorageVaults_Update_MaximumSet_Gen.json",
  "ExascaleDbStorageVaults_Update maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbStorageVaults.delete,
  "./examples/ExascaleDbStorageVaults_Delete_MaximumSet_Gen.json",
  "ExascaleDbStorageVaults_Delete maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.listBySubscription,
  "./examples/GoldenGateConnections_ListBySubscription_MaximumSet_Gen.json",
  "GoldenGateConnections_ListBySubscription maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.listByResourceGroup,
  "./examples/GoldenGateConnections_ListByResourceGroup_MaximumSet_Gen.json",
  "GoldenGateConnections_ListByResourceGroup maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.get,
  "./examples/GoldenGateConnections_Get_MaximumSet_Gen.json",
  "GoldenGateConnections_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.createOrUpdate,
  "./examples/GoldenGateConnections_CreateOrUpdate_MaximumSet_Gen.json",
  "GoldenGateConnections_CreateOrUpdate maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.update,
  "./examples/GoldenGateConnections_Update_MaximumSet_Gen.json",
  "GoldenGateConnections_Update maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.delete,
  "./examples/GoldenGateConnections_Delete_MaximumSet_Gen.json",
  "GoldenGateConnections_Delete maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.assignDeployment,
  "./examples/GoldenGateConnections_AssignDeployment_MaximumSet_Gen.json",
  "GoldenGateConnections_AssignDeployment maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.listAssignedDeploymentsByParent,
  "./examples/GoldenGateConnections_ListAssignedDeploymentsByParent_MaximumSet_Gen.json",
  "GoldenGateConnections_ListAssignedDeploymentsByParent maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.getAssignedDeployment,
  "./examples/GoldenGateConnections_GetAssignedDeployment_MaximumSet_Gen.json",
  "GoldenGateConnections_GetAssignedDeployment maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateConnections.unassignDeployment,
  "./examples/GoldenGateConnections_UnassignDeployment_MaximumSet_Gen.json",
  "GoldenGateConnections_UnassignDeployment maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.listBySubscription,
  "./examples/GoldenGateDeployments_ListBySubscription_MaximumSet_Gen.json",
  "GoldenGateDeployments_ListBySubscription maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.listByResourceGroup,
  "./examples/GoldenGateDeployments_ListByResourceGroup_MaximumSet_Gen.json",
  "GoldenGateDeployments_ListByResourceGroup maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.get,
  "./examples/GoldenGateDeployments_Get_MaximumSet_Gen.json",
  "GoldenGateDeployments_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.createOrUpdate,
  "./examples/GoldenGateDeployments_CreateOrUpdate_MaximumSet_Gen.json",
  "GoldenGateDeployments_CreateOrUpdate maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.update,
  "./examples/GoldenGateDeployments_Update_MaximumSet_Gen.json",
  "GoldenGateDeployments_Update maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.delete,
  "./examples/GoldenGateDeployments_Delete_MaximumSet_Gen.json",
  "GoldenGateDeployments_Delete maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.assignConnection,
  "./examples/GoldenGateDeployments_AssignConnection_MaximumSet_Gen.json",
  "GoldenGateDeployments_AssignConnection maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.listAssignedConnectionsByParent,
  "./examples/GoldenGateDeployments_ListAssignedConnectionsByParent_MaximumSet_Gen.json",
  "GoldenGateDeployments_ListAssignedConnectionsByParent maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.getAssignedConnection,
  "./examples/GoldenGateDeployments_GetAssignedConnection_MaximumSet_Gen.json",
  "GoldenGateDeployments_GetAssignedConnection maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GoldenGateDeployments.unassignConnection,
  "./examples/GoldenGateDeployments_UnassignConnection_MaximumSet_Gen.json",
  "GoldenGateDeployments_UnassignConnection maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DatabaseEditions.listByLocation,
  "./examples/DatabaseEditions_ListByLocation_MaximumSet_Gen.json",
  "DatabaseEditions_ListByLocation maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DatabaseEditions.get,
  "./examples/DatabaseEditions_Get_MaximumSet_Gen.json",
  "DatabaseEditions_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DatabaseSystemShapeResources.listByLocation,
  "./examples/DatabaseSystemShapeResources_ListByLocation_MaximumSet_Gen.json",
  "DatabaseSystemShapeResources_ListByLocation maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DatabaseSystemShapeResources.get,
  "./examples/DatabaseSystemShapeResources_Get_MaximumSet_Gen.json",
  "DatabaseSystemShapeResources_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbVersions.listByLocation,
  "./examples/DbVersions_ListByLocation_MaximumSet_Gen.json",
  "DbVersions_ListByLocation maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  DbVersions.get,
  "./examples/DbVersions_Get_MaximumSet_Gen.json",
  "DbVersions_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  FlexComponents.listByParent,
  "./examples/FlexComponents_ListByParent_MaximumSet_Gen.json",
  "FlexComponents_ListByParent maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  FlexComponents.get,
  "./examples/FlexComponents_Get_MaximumSet_Gen.json",
  "FlexComponents_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GiVersions.listByLocation,
  "./examples/GiVersions_ListByLocation_MaximumSet_Gen.json",
  "GiVersions_ListByLocation maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GiMinorVersions.listByParent,
  "./examples/GiMinorVersions_ListByParent_MaximumSet_Gen.json",
  "GiMinorVersions_ListByParent maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  GiMinorVersions.get,
  "./examples/GiMinorVersions_Get_MaximumSet_Gen.json",
  "GiMinorVersions_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  NetworkAnchors.listBySubscription,
  "./examples/NetworkAnchors_ListBySubscription_MaximumSet_Gen.json",
  "NetworkAnchors_ListBySubscription maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  NetworkAnchors.listByResourceGroup,
  "./examples/NetworkAnchors_ListByResourceGroup_MaximumSet_Gen.json",
  "NetworkAnchors_ListByResourceGroup maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  NetworkAnchors.get,
  "./examples/NetworkAnchors_Get_MaximumSet_Gen.json",
  "NetworkAnchors_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  NetworkAnchors.createOrUpdate,
  "./examples/NetworkAnchors_CreateOrUpdate_MaximumSet_Gen.json",
  "NetworkAnchors_CreateOrUpdate maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  NetworkAnchors.update,
  "./examples/NetworkAnchors_Update_MaximumSet_Gen.json",
  "NetworkAnchors_Update maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  NetworkAnchors.delete,
  "./examples/NetworkAnchors_Delete_MaximumSet_Gen.json",
  "NetworkAnchors_Delete maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ResourceAnchors.listBySubscription,
  "./examples/ResourceAnchors_ListBySubscription_MaximumSet_Gen.json",
  "ResourceAnchors_ListBySubscription maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ResourceAnchors.listByResourceGroup,
  "./examples/ResourceAnchors_ListByResourceGroup_MaximumSet_Gen.json",
  "ResourceAnchors_ListByResourceGroup maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ResourceAnchors.get,
  "./examples/ResourceAnchors_Get_MaximumSet_Gen.json",
  "ResourceAnchors_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ResourceAnchors.createOrUpdate,
  "./examples/ResourceAnchors_CreateOrUpdate_MaximumSet_Gen.json",
  "ResourceAnchors_CreateOrUpdate maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ResourceAnchors.update,
  "./examples/ResourceAnchors_Update_MaximumSet_Gen.json",
  "ResourceAnchors_Update maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ResourceAnchors.delete,
  "./examples/ResourceAnchors_Delete_MaximumSet_Gen.json",
  "ResourceAnchors_Delete maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  AutonomousDatabases.action,
  "./examples/AutonomousDatabases_Action_MaximumSet_Gen.json",
  "AutonomousDatabases_Action maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  CloudExadataInfrastructures.configureExascale,
  "./examples/CloudExadataInfrastructures_ConfigureExascale_MaximumSet_Gen.json",
  "CloudExadataInfrastructures_ConfigureExascale maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbNodes.listByParent,
  "./examples/ExascaleDbNodes_ListByParent_MaximumSet_Gen.json",
  "ExascaleDbNodes_ListByParent maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbNodes.get,
  "./examples/ExascaleDbNodes_Get_MaximumSet_Gen.json",
  "ExascaleDbNodes_Get maximum-set example"
);

#suppress "@azure-tools/typespec-azure-core/no-openapi" "Example reference"
@@Autorest.example(
  ExascaleDbNodes.action,
  "./examples/ExascaleDbNodes_Action_MaximumSet_Gen.json",
  "ExascaleDbNodes_Action maximum-set example"
);
