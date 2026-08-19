import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./main.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.ResourceBuilder;

/** Data connection resource */
@parentResource(Workspace)
model DataConnection is ProxyResource<DataConnectionProperties> {
  /** The name of the data connection. */
  @segment("dataConnections")
  @key("dataConnectionName")
  @visibility(Lifecycle.Read)
  @path
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-_.]{0,127}$")
  name: string;

  /** Data connection kind discriminator. Determines which properties are valid for this data connection. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "kind is a valid top-level property for DataConnection resource"
  kind: DataConnectionKind;

  /**
   * Gets or sets tags of the resource
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Suppressing error expected"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Suppress expected ARM error"
  tags?: Record<string>;
}

/** Data connection kind discriminator */
union DataConnectionKind {
  /** Azure Data Explorer data connection. */
  AzureDataExplorer: "AzureDataExplorer",

  /** Storage Account data connection. */
  StorageAccount: "StorageAccount",

  string,
}

/** Data connection properties - properties vary by kind.
 * Each data connection kind has specific required and optional properties as documented below.
 */
model DataConnectionProperties {
  /** Provisioning state of the data connection. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  // ============================================
  // AzureDataExplorer specific properties (kind: "AzureDataExplorer")
  // ============================================
  /** URI of the Azure Data Explorer cluster. Required for AzureDataExplorer data connections. */
  clusterUri?: string;

  /** Name of the database within the Azure Data Explorer cluster. Required for AzureDataExplorer data connections. */
  databaseName?: string;

  // ============================================
  // StorageAccount specific properties (kind: "StorageAccount")
  // ============================================
  /** URI of the Azure Storage Account. Required for StorageAccount data connections. */
  storageAccountUri?: string;

  /** Name of the container within the Azure Storage Account. Required for StorageAccount data connections. */
  containerName?: string;
}

/** Data connection reference. Used to link a dataset to an existing data connection resource.
 *
 * While a dataset holds this reference, the referenced data connection cannot be deleted.
 * Detach the reference (update the dataset) or delete the dataset before deleting the data connection.
 */
model DataConnectionReference {
  /** ARM resource ID of the data connection. */
  id: string;
}

@armResourceOperations
interface DataConnections {
  get is ArmResourceRead<DataConnection>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataConnection>;

  /**
   * Delete a data connection.
   *
   * Delete-time dependency validation is enforced. A data connection cannot be deleted while one or
   * more datasets in the same workspace still reference it through `DatasetProperties.connection.id`.
   * If any consuming dataset exists, the delete is rejected with the `ResourceDeleteHasActiveConsumers`
   * error (code `ARB-RP-228`) and the data connection is not deleted. The error reports the total number of consumers and
   * returns links to the consuming datasets, each with the property path of the reference.
   *
   * Required steps before deleting a data connection:
   * 1. Identify every dataset in the workspace whose `properties.connection.id` references this data connection.
   * 2. For each consuming dataset, either update it to reference a different data connection (detach)
   *    or delete the dataset.
   * 3. Once no dataset references this data connection, retry this delete request.
   *
   * The delete is performed asynchronously: the service returns 202 Accepted with a Location header
   * to poll, or 204 No Content when the data connection does not exist.
   */
  delete is ArmResourceDeleteWithoutOkAsync<DataConnection>;
  list is ArmResourceListByParent<DataConnection>;
}
