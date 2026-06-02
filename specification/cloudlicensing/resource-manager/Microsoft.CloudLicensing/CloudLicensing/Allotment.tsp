import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using Azure.ResourceManager;

namespace Microsoft.CloudLicensing;

/**
 * A license allotment resource representing a container of licenses.
 * Modeled as an ARM extension resource on a parent ARM resource (e.g., a
 * Microsoft.SaaSHub/cloudServices resource). The allowed extension parents
 * are constrained by the resource provider manifest.
 */
@extensionResource
model Allotment is Azure.ResourceManager.ProxyResource<AllotmentProperties> {
  ...ResourceNameParameter<
    Resource = Allotment,
    KeyName = "allotmentName",
    SegmentName = "allotments",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9_.-]{2,62}$"
  >;
}

@armResourceOperations
interface Allotments {
  /**
   * Gets a license allotment by its identifier.
   */
  get is ArmResourceRead<Allotment>;

  /**
   * Lists all license allotments under the parent ARM resource.
   */
  listByParent is ArmResourceListByParent<Allotment>;
}

@@maxLength(Allotment.name, 63);
@@minLength(Allotment.name, 3);
@@doc(Allotment.name, "The name that uniquely identifies a license allotment.");
@@doc(Allotment.properties, "The properties of a license allotment.");
