# PBI 72283 — `2026-07-21-preview` Change Summary

**API:** `Microsoft.OpenEnergyPlatform/EnergyServices`
**New version:** `2026-07-21-preview` (preview), based on `2026-02-02-preview`
**Purpose:** [Flex] updated design + Scale feature

> **TL;DR for the reviewer**
>
> New preview version. All changes are version-gated, so `2026-02-02-preview/oep.json`
> is **byte-for-byte unchanged**. Changes are limited to the `EnergyService` resource
> `properties` and its PATCH body: 2 properties added, 1 removed, `addOnPackages`
> reshaped to a 2-value enum, and the PATCH surface expanded.

---

## Properties added (resource `properties`)

| Property | Type | Notes |
|---|---|---|
| `backupAndRestore` | extensible enum: `Enabled` \| `Disabled` | Default `Enabled`. Modeled as an extensible enum (not a boolean) per API-review guidance. |
| `acz` | object | `{ "identity": { "identityType": "SystemAssigned" \| "UserAssigned", "userAssignedIdentityId": string } }`. `userAssignedIdentityId` required when `identityType == UserAssigned`. |

## Properties removed

| Property | Was | Replacement |
|---|---|---|
| `autoScaleMaxCapacity` | `int32` | Scale is now driven by the patchable `sku.capacity`. |

## Property reshaped

**`addOnPackages`** — changed from an **array of objects** to an **array of enum strings**.

- Old (`2026-02-02`): `[ { "name": "Reservoir", "properties": { "state": "Enabled" } }, ... ]`
  Allowed names: `ExternalDataServices`, `PetrelV2`, `Reservoir`, `RockAndFluid`, `Seismic`, `Wellbore`, `WellDelivery`.
- New (`2026-07-21`): `[ "Enterprise", "Analytics" ]`
  Allowed values (extensible enum): **`Enterprise`, `Analytics` only**.

> Impact: the element type changes from a package DTO (`{name, properties.state}`) to a
> plain enum. The old `AddOnPackage` / `AddOnPackageItemProperties` / `PackageState` types
> and the 7 old package names are no longer part of this version.

## New types

- `BackupAndRestore` enum: `Enabled`, `Disabled`
- `AddOnPackageName` (now the `addOnPackages` element type): `Enterprise`, `Analytics`
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

---

## PATCH (Update) surface

**Newly settable via PATCH in this version:**

| PATCH field | Type | Note |
|---|---|---|
| `sku` | object, **`capacity` only** | Only `capacity` (int32) is updatable. `name`/`tier`/`size`/`family` are **not** patchable. |
| `geoRedundancy` | enum `Enabled`/`Disabled` | now patchable |
| `backupAndRestore` | enum `Enabled`/`Disabled` | now patchable |
| `acz` | object | now patchable |
| `eds` | object | now patchable |
| `publicNetworkAccess` | enum `Enabled`/`Disabled` | now patchable |
| `corsRules` | array | now patchable |
| `upgradeSettings` | object | now patchable — incl. `upgradePolicy` and `readyForUpgrade`; `autoUpgradeAfterDate` stays read-only |
| `addOnPackages` | enum array | new `["Enterprise","Analytics"]` shape |
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

## Unchanged (carried over)

`authAppId`, `dataPartitionNames`, `encryption`, `eds`, `publicNetworkAccess`,
`privateEndpointConnections`, `corsRules`, `sku` (read shape = full ARM SKU:
name/tier/size/family/capacity), `geoRedundancy`, `referenceData`, `milestoneVersion`,
`upgradeSettings`, plus the resource envelope (`location`, `tags`, `identity`, `systemData`).

## Files touched

- `main.tsp`, `models.tsp`, `PrivateEndpointConnectionProxy.tsp`, `readme.md` (modified)
- `examples/2026-07-21-preview/` (40 source examples)
- `preview/2026-07-21-preview/oep.json` + emitted `examples/` (generated by `tsp compile`)

## Notes

- The per-package config for `Enterprise`/`Analytics` is intentionally minimal (enum values
  only) pending the service team's final design.
