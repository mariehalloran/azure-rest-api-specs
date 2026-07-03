import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.AzureStackHCI;

// ==================== Initiator Group Resource (PRIVATE PREVIEW) ====================
//
// `initiatorGroups` is a top-level (tracked) resource — a set of host initiators
// (FC WWPNs, iSCSI IQNs, or NVMe host NQNs) for one transport and role.
// PRIVATE PREVIEW: read-only — only GET and LIST are exposed.

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
 * Read-only operations for initiator groups.
 */
@added(Versions.v2026_03_15_preview)
@armResourceOperations
interface InitiatorGroups {
  /** Get an initiator group. */
  get is ArmResourceRead<InitiatorGroup>;

  /** List initiator groups in a resource group. */
  listByResourceGroup is ArmResourceListByParent<InitiatorGroup>;

  /** List initiator groups in a subscription. */
  listBySubscription is ArmListBySubscription<InitiatorGroup>;
}
