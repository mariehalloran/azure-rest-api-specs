import "./Artifact.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.CommonTypes.Private;
using Azure.ResourceManager.Private;
using OpenAPI;

namespace Microsoft.Migrate;

@added(ApiVersions.v2026_06_15_preview)
@armResourceOperations
interface Artifacts {
  @doc("Get the specified artifact by name.")
  get is ArmResourceRead<Artifact>;

  @doc("List the artifacts of a Migrate project, optionally filtered by associated resource ID or artifact type.")
  listByParent is ArmResourceListByParent<
    Artifact,
    Parameters = ArtifactListQueryParams
  >;

  @doc("Get the version history of an artifact. The service retains only the 20 most recent versions, so the returned history contains at most 20 entries.")
  getVersionHistory is ArmResourceActionSync<
    Artifact,
    void,
    ArtifactVersionHistoryResult
  >;

  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "This asynchronous action intentionally omits the Location header and is polled exclusively via the Azure-AsyncOperation status monitor (final-state-via: azure-async-operation), per ARM API review guidance. The terminal GenerateDownloadUrlResult is read from the status monitor's `properties`, so a Location-based final-state path is neither emitted nor used."
  @doc("Generate a time-limited download URL for the content of an artifact. For a single file the download URL is returned synchronously (200). For a directory the request is accepted (202) and runs asynchronously; poll the operation through the Azure-AsyncOperation status monitor, whose terminal status carries the generated download URL in its `properties`.")
  generateDownloadUrl is ArmResourceActionAsync<
    Artifact,
    GenerateDownloadUrlRequest,
    GenerateDownloadUrlResult,
    LroHeaders = ArmAsyncOperationHeader<
      StatusMonitor = GenerateDownloadUrlOperationStatus,
      FinalResult = GenerateDownloadUrlResult
    > &
      Azure.Core.Foundations.RetryAfterHeader
  >;
}

#suppress "@azure-tools/typespec-azure-core/no-private-usage" "Uses @armUpdateProviderNamespace to author the standard subscription/location-scoped operationStatuses status-monitor GET, matching the shipped ARM pattern (e.g. Microsoft.DeviceRegistry)."
@added(ApiVersions.v2026_06_15_preview)
@armResourceOperations
interface OperationStatus {
  @doc("Get the status of an asynchronous generateDownloadUrl operation. When the operation succeeds, the generated download URL is available in the `properties` field of the returned status monitor.")
  @autoRoute
  @armUpdateProviderNamespace
  get(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    @path
    @segment("providers")
    @doc("The Microsoft.Migrate provider namespace (this parameter will not show up in operations).")
    provider: "Microsoft.Migrate",

    @path
    @minLength(1)
    @segment("locations")
    @doc("The name of the Azure region.")
    @armCommonParameter(
      "LocationParameter",
      Azure.ResourceManager.CommonTypes.Versions.v6
    )
    location: string,

    @path
    @segment("operationStatuses")
    @minLength(1)
    @doc("The ID of the target asynchronous operation.")
    @armCommonParameter(
      "OperationIdParameter",
      Azure.ResourceManager.CommonTypes.Versions.v6
    )
    operationId: string,
  ): ArmResponse<GenerateDownloadUrlOperationStatus> | ErrorResponse;
}
