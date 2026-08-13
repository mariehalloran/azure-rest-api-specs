import "@typespec/http";
import "@typespec/openapi";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.Windows365;

/** Resource group scope parameters for Windows 365 operations. */
model Windows365ResourceGroupScopeParameters {
  ...Azure.ResourceManager.CommonTypes.ApiVersionParameter;

  /** The Azure subscription ID. */
  @path
  @segment("subscriptions")
  subscriptionId: string;

  /** The name of the resource group. */
  @path
  @segment("resourceGroups")
  resourceGroupName: string;
}

/** Represents a cloudPcDelegatedMsi resource. */
model CloudPcDelegatedMsi
  is Azure.ResourceManager.TrackedResource<CloudPcDelegatedMsiProperties> {
  /** The name of the Cloud PC delegated managed identity resource. */
  @pattern("^(?![.-])[A-Za-z0-9_.-]{1,128}$")
  @key("cloudPcDelegatedMsiName")
  @segment("cloudPcDelegatedMsis")
  @path
  @visibility(Lifecycle.Read)
  name: string;

  /** Delegated managed identity properties. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "The existing API uses a delegated managed identity envelope."
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentityWithDelegation;
}

/** Operations for Cloud PC delegated managed identity resources. */
@armResourceOperations
interface CloudPcDelegatedMsis {
  /** Get a Cloud PC delegated managed identity resource. */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "The operation ID preserves the existing API contract."
  @operationId("CloudPcDelegatedMsi_Get")
  get is ArmResourceRead<
    CloudPcDelegatedMsi,
    BaseParameters = Windows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /** Create or update a Cloud PC delegated managed identity resource. */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "The operation ID preserves the existing API contract."
  @operationId("CloudPcDelegatedMsi_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CloudPcDelegatedMsi,
    BaseParameters = Windows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /** Update a Cloud PC delegated managed identity resource. */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "The operation ID preserves the existing API contract."
  @operationId("CloudPcDelegatedMsi_Update")
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    CloudPcDelegatedMsi,
    PatchModel = CloudPcDelegatedMsiUpdate,
    BaseParameters = Windows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /** Delete a Cloud PC delegated managed identity resource. */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "The operation ID preserves the existing API contract."
  @operationId("CloudPcDelegatedMsi_Delete")
  delete is ArmResourceDeleteSync<
    CloudPcDelegatedMsi,
    BaseParameters = Windows365ResourceGroupScopeParameters,
    Error = CloudError
  >;

  /** List Cloud PC delegated managed identity resources by resource group. */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "The operation ID preserves the existing API contract."
  @operationId("CloudPcDelegatedMsi_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    CloudPcDelegatedMsi,
    BaseParameters = Windows365ResourceGroupScopeParameters,
    Parameters = {
      /** The maximum number of resources to return. */
      @query("$top")
      $top?: int32;
    },
    Response = ArmResponse<CloudPcDelegatedMsiListResult>
  >;

  /** List Cloud PC delegated managed identity resources by subscription. */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "The operation ID preserves the existing API contract."
  @operationId("CloudPcDelegatedMsi_ListBySubscription")
  listBySubscription is ArmListBySubscription<
    CloudPcDelegatedMsi,
    Parameters = {
      /** The maximum number of resources to return. */
      @query("$top")
      $top?: int32;
    },
    Response = ArmResponse<CloudPcDelegatedMsiListResult>,
    Error = CloudError
  >;
}

/** Result of the list cloudPcDelegatedMsis operation. */
model CloudPcDelegatedMsiListResult {
  /** Current page of results. */
  @pageItems
  @visibility(Lifecycle.Read)
  value?: CloudPcDelegatedMsi[];

  /** URL to get the next set of results, if any. */
  @nextLink
  @visibility(Lifecycle.Read)
  nextLink?: string;
}

@@doc(CloudPcDelegatedMsi.name, "The name of the cloudPcDelegatedMsi.");
@@doc(CloudPcDelegatedMsi.properties, "CloudPcDelegatedMsi properties");
#suppress "@azure-tools/typespec-azure-core/no-openapi" "For backward compatibility with the existing x-ms-client-flatten extension."
#suppress "@azure-tools/typespec-azure-core/no-openapi-client-extensions" "Existing use of the 'x-ms-client-flatten' OpenAPI extension predates the no-openapi-client-extensions rule; suppressed pending migration to explicit modeling without flattening."
@@extension(CloudPcDelegatedMsi.properties, "x-ms-client-flatten", true);
#suppress "@azure-tools/typespec-azure-core/no-openapi" "For backward compatibility with the existing readOnly enum extension."
@@extension(ProvisioningState, "readOnly", true);
#suppress "@azure-tools/typespec-azure-core/no-openapi" "For backward compatibility with the existing x-ms-external extension."
@@extension(CloudError, "x-ms-external", true);
#suppress "@azure-tools/typespec-azure-core/no-openapi" "For backward compatibility with the existing x-ms-external extension."
@@extension(CloudErrorBody, "x-ms-external", true);
@@doc(
  CloudPcDelegatedMsis.createOrUpdate::parameters.resource,
  "Represents a CloudPcDelegatedMsi."
);
@@doc(
  CloudPcDelegatedMsis.update::parameters.properties,
  "Updatable CloudPcDelegatedMsi properties."
);
#suppress "deprecated" "For backward compatibility with the existing body parameter name."
@@encodedName(
  CloudPcDelegatedMsis.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
#suppress "deprecated" "For backward compatibility with the existing body parameter name."
@@encodedName(
  CloudPcDelegatedMsis.update::parameters.properties,
  "application/json",
  "body"
);
