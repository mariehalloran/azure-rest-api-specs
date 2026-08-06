# `2026-07-21-preview` Change Summary

**API:** `Microsoft.OpenEnergyPlatform/EnergyServices`
**Version:** `2026-07-21-preview` (preview), based on `2026-02-02-preview`
**Purpose:** [Flex] updated design + Scale feature

`2026-07-21-preview` supersedes `2026-02-02-preview`, which is not used by any customers and will
not be supported. Some changes below are breaking relative to `2026-02-02-preview`; in several
cases they restore behavior shared by all other API versions (including stable `2025-12-15`).

---

## Properties added (resource `properties`)

| Property | Type | Notes |
|---|---|---|
| `backupAndRestore` | extensible enum: `Enabled` \| `Disabled` | Optional, no default. Modeled as an extensible enum (not a boolean). The resource provider applies `Disabled` when omitted; no spec-level `default` so the RP can distinguish "omitted" from an explicit `Disabled`. |
| `acz` | object | `{ "identity": { "identityType": "SystemAssigned" \| "UserAssigned", "userAssignedIdentityId": string } }`. `userAssignedIdentityId` is required when `identityType == UserAssigned`. |

**Required vs optional:**

- Required (create + response): none — all properties are optional, matching `2025-12-15` and prior.
- Optional: `authAppId`, `dataPartitionNames`, `sku`, `encryption`, `eds`, `acz`,
  `privateEndpointConnections`, `corsRules`, `addOnPackages`, `geoRedundancy`, `backupAndRestore`,
  `referenceData`, `upgradeSettings`, `publicNetworkAccess`.
- Read-only (server-set): `dnsName`, `provisioningState`, `milestoneVersion`.

`geoRedundancy` and `backupAndRestore` are optional with no default; the resource provider applies
`Disabled` when either is omitted. `publicNetworkAccess` retains a default of `Enabled`. In
`2026-02-02-preview`, `geoRedundancy` keeps its original optional + default `Enabled`.

## Properties removed

| Property | Was | Replacement |
|---|---|---|
| `autoScaleMaxCapacity` | `int32` | Scale is driven by the patchable `sku.capacity`. |

## Property reshaped

**`addOnPackages`** — changed from an array of objects to an array of enum strings.

- `2026-02-02`: `[ { "name": "Reservoir", "properties": { "state": "Enabled" } }, ... ]`;
  allowed names: `ExternalDataServices`, `PetrelV2`, `Reservoir`, `RockAndFluid`, `Seismic`,
  `Wellbore`, `WellDelivery`.
- `2026-07-21`: `[ "Advanced", "Analytics" ]`; allowed values (extensible enum): `Advanced`,
  `Analytics`.

The element type changes from a package DTO (`{name, properties.state}`) to a plain enum. This is
breaking relative to `2026-02-02-preview`. The shared `.tsp` retains the old object-array field as
`addOnPackagesV1` (emitted as `addOnPackages` in `2026-02-02-preview` via `@renamedFrom`) so the
prior version's contract is preserved. The `AddOnPackage` / `AddOnPackageItemProperties` /
`PackageState` definitions remain in use by `2026-02-02-preview` and drop out of
`2026-07-21-preview` as unreachable types.

## New types

- `BackupAndRestore` enum: `Enabled`, `Disabled`
- `AddOnPackageName` (the `addOnPackages` element type): `Advanced`, `Analytics`
- `Acz` + `AczIdentity`
- PATCH-only models: `SkuUpdate`, `EdsUpdate`, `EdsKeyVaultPropertiesUpdate`,
  `UpgradeSettingsUpdate`, `EncryptionUpdate`, `KeyVaultPropertiesUpdate`

## PrivateEndpointConnectionProxy — nested → flat shape

`2026-02-02-preview` nested `eTag` / `remotePrivateEndpoint` / `status` under `properties`;
`2026-07-21-preview` moves them to the top level (siblings of `id`/`name`/`type`), leaving
`properties` with only the read-only `provisioningState`. This matches stable `2025-12-15` and the
control-plane RP. It is an internal RPaaS DO-NOT-USE resource; two lint rules are suppressed at the
TypeSpec level (`arm-resource-invalid-envelope-property`, `arm-resource-duplicate-property`).
Breaking relative to `2026-02-02-preview`.

