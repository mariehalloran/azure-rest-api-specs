import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "@typespec/http";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Initiator Group Resource (PRIVATE PREVIEW) ====================
//
// `initiatorGroups` is a top-level (tracked) resource — a set of host initiators
// (FC WWPNs, iSCSI IQNs, or NVMe host NQNs) for one transport and role.
// PRIVATE PREVIEW: read-only data (GET/LIST); create/update/delete are placeholders
// for ARM tracked-resource lifecycle compliance (only tags are settable).

/**
 * An initiator group — a set of host initiators for one transport and role.
 */
@added(Versions.v2026_03_15_preview)
model InitiatorGroup
  is Azure.ResourceManager.TrackedResource<InitiatorGroupProperties> {
  ...ResourceNameParameter<
    Resource = InitiatorGroup,
    KeyName = "initiatorGroupName",
    SegmentName = "initiatorGroups",
    NamePattern = "^[a-zA-Z0-9-_]{3,63}$"
  >;
}

/**
 * Operations for initiator groups. Data is read-only (GET/LIST); create/update/
 * delete are placeholders for ARM tracked-resource lifecycle compliance.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface InitiatorGroups {
  /** Get an initiator group. */
  get is ArmResourceRead<InitiatorGroup>;

  /** Create or update an initiator group (placeholder; only tags are settable). */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<InitiatorGroup>;

  /** Update an initiator group's tags (placeholder). */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<InitiatorGroup, InitiatorGroupPatch>;

  /** Delete an initiator group (placeholder). */
  delete is ArmResourceDeleteWithoutOkAsync<InitiatorGroup>;

  /** List initiator groups in a resource group. */
  listByResourceGroup is ArmResourceListByParent<InitiatorGroup>;

  /** List initiator groups in a subscription. */
  listBySubscription is ArmListBySubscription<InitiatorGroup>;
}
