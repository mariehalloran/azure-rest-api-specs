import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Allotment.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.CloudLicensing;

/**
 * A license assignment resource representing a license assigned to an identity.
 */
@parentResource(Allotment)
model Assignment is Azure.ResourceManager.ProxyResource<AssignmentProperties> {
  ...ResourceNameParameter<
    Resource = Assignment,
    KeyName = "assignmentName",
    SegmentName = "assignments",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9_.-]{2,62}$"
  >;
}

@armResourceOperations
interface Assignments {
  /**
   * Gets a license assignment by its identifier.
   */
  get is ArmResourceRead<Assignment>;

  /**
   * Creates or updates a license assignment.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Assignment>;

  /**
   * Deletes a license assignment.
   */
  delete is ArmResourceDeleteWithoutOkAsync<Assignment>;

  /**
   * Lists all license assignments under an allotment.
   */
  listByAllotment is ArmResourceListByParent<Assignment>;
}

@@maxLength(Assignment.name, 63);
@@minLength(Assignment.name, 3);
@@doc(
  Assignment.name,
  "The name that uniquely identifies a license assignment."
);
@@doc(Assignment.properties, "The properties of a license assignment.");
@@doc(
  Assignments.createOrUpdate::parameters.resource,
  "The assignment resource to create or update."
);
