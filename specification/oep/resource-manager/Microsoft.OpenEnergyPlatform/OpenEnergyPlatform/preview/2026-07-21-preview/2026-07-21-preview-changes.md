# PBI 72283 — `2026-07-21-preview` Change Summary

**API:** `Microsoft.OpenEnergyPlatform/EnergyServices`
**New version:** `2026-07-21-preview` (preview), based on `2026-02-02-preview`
**Purpose:** [Flex] updated design + Scale feature

> **TL;DR for the reviewer**
>
> New preview version. `2026-02-02-preview` is **functionally unchanged**; the only deltas to its
> emitted `oep.json` are doc-string wording fixes and the `ListByOAKInstance`→`ListByADMEInstance`
> operationId rename, all applied per API-review feedback (no behavioral change).
> **`2026-02-02-preview` is not used by any customers and will not be supported**;
> `2026-07-21-preview` supersedes it. Several changes below are intentionally **breaking versus
> `2026-02-02-preview`** — that is expected and acceptable because that version is unused, and in
> some cases the change reverts behavior back to how all other API versions function. Changes
> include: 2 properties added, 1 removed, `addOnPackages` reshaped to a 2-value enum,
> and the PATCH surface expanded.

---

## Properties added (resource `properties`)

| Property | Type | Notes |
|---|---|---|
| `backupAndRestore` | extensible enum: `Enabled` \| `Disabled` | **Optional, no default.** Modeled as an extensible enum (not a boolean) per API-review guidance. When omitted, the resource provider applies `Disabled`. Intentionally no spec-level `default` so the RP can distinguish "omitted" from an explicit `Disabled`. |
| `acz` | object | `{ "identity": { "identityType": "SystemAssigned" \| "UserAssigned", "userAssignedIdentityId": string } }`. `userAssignedIdentityId` required when `identityType == UserAssigned`. |

> **Required vs optional (finalized):**
> - **Required** (create + response): none — all properties remain **optional**, matching
>   `2025-12-15` and prior. (An earlier revision made `authAppId`/`dataPartitionNames`/`sku`
>   required via `@madeRequired`; that was reverted.)
> - **Optional**: `authAppId`, `dataPartitionNames`, `sku`, `encryption`, `eds`, `acz`,
>   `privateEndpointConnections`, `corsRules`, `addOnPackages`, `geoRedundancy`, `backupAndRestore`,
>   `referenceData`, `upgradeSettings`, `publicNetworkAccess`.
> - **Read-only** (server-set): `dnsName`, `provisioningState`, `milestoneVersion`.
>
> `geoRedundancy` and `backupAndRestore` are **optional with no default**. The resource provider
> applies `Disabled` when either is omitted. We deliberately omit a spec-level `default` so the RP
> can tell "customer omitted the field" apart from "customer explicitly chose `Disabled`" — a
> spec `default` (or a client SDK materializing it) would erase that distinction. In
> `2026-02-02-preview`, `geoRedundancy` keeps its original optional + default `Enabled` (unchanged).
> Only `publicNetworkAccess` retains a documented default (`Enabled`) in the new version.

## Properties removed

| Property | Was | Replacement |
|---|---|---|
| `autoScaleMaxCapacity` | `int32` | Scale is now driven by the patchable `sku.capacity`. |

## Property reshaped

**`addOnPackages`** — changed from an **array of objects** to an **array of enum strings**.

- Old (`2026-02-02`): `[ { "name": "Reservoir", "properties": { "state": "Enabled" } }, ... ]`
  Allowed names: `ExternalDataServices`, `PetrelV2`, `Reservoir`, `RockAndFluid`, `Seismic`, `Wellbore`, `WellDelivery`.
- New (`2026-07-21`): `[ "Advanced", "Analytics" ]`
  Allowed values (extensible enum): **`Advanced`, `Analytics` only**.

> Impact: the element type changes from a package DTO (`{name, properties.state}`) to a
> plain enum. The old `AddOnPackage` / `AddOnPackageItemProperties` / `PackageState` types
> and the 7 old package names are no longer part of this version. This is a **breaking change
> versus `2026-02-02-preview`**, which is acceptable because `2026-02-02-preview` is not used
> by any customers and will not be supported.
>
> Note: the shared `.tsp` retains the old object-array field (as `addOnPackagesV1`, emitted on
> the wire as `addOnPackages` in `2026-02-02-preview` via `@renamedFrom`) so the old version's
> contract is preserved. Its doc comment is now marked **"DEPRECATED and not supported"**; because
> the `.tsp` is shared, that also updates the `addOnPackages` description in
> `2026-02-02-preview/oep.json` (doc-only, non-breaking). The `AddOnPackage` /
> `AddOnPackageItemProperties` / `PackageState` definitions are not marked `@removed` — they
> remain in use by `2026-02-02-preview` and drop out of `2026-07-21-preview` automatically as
> unreachable types.

