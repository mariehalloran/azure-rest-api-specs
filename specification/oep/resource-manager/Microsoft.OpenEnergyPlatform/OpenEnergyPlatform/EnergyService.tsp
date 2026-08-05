import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.OpenEnergyPlatform;
/**
 * An Energy service resource.
 */
model EnergyService
  is Azure.ResourceManager.TrackedResource<EnergyServiceProperties> {
  ...ResourceNameParameter<
    Resource = EnergyService,
    KeyName = "resourceName",
    SegmentName = "energyServices",
    NamePattern = "^[a-zA-Z0-9]*$"
  >;
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
}

@armResourceOperations
interface EnergyServices {
  /**
   * Returns oep resource for a given name.
   */
  get is ArmResourceRead<EnergyService>;

  /**
   * Method that gets called if subscribed for ResourceCreationBegin trigger.
   */
  create is ArmResourceCreateOrReplaceAsync<EnergyService>;

  /**
   * Updates the oep resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "Preserving existing wire contract: 202 response includes body."
  #suppress "@azure-tools/typespec-azure-resource-manager/lro-location-header" "Preserving existing wire contract."
  @patch(#{ implicitOptionality: false })
  update is Azure.ResourceManager.Legacy.CustomPatchAsync<
    EnergyService,
    PatchModel = EnergyResourceUpdate,
    Response =
      | ArmResponse<EnergyService>
      | (ArmAcceptedLroResponse<LroHeaders = ArmAsyncOperationHeader<FinalResult = EnergyService> &
          Azure.Core.Foundations.RetryAfterHeader> & {
          @bodyRoot
          _: EnergyService;
        }),
    OptionalRequestBody = true
  >;

  /**
   * Deletes oep resource
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "Preserving original response shape for backward compatibility."
  delete is ArmResourceDeleteWithoutOkAsync<
    EnergyService,
    Response =
      | ArmDeletedResponse
      | ArmDeleteAcceptedLroResponse
      | ArmDeletedNoContentResponse
  >;

  /**
   * Returns list of oep resources..
   */
  listByResourceGroup is ArmResourceListByParent<
    EnergyService,
    Response = ArmResponse<EnergyServiceList>
  >;

  /**
   * Lists a collection of oep resources under the given Azure Subscription ID.
   */
  listBySubscription is ArmListBySubscription<
    EnergyService,
    Response = ArmResponse<EnergyServiceList>
  >;

  /**
   * Method that gets called if new partition is to be added in a resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "Preserving existing wire contract: 202 response includes body."
  addPartition is ArmResourceActionAsyncBase<
    EnergyService,
    DataPartitionAddOrRemoveRequest,
    ArmAcceptedLroResponse & {
      @bodyRoot
      _: DataPartitionAddOrRemoveRequest;
    },
    BaseParameters = Azure.ResourceManager.Foundations.DefaultBaseParameters<EnergyService>,
    OptionalRequestBody = true
  >;

  /**
   * Method that gets called if new partition is to be removed from a resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "Preserving existing wire contract: 202 response includes body."
  removePartition is ArmResourceActionAsyncBase<
    EnergyService,
    DataPartitionAddOrRemoveRequest,
    ArmAcceptedLroResponse & {
      @bodyRoot
      _: DataPartitionAddOrRemoveRequest;
    },
    BaseParameters = Azure.ResourceManager.Foundations.DefaultBaseParameters<EnergyService>,
    OptionalRequestBody = true
  >;

  /**
   * Method that gets called when list of partitions is requested.
   */
  listPartitions is ArmResourceActionSync<
    EnergyService,
    void,
    ArmResponse<DataPartitionsListResult>
  >;

  /**
   * Marks an energy services resource as ready for upgrade during a milestone testing period.
   */
  markReadyForUpgrade is ArmResourceActionSync<EnergyService, void, OkResponse>;
}

@@maxLength(EnergyService.name, 15);
@@minLength(EnergyService.name, 1);
@@doc(EnergyService.name, "The resource name.");
@@doc(
  EnergyService.properties,
  "The properties of an Energy service resource."
);
@@doc(EnergyServices.create::parameters.resource, "Request body.");
@@doc(
  EnergyServices.update::parameters.properties,
  "Energy Resource Update definition"
);
@@doc(
  EnergyServices.addPartition::parameters.body,
  "add partition action payload"
);
@@doc(
  EnergyServices.removePartition::parameters.body,
  "remove partition action payload"
);
