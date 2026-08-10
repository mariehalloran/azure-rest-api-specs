import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./main.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.ResourceBuilder;

/** Dataset resource */
@parentResource(Workspace)
model Dataset is ProxyResource<DatasetProperties> {
  /** The name of the dataset. */
  @segment("datasets")
  @key("datasetName")
  @visibility(Lifecycle.Read)
  @path
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9-_.]{0,127}$")
  name: string;

  /**
   * Dataset kind discriminator. Determines which properties are valid for this dataset.
   * - Custom: Custom user-defined dataset.
   * - ArmResource: ARM (Azure Resource Manager) managed resource dataset.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "kind is a valid top-level property for Dataset resource"
  kind?: DatasetKind;

  /**
   * Gets or sets tags of the resource
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "Suppressing error expected"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Suppress expected ARM error"
  tags?: Record<string>;
}

/** Dataset kind discriminator */
union DatasetKind {
  /** Custom user-defined dataset. */
  Custom: "Custom",

  /** ARM (Azure Resource Manager) managed resource dataset. */
  ArmResource: "ArmResource",

  /** ARM (Azure Resource Manager) relationship dataset. */
  ArmRelationship: "ArmRelationship",

  string,
}

/** Dataset properties */
model DatasetProperties {
  /** Provisioning state of the dataset. */
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  /** Custom Dataset schema definition. */
  schema?: DatasetColumn[];

  /** ArmResource ArmResourceDatasetSchema object. */
  armResourceSchema?: ArmResourceDatasetSchema;

  /** ArmRelationship ArmRelationshipDatasetSchema object. */
  armRelationshipSchema?: ArmRelationshipDatasetSchema;

  /** Azure regions where the dataset exists. */
  locations?: string[];

  /** Reference to an existing data connection resource that provides the source connection for this dataset.
   * While this reference is set, the referenced data connection cannot be deleted until the dataset is
   * updated to remove the reference or the dataset itself is deleted. */
  connection?: DataConnectionReference;

  /** Path (e.g. blob prefix) within the target specified by the connection. Applicable only for StorageAccount kind connections. */
  path?: string;
}

/** Dataset column */
model DatasetColumn {
  /** Name of the column. */
  name: string;

  /** Data type of the column. */
  type: DatasetColumnType;

  /** Description of the column. */
  description?: string;
}

/** ARM resource dataset schema. */
model ArmResourceDatasetSchema {
  /** The type of the ARM resource. */
  type: string;
}

/** ARM relationship dataset schema. */
model ArmRelationshipDatasetSchema {
  /** The type of the ARM relationship. */
  type: string;
}

/** Dataset column type */
union DatasetColumnType {
  /** String column type. */
  String: "String",

  /** Integer column type. */
  Integer: "Integer",

  /** Boolean column type. */
  Boolean: "Boolean",

  /** DateTime column type. */
  DateTime: "DateTime",

  /** Dynamic column type. */
  Dynamic: "Dynamic",

  /** Guid column type. */
  Guid: "Guid",

  /** Long column type. */
  Long: "Long",

  /** Real column type. */
  Real: "Real",

  /** Timespan column type. */
  Timespan: "Timespan",

  /** Decimal column type. */
  Decimal: "Decimal",

  string,
}

@armResourceOperations
interface Datasets {
  get is ArmResourceRead<Dataset>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<Dataset>;

  /**
   * Delete a dataset.
   *
   * Delete-time dependency validation is enforced. A dataset cannot be deleted while one or more jobs
   * still reference it as an input or output through `JobProperties.inputs` or `JobProperties.outputs`
   * (via `JobDataset.dataset`). If any consuming job exists, the delete is rejected with the
   * `ResourceDeleteHasActiveConsumers` error (code `ARB-RP-228`) and the dataset is not deleted. The error reports the total
   * number of consumers and returns links to the consuming jobs, each with the property path of the reference.
   *
   * Required steps before deleting a dataset:
   * 1. Identify every job whose `properties.inputs` or `properties.outputs` reference this dataset.
   * 2. For each consuming job, either update it to remove the reference to this dataset or delete the job
   *    (and, where applicable, the pipeline that contains it).
   * 3. Once no job references this dataset, retry this delete request.
   *
   * The delete is performed asynchronously: the service returns 202 Accepted with a Location header
   * to poll, or 204 No Content when the dataset does not exist.
   */
  delete is ArmResourceDeleteWithoutOkAsync<Dataset>;
  list is ArmResourceListByParent<Dataset>;
}