## New types

- `BackupAndRestore` enum: `Enabled`, `Disabled`
- `AddOnPackageName` (now the `addOnPackages` element type): `Advanced`, `Analytics`
- `Acz` object + `AczIdentity` object (`identityType`: `SystemAssigned` / `UserAssigned`; `userAssignedIdentityId`: string)

## PrivateEndpointConnectionProxy — nested → flat shape correction

The merged `2026-02-02-preview` nested `eTag` / `remotePrivateEndpoint` / `status` under
`properties`, which was a defect versus the control-plane RP and the stable `2025-12-15` base.
`2026-07-21-preview` corrects this to the **flat** shape (matches stable):

- `eTag`, `remotePrivateEndpoint`, `status` → **top level** of the resource (siblings of `id`/`name`/`type`).
- `properties` bag → contains only `provisioningState` (read-only).

Old shape (`2026-02-02-preview`): `{ id, name, type, properties: { eTag, remotePrivateEndpoint, status, provisioningState } }`
New shape (`2026-07-21-preview`): `{ id, name, type, eTag, remotePrivateEndpoint, status, properties: { provisioningState } }`

> This is an internal RPaaS DO-NOT-USE resource; the flat shape is intentional and matches the
> control-plane RP. Two lint rules are suppressed at the TypeSpec level with justification
> (`arm-resource-invalid-envelope-property`, `arm-resource-duplicate-property`).
>
> This is a **breaking change versus `2026-02-02-preview`**, and that is expected and fine:
> `2026-02-02-preview` is not used by any customers and will not be supported, and this change
> reverts `PrivateEndpointConnectionProxy` back to the flat shape used by **all other API
> versions** (including stable `2025-12-15`) and by the control-plane RP. The nested shape in
> `2026-02-02-preview` was the anomaly.

---

## PATCH (Update) surface

**Newly settable via PATCH in this version:**

| PATCH field | Type | Note |
|---|---|---|
| `sku` | object, **`capacity` only** | Only `capacity` (int32) is updatable via `SkuUpdate`; `name`/`tier`/`size`/`family` are **not** patchable. |
| `geoRedundancy` | enum `Enabled`/`Disabled` | now patchable |
| `backupAndRestore` | enum `Enabled`/`Disabled` | now patchable |
| `acz` | object | now patchable |
| `eds` | object (`EdsUpdate`) | now patchable — PATCH-specific model with no required/default sub-properties |
| `publicNetworkAccess` | enum `Enabled`/`Disabled` | now patchable |
| `corsRules` | array | now patchable |
| `upgradeSettings` | object (`UpgradeSettingsUpdate`) | now patchable — PATCH-specific model (no defaults); incl. `upgradePolicy` and `readyForUpgrade`; `autoUpgradeAfterDate` stays read-only |
| `addOnPackages` | enum array | new `["Advanced","Analytics"]` shape |
| `encryption` | object | already patchable |

**Full PATCHable set:** `encryption`, `sku.capacity`, `addOnPackages`, `geoRedundancy`,
`backupAndRestore`, `acz`, `eds`, `publicNetworkAccess`, `corsRules`,
`upgradeSettings` (`upgradePolicy` + `readyForUpgrade`).

**NOT patchable:**
- Settable only at create (in PUT, absent from PATCH): `authAppId`, `dataPartitionNames`,
  `privateEndpointConnections`, `referenceData`, and `sku.name`/`tier`/`size`/`family`.
- Read-only (server-set): `dnsName`, `provisioningState`, `milestoneVersion`,
  `upgradeSettings.autoUpgradeAfterDate`.

---

## Required-status changes

None. `authAppId`, `dataPartitionNames`, and `sku` remain **optional** in `2026-07-21-preview`,
matching `2025-12-15` and all prior versions. (An earlier revision made them required via
`@madeRequired(2026_07_21_preview)`; that was reverted, so no property becomes newly required in
this version.)

## Unchanged (carried over)

`encryption`, `eds`, `publicNetworkAccess`, `privateEndpointConnections`, `corsRules`,
`geoRedundancy`, `referenceData`, `milestoneVersion`, `upgradeSettings`, plus the resource
envelope (`location`, `tags`, `identity`, `systemData`). (`sku` read shape is still the full ARM
SKU: name/tier/size/family/capacity.)

## Files touched