- `2026-02-02-preview`: `{ id, name, type, properties: { eTag, remotePrivateEndpoint, status, provisioningState } }`
- `2026-07-21-preview`: `{ id, name, type, eTag, remotePrivateEndpoint, status, properties: { provisioningState } }`

---

## PATCH (Update) surface

PATCH-settable in this version:

| PATCH field | Type | Note |
|---|---|---|
| `sku` | object, `capacity` only | Only `capacity` (int32) is updatable via `SkuUpdate`; `name`/`tier`/`size`/`family` are not patchable. |
| `geoRedundancy` | enum `Enabled`/`Disabled` | |
| `backupAndRestore` | enum `Enabled`/`Disabled` | |
| `acz` | object | |
| `eds` | object (`EdsUpdate`) | PATCH-specific model, no required/default sub-properties |
| `encryption` | object (`EncryptionUpdate`) | PATCH-specific model, no required/default sub-properties |
| `publicNetworkAccess` | enum `Enabled`/`Disabled` | |
| `corsRules` | array | |
| `upgradeSettings` | object (`UpgradeSettingsUpdate`) | PATCH-specific model, no defaults; `autoUpgradeAfterDate` stays read-only |
| `addOnPackages` | enum array | `["Advanced","Analytics"]` shape |

The PATCH body uses PATCH-specific models (`SkuUpdate`, `EdsUpdate`, `UpgradeSettingsUpdate`,
`EncryptionUpdate`) that omit required and default sub-properties, so fields omitted from a JSON
Merge Patch are preserved.

Not patchable:

- Settable only at create: `authAppId`, `dataPartitionNames`, `privateEndpointConnections`,
  `referenceData`, and `sku.name`/`tier`/`size`/`family`.
- Read-only: `dnsName`, `provisioningState`, `milestoneVersion`,
  `upgradeSettings.autoUpgradeAfterDate`.

---

## Constraints, terminology, and other changes

- `sku.capacity`: must be a power of 2 between 2 and 128 (Flex SKU). The `2`–`128` range is enforced
  via `minimum`/`maximum` on `SkuUpdate.capacity`; the power-of-2 rule is server-enforced (not
  expressible in OpenAPI).
- Terminology: legacy names `OAK` and `MEDS` in descriptions were changed to `ADME` (shared `.tsp`,
  so also reflected in `2026-02-02-preview`). The three `ListByOAKInstance` operationIds
  (`PrivateEndpointConnectionProxies` / `PrivateEndpointConnections` / `PrivateLinkResources`) were
  renamed to `ListByADMEInstance` in both versions, with matching example-file renames. The
  `meds.json` input filename and older/stable shipped `oep.json` files are unchanged.
- Acronyms are expanded on first use: `ADME` → "Azure Data Manager for Energy (ADME)", `ACZ` →
  "Analytics Consumption Zone (ACZ)".
- Identity property descriptions use "Azure resource id" (not "ARM resource id").
- `Acz.identity.userAssignedIdentityId` is typed as
  `armResourceIdentifier<[{ type: "Microsoft.ManagedIdentity/userAssignedIdentities" }]>`, emitting
  `format: arm-id` with `x-ms-arm-id-details`.
- `geoRedundancy` doc: omitting the property leaves geo-redundancy not enabled (it defaulted to
  `Enabled` in `2026-02-02-preview`).
- `checkNameAvailability` tag is `Locations` (the interface is named `Locations`; operationId
  unchanged). Applies to both versions.
- `GroupInformationProperties` uses composition (spreads `...PrivateLinkResourceProperties`) rather
  than `extends`. The emitted definition lists `groupId`/`requiredMembers`/`requiredZoneNames`
  inline instead of an `allOf` reference; field visibility and the runtime JSON contract are unchanged.

## Unchanged (carried over)

`publicNetworkAccess`, `privateEndpointConnections`, `corsRules`, `geoRedundancy`, `referenceData`,
`milestoneVersion`, plus the resource envelope (`location`, `tags`, `identity`, `systemData`). The
`sku` read shape remains the full ARM SKU (name/tier/size/family/capacity).
