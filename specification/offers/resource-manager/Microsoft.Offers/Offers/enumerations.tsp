import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Offers;

/**
 * Enumeration resource.
 *
 * Returns one enumeration set (for example, `categories`, `productFamilies`,
 * `claimTypes`) sourced from the BigCat enumeration and domain-data
 * controllers. A single container resource type keeps new enumerations
 * extensible without minting a new ARM type per enumeration.
 *
 * Addressed at
 * `/subscriptions/{subscriptionId}/providers/Microsoft.Offers/enumerations/{enumerationType}`.
 */
@subscriptionResource
model Enumeration
  is Azure.ResourceManager.ProxyResource<EnumerationProperties> {
  ...ResourceNameParameter<
    Resource = Enumeration,
    KeyName = "enumerationType",
    SegmentName = "enumerations",
    NamePattern = "^[a-zA-Z][a-zA-Z0-9]*$"
  >;
}

/** Read-only operations on enumeration catalog resources. */
@armResourceOperations
interface Enumerations {
  /**
   * Get a single enumeration set by its type key (for example, `categories`).
   */
  get is ArmResourceRead<Enumeration>;
}

@@doc(Enumeration.name,
  "The enumeration type key (for example, `categories`, `productFamilies`, `claimTypes`)."
);
@@doc(Enumeration.properties, "The properties of the enumeration resource.");