- `models.tsp`, `GroupInformation.tsp`, `PrivateEndpointConnection.tsp`,
  `PrivateEndpointConnectionProxy.tsp`, `routes.tsp`, `client.tsp`, `readme.md` (modified)
- `examples/2026-07-21-preview/` and `examples/2026-02-02-preview/` (source examples; the
  OAK→ADME operation rename affects both)
- `preview/2026-07-21-preview/oep.json`, `preview/2026-02-02-preview/oep.json` + emitted
  `examples/` (generated by `tsp compile`)

## Notes

- The per-package config for `Advanced`/`Analytics` is intentionally minimal (enum values
  only) pending the service team's final design.
- `sku.capacity` (PATCHable): the scale capacity must be a power of 2 **between 2 and 128**
  (applicable for Flex SKU). The `2`–`128` range is now enforced in the schema via
  `minimum`/`maximum` on `SkuUpdate.capacity`; the "power of 2" rule remains server-enforced
  (not expressible in OpenAPI).
- Terminology cleanup: internal references to the legacy names **`OAK`** and **`MEDS`** in
  descriptions/config prose were changed to **`ADME`**. The `.tsp` source is shared across
  versions, so this text change also appears in `2026-02-02-preview`. Per API-review feedback, the
  three `ListByOAKInstance` operationIds were also renamed to **`ListByADMEInstance`**
  (`PrivateEndpointConnectionProxies` / `PrivateEndpointConnections` / `PrivateLinkResources`) in
  both `2026-02-02-preview` and `2026-07-21-preview`, and the matching example files were renamed;
  this changes SDK method names for these internal DO-NOT-USE operations. The `meds.json` input
  filename and older/stable shipped `oep.json` files were left unchanged.
- Acronyms expanded on first use (per API review): **ADME** → "Azure Data Manager for Energy
  (ADME)" and **ACZ** → "Analytics Consumption Zone (ACZ)"; also fixed "a ADME" → "an ADME".
- PATCH-specific models (per API review, RPC-Patch-V1-10): `eds` and `upgradeSettings` in the PATCH
  body now use `EdsUpdate` / `UpgradeSettingsUpdate`, which drop all required and default
  sub-properties so omitted fields are preserved under JSON Merge Patch. As a result the file-wide
  `PatchBodyParametersSchema` suppression was **removed**; the remaining `BodyTopLevelProperties`
  suppression is now scoped with `where: '$.definitions.PrivateEndpointConnectionProxy'`.
- `geoRedundancy` (per API review): the doc comment now states that omitting the property leaves
  geo-redundancy not enabled (in `2026-02-02-preview` it defaulted to `Enabled`).
- Canonical Create example (per API review): the `sku` block now uses realistic Flex values
  (`{ "name": "Flex", "tier": "Standard", "capacity": 8 }`) and the envelope `identity` was
  corrected to `{ "type": "None" }`.
- `checkNameAvailability` tag restored to **`Locations`** (the TypeSpec conversion had renamed the
  interface to `LocationsOperationGroup`, changing the swagger tag in `2026-02-02-preview`). Done by
  renaming the interface back to `Locations`; operationId is unchanged. Tag-only, applies to both
  `2026-02-02-preview` and `2026-07-21-preview`.
- Private link resource alignment: `GroupInformationProperties` now uses **composition** (spreads
  `...PrivateLinkResourceProperties`) instead of `extends`, removing the
  `composition-over-inheritance` suppression. The emitted swagger definition changes from an
  `allOf` reference to inlined `groupId`/`requiredMembers`/`requiredZoneNames` properties; the
  fields and their `readOnly` flags — and therefore the runtime JSON contract — are unchanged.
- Terminology cleanup (per API review): the phrase **"ARM resource id"** was changed to
  **"Azure resource id"** in the user-assigned-identity descriptions on `Encryption`, `Eds`, and
  `Acz`. "ARM" is redundant there. `Encryption`/`Eds` are shared models, so this description-only
  text change also appears in `2026-02-02-preview`; `Acz` is new to this version.
- `Acz.identity.userAssignedIdentityId` (per API review): typed as
  `armResourceIdentifier<[{ type: "Microsoft.ManagedIdentity/userAssignedIdentities" }]>` so it
  emits `format: arm-id` and `x-ms-arm-id-details` restricting the allowed resource type to a
  user-assigned managed identity. Scoped to `Acz` (new this version); the shared `Encryption`/`Eds`
  identity fields were left as-is to keep `2026-02-02-preview` byte-for-byte and avoid a
  breaking-change flag on the already-shipped preview.
- `readme.md`: the `package-2026-07-21-preview` tag section was placed **after**
  `package-2026-02-02-preview` to keep the tag blocks in date-sorted order (no functional effect).
