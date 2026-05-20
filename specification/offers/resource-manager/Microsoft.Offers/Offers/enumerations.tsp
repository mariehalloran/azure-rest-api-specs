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

/** Request body for looking up an enumeration set by its type key. */
model LookupEnumerationRequest {
  /** The enumeration type key (for example, `categories`, `productFamilies`, `claimTypes`). */
  @pattern("^[a-zA-Z][a-zA-Z0-9]*$")
  enumerationType: string;
}

/** The result of an enumeration lookup. */
model LookupEnumerationResult {
  /** The enumeration type key the result corresponds to. */
  enumerationType: string;

  /** The enumeration values. Values are passed through verbatim from the upstream catalog feed. */
  values?: string[];
}

/** Read-only catalog lookup actions for enumeration sets. */
@armResourceOperations
interface Enumerations {
  /**
   * Look up a single enumeration set by its type key (for example,
   * `categories`). The catalog is globally keyed: the same `enumerationType`
   * returns the same response for all callers under one API version. Modeled
   * as a POST action because the response is identical for every caller in a
   * subscription and the catalog is not a per-subscription resource
   * collection.
   */
  @autoRoute
  @action("lookupEnumeration")
  lookup is ArmProviderActionSync<
    Request = LookupEnumerationRequest,
    Response = LookupEnumerationResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}
