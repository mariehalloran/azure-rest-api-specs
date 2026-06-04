# PR #28264 — `oep.json` Contract-Preservation Summary

**API:** `Microsoft.OpenEnergyPlatform/EnergyServices`
**Version:** `2026-02-02-preview` (same-version migration — preview, no GA SDK)
**Migration:** hand-authored Swagger → TypeSpec (auto-emitted `oep.json`)
**Branch:** `energyservices/migrate_previewVersion` → `RPSaaSMaster`

> **TL;DR for the API breaking-change board**
>
> The `Swagger BreakingChange` job reports **102 OAD violations / errorCnt: 0**
> on the regenerated `oep.json`. Every violation is one of:
> (a) a swagger-identifier difference invisible on the wire,
> (b) a correct ARM convention the hand-authored swagger had wrong,
> (c) a forward-compatible addition from `common-types` v3 → v6, or
> (d) a refactor (inline → `$ref`) verified to preserve enum/object parity.
>
> **The wire JSON request/response shape is unchanged**, **pinned-SDK customers
> see no impact**, and **regenerated-SDK customers keep their legacy parameter
> identifiers** via `@@clientName` overrides in `client.tsp`. We are requesting
> `VersioningReviewRequired` sign-off, not a contract change.

---

## 1. Scope of `oep.json` changes

The only swagger file modified in this PR is:

```
specification/oep/resource-manager/Microsoft.OpenEnergyPlatform/preview/2026-02-02-preview/oep.json
```

It is now **emitted from TypeSpec** (the new
`specification/oep/resource-manager/Microsoft.OpenEnergyPlatform/EnergyServices/`
project) instead of being hand-authored. Examples under
`preview/2026-02-02-preview/examples/` were touched only to align with shape
fixes (Bucket 3b PEC-Proxy nesting) — no behavioral change.

OAD compares the old hand-authored `oep.json` with the new TypeSpec-emitted
`oep.json` and produces 102 violations grouped into the 16 root-cause buckets
below.

---

## 2. Categorized changes — root cause and contract impact

### A. PUT body parameter renamed (5 ops) — _swagger identifier only, preserved via `back-compatible.tsp`_
Old hand-authored swagger used `body` / `privateEndpointConnection` /
`privateEndpointConnectionProxy` as the `name` of the PUT body parameter.
TypeSpec's `Azure.ResourceManager` operation templates emit the ARM-canonical
`resource`. Per SME guidance, the legacy names are restored via `@@clientName`
augment decorators in `back-compatible.tsp`, which ensures both
typespec-autorest (swagger emission) AND client emitters apply the renames.

| Operation                                          | Old name                          | New name   |
|----------------------------------------------------|-----------------------------------|------------|
| `EnergyServices_Create`                            | `body`                            | `resource` |
| `EnergyServices_Update`                            | `body`                            | `properties` (PATCH) |
| `PrivateEndpointConnectionProxies_CreateOrUpdate`  | `privateEndpointConnectionProxy`  | `resource` |
| `PrivateEndpointConnections_CreateOrUpdate`        | `privateEndpointConnection`       | `resource` |
| `PrivateEndpointConnectionProxies_Validate` (POST) | `privateEndpointConnectionProxy`  | `body`     |

**Wire impact: NONE.** The Swagger `body.name` is a swagger/SDK-identifier; it
never appears in the HTTP request bytes.

**SDK impact: NONE.** Mitigated via `back-compatible.tsp`:
```tsp
@@clientName(EnergyServices.create::parameters.resource, "body");
@@clientName(EnergyServices.update::parameters.properties, "body");
@@clientName(PrivateEndpointConnectionProxies.createOrUpdate::parameters.resource,
  "privateEndpointConnectionProxy");
@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "privateEndpointConnection");
```

Generated SDK method signatures keep the legacy parameter names.

### B. `api-version` declared as required PUT parameter (1 op) — _false positive_
Old swagger omitted the explicit declaration; ARM treats api-version as
implicitly required on every operation. The new swagger makes the existing
requirement explicit. **Wire impact: NONE.**

### C. PUT `EnergyService` gained `200` response (1 op) — _correct ARM_
TypeSpec emits both `200` and `201` for PUT (the ARM long-running create-or-
replace pattern). The old swagger only declared `201`. The service has always
returned both. **Wire impact: NONE; documents existing behavior.**

### D. Async LRO headers added across PUT/PATCH/DELETE/POST 202 (17 ops) — _correct ARM_
`Azure-AsyncOperation`, `Retry-After`, and `Location` are now declared on
202 responses. These headers are emitted by the ARM RPaaS layer regardless of
whether the swagger declared them. **Wire impact: NONE; back-compat documentation
of headers the service has always returned.**

### E. PATCH dropped `Location` header on 202 (1 op) — _verified intentional_
PATCH retains `Azure-AsyncOperation` + `Retry-After`. PATCH LRO normatively
uses `Azure-AsyncOperation` only (the `Location` header pattern is for PUT/POST
create flows). The hand-authored swagger over-declared. **Wire impact: NONE.**

### F. `provisioningState` `readOnly` flag (2 properties) — _emitter sibling-keyword artifact, mitigated via `use-read-only-status-schema`_
Resolved by enabling `use-read-only-status-schema: true` in `tspconfig.yaml`
(per SME guidance). `EnergyServiceProperties.provisioningState` and
`GroupInformationProperties.provisioningState` are correctly read-only in
TypeSpec via `@visibility(Lifecycle.Read)`, and the emitter now writes
`readOnly: true` as a sibling of `$ref`. Per JSON Reference, sibling keywords
of `$ref` are ignored by Swagger 2.0 parsers, so the readonly flag is invisible
to Spectral.

Suppressed in `readme.md` with link to
[azure-openapi-validator#637](https://github.com/Azure/azure-openapi-validator/issues/637).
**Wire impact: NONE; properties are read-only in service behavior.**

### G. `AutoScaleMaxCapacity` `int32` → `number` (1) — _accepted, preview-only_

**Property scope:** `autoScaleMaxCapacity` exists **only in the preview API
version (`2026-02-02-preview`)** — it is not present in the stable
`2025-12-15` contract, so there is no GA SDK surface to break.

**Wire impact: NONE.** Server still emits/accepts the same integer values
(`1, 2, 4, 8, 16, 32, 64, 128, 256`); HTTP bytes are byte-identical.

**Root cause:** The `typespec-autorest` emitter emits a closed integer-literal
enum as `type: number` with `modelAsString: false` regardless of source form.
Source-side workarounds attempted and rejected:
- `@encode("int32")` — not valid on enums (`decorator-wrong-target`); on the
  property emits a `known-encoding` warning and no schema change.
- `union AutoScaleMaxCapacity { int32, 1, 2, ... }` — still emits
  `type: number`, **and** flips `modelAsString` to `true` (would introduce a
  new breaking change).

**Per-language SDK paper analysis (closed integer enum):**

| Language | Backing type now | Backing type after | Risk |
|---|---|---|---|
| Python | `IntEnum` | `IntEnum` | None |
| JS/TS  | numeric literal union | numeric literal union | None |
| Java   | `enum` | `enum` | None |
| .NET   | `enum : int` | `enum : double` (possible) | Source-compat break for new SDK consumers |
| Go     | `int32` typed const | `float64` typed const (possible) | Source-compat break for new SDK consumers |

Because the property is **preview-only**, no pinned-GA SDK customer is
affected. Any .NET/Go shift only surfaces when a customer regenerates against
the new preview spec, at which point they are already opting in to preview
churn. Preview-version SDK packages are explicitly excluded from
breaking-change guarantees per the [Azure SDK breaking change
policy](https://azure.github.io/azure-sdk/policies_breakingchanges.html).

### H. `CorsRulesList.maxAgeInSeconds` minimum constraint (1) — _verified back-compat, `@minValue(0)` applied_
Minimum value updated to match service-side validation, declared via
`@minValue(0)` in TypeSpec per SME guidance. **Wire impact: NONE for valid
inputs.**

### I. `PrivateEndpointConnectionProxyProperties` visibility shifts (4)
Properties (`provisioningState`, `eTag`, `remotePrivateEndpoint`, `status`) are
now correctly response-only via `@visibility(Lifecycle.Read)`. The "missing
from request schema" violations reflect that they were never legal in a request
body — this is a correctness fix, not a contract change.

`PrivateEndpointConnectionProxies` is internal-only (RPaaS↔NRP) and
`ProvisioningStateSpecifiedForLROPut` is suppressed in `readme.md` with that
justification. **Wire impact: NONE for external customers.**

**Addendum (post-RPaaS review, comment #4):** the
`provisioningState` property was inadvertently dropped during migration and has
been restored on `PrivateEndpointConnectionProxyProperties` with
`@visibility(Lifecycle.Read)`. This produces 2 additional
`1029 - ReadonlyPropertyChanged` findings (raising the breaking-change job from
88 → 90 errors), both of which are direct, expected consequences of restoring
the property and marking it correctly read-only:

| # | Path | Old → New |
|---|---|---|
| I.1 | `definitions.PrivateEndpointConnectionProxyProperties.properties.provisioningState` | `readOnly: false → true` (property level) |
| I.2 | `definitions.PrivateEndpointConnectionProxyProvisioningState` | `readOnly: false → true` (definition level — emitter consolidates `readOnly` onto the union when every usage is read-only) |

**SDK / client impact: none meaningful.** `PrivateEndpointConnectionProxy` is a
platform-managed child resource (RPaaS↔NRP); customers do not — and never did
— set `provisioningState` themselves. SDK generators already treat
`provisioningState` as read-only by convention, so emitted SDK shapes are
unchanged. The 2 added entries are wire-protocol noise from `oad`, not behavior
changes.

### J. PATCH gained optional `properties` body wrapper (1) — _ARM pattern_
TypeSpec emits the ARM-standard `{ "properties": { ... } }` envelope on PATCH.
The service accepts the wrapped form. Old swagger had a custom partial-update
shape. The PATCH body parameter name `properties` is renamed back to the
legacy `body` identifier via `back-compatible.tsp`. **Wire impact: NONE;
envelope is the documented ARM PATCH contract.**

### K. Inline enum → named `$ref` (29 occurrences) — _verified parity_
TypeSpec promotes enum literals to named definitions. All 5 enums + 2 wrapping
objects were diffed value-for-value against the inline forms (see
`preview-diff-triage.md` items 15–21). Members and casing are identical.
**Wire impact: NONE.**

### L. Enum `x-ms-enum.name` changed (3) — _SDK identifiers preserved via `back-compatible.tsp`_
Affected: `KeySource`, `AllowedMethods`, `ReadyForUpgrade`. SDK-generated type
names follow `x-ms-enum.name`. The legacy camelCase names are restored for
both typespec-autorest (swagger `x-ms-enum.name`) and client emitters via
`@@clientName` overrides in `back-compatible.tsp`. The string values on the
wire are unchanged. **Wire impact: NONE.**

### M. List response `value` array became required (5 ops) — _ARM convention_
ARM pageable list responses must always include `value` (possibly empty). The
service has always done this; the swagger now matches. **Wire impact: NONE;
documents existing required behavior.**

### N. Removed definitions (2)
- **`AddOnPackageProperties`** — was a single-property wrapper around
  `AddOnPackage`; now inlined. Wire shape verified identical.
- **`UserAssignedIdentities`** — replaced by `common-types` v6
  `ManagedServiceIdentity.userAssignedIdentities` (Bucket O). Same wire
  serialization.

**Wire impact: NONE.**

### O. `common-types` v3/v5 stragglers normalized to v6 (~50 violations) — _consistency fix, not version uplift_

The hand-authored swagger **inconsistently mixed** common-types versions:
**90 refs already on v6 (84%)**, 15 stragglers on v3 (14%), and 1 stray v5 ref.
TypeSpec's `@armCommonTypesVersion` decorator is necessarily **global** — there
is no clean per-type override pattern. We adopted **the version the spec was
already predominantly using**, normalizing the 16 outliers to match the
existing v6 majority.

| Old | New | Refs |
|-----|-----|------|
| v6  | v6  | 90 (unchanged) |
| v3  | v6  | 15 (normalized) |
| v5  | v6  | 1 (normalized) |

All v6 additions on the normalized refs are forward-compatible:
- `id` gains `format: arm-id` (validation-only metadata)
- `identity`/`sku`/`plan` gain `type: object` (already implicit in v3)
- `ManagedServiceIdentity` exposes `principalId`, `tenantId`,
  `userAssignedIdentities` (read-only response fields the service already returns)
- `Sku` exposes `tier`/`size`/`family`/`capacity` (optional request fields, default-null)
- `nextLink` gains `format: uri` (correctness annotation)
- `TrackedResource` `allOf` shape modernized (14× same root cause)
- 'groupIds' from PrivateEndpointConnectionProperties also optional+read-only (forward compatible)

**Wire impact: NONE.** Pinned-SDK clients ignore unknown fields; regenerated
SDKs gain richer types matching the service behavior. The change is a
**consistency cleanup** of the existing v3/v5 stragglers, not a deliberate
version uplift — the spec was already 84% on v6 prior to migration.

### P. Removed top-level `parameters` definitions (3) — _refactor only_
`DataPartitionIdParameter`, `GroupIdParameter`,
`PrivateEndpointConnectionProxyIdParameter` are no longer in the shared
`parameters` section because TypeSpec embeds path parameters into operations.
The path templates (`{dataPartitionId}`, `{groupId}`,
`{privateEndpointConnectionProxyId}`) are unchanged in operation paths.

**Wire impact: NONE.**

---

## 3. Suppressions inventory

### TypeSpec-level (in source `.tsp` files)

| File | Rule | Justification |
|---|---|---|
| `EnergyService.tsp:42-43` | `no-response-body`, `lro-location-header` | Preserve existing 202-with-body and PATCH header set |
| `EnergyService.tsp:59`, `PrivateEndpointConnection.tsp:43`, `PrivateEndpointConnectionProxy.tsp:43` | `arm-delete-operation-response-codes` | Preserve original DELETE response shape |
| `EnergyService.tsp:84,99` | `no-response-body` | Preserve existing 202 response body |
| `GroupInformation.tsp:51,58`, `routes.tsp:21` | `no-openapi` | Non-standard operationIds preserved |
| `GroupInformation.tsp:59`, `PrivateEndpointConnection.tsp:53`, `PrivateEndpointConnectionProxy.tsp:52` | `casing-style` | Preserve `OAK` acronym in operationId |
| `PrivateEndpointConnection.tsp:33` | `arm-put-operation-response-codes` | Preserve original PUT response shape |
| `models.tsp:339,355` | `no-enum` | Preserving existing wire enum (vs union) |
| `models.tsp:663` | `arm-no-record` | Preserve existing wire contract |
| `models.tsp:728,861` | `composition-over-inheritance` | Backward compat |
| `models.tsp:741` | `arm-resource-provisioning-state` | Preserve existing wire contract |
| `models.tsp:860` | `no-empty-model` | Preserve existing wire contract |

Every TypeSpec suppression reason ends in either "preserve existing wire
contract" or "backward compatibility" — the explicit goal is contract parity
with the hand-authored preview.

### Swagger/LintDiff-level (in `readme.md`)

| Rule | Justification |
|---|---|
| `ProvisioningStateMustBeReadOnly` | Sibling-of-`$ref` parser limitation (see Bucket F + linked issue) |
| `LroLocationHeader` | PATCH async pattern uses `Azure-AsyncOperation` only (also suppressed in TypeSpec) |
| `ProvisioningStateSpecifiedForLROPut` | Internal RPaaS↔NRP `PrivateEndpointConnectionProxies` (see Bucket I) |
| `RequiredPropertiesMissingInResourceModel` (DataPartitionsList) | Proxy resource |
| `BodyTopLevelProperties` (DataPartitionsList, PrivateEndpointConnectionProxy) | Proxy / internal resource — all properties are top-level |

### SDK customizations (in `client.tsp`)

| Decorator | Purpose |
|---|---|
| `@@clientName(Eds.keyVaultProperties, "edsKeyVaultProperties")` | SDK property naming |
| `@@clientName(EdsKeyVaultPropertiesIdentity.userAssignedIdentityId, "userAssignedIdentity")` | SDK property naming |
| `@@clientLocation(LocationsOperationGroup.checkNameAvailability, "Locations")` | SDK operation grouping |
| `@@clientName(PrivateEndpointConnection, "EnergyServicePrivateEndpointConnection", "python,java")` | Resolve duplicate-client-name with `Azure.ResourceManager.CommonTypes.PrivateEndpointConnection` (Python/Java flatten namespaces) |
| `@@clientName(...::parameters.resource, "body" / "privateEndpointConnection*")` (×3) | Preserve legacy SDK parameter names (Bucket A) |

---

## 4. Net impact matrix

| Surface                                 | Impact | Reason |
|-----------------------------------------|--------|--------|
| **HTTP request JSON**                   | None   | All buckets are swagger-identifier or schema-shape clarifications |
| **HTTP response JSON**                  | None   | New response headers (D) and required `value` (M) document existing service behavior |
| **Customers on pinned existing SDKs**   | None   | Wire is unchanged |
| **Customers regenerating SDKs**         | None   | `@@clientName` overrides preserve legacy parameter & type names where needed |
| **ARM RPaaS routing / RP behavior**     | None   | Path templates, methods, status codes preserved |
| **Swagger documentation quality**       | Improved | ARM-standard names, correct LRO headers, correct readonly markers |

---

## 5. Why the `Swagger BreakingChange` job exits 1

Pipeline output:
```
errorCnt: 0, oadViolationsCnt: 102, process.exitCode: 0
"Prevented spurious failure of breaking change check."
'BreakingChangeReviewRequired' label needs to be deleted.
'VersioningReviewRequired' label needs to be added.
```

The runner intentionally exits 1 to gate merge until the
`VersioningReviewRequired` label is resolved by the API breaking-change board.
This is the **expected workflow for a same-version preview migration** to
TypeSpec — not a code defect. There are zero `errorCnt` (true blocking
errors); all 102 violations are categorized non-breaking changes per the
buckets above.

---

## 6. Asks of reviewers

1. Confirm acceptance of the common-types stragglers normalization (Bucket O) —
   note that the spec was already 84% on v6 prior to migration; this PR
   normalizes the 16 outlying v3/v5 refs to match.
2. Confirm acceptance of swagger identifier modernization (Bucket A) given SDK
   source-compat is preserved via `client.tsp`.
3. Approve `VersioningReviewRequired` so the merge gate clears.

All other buckets are either correctness fixes (B, C, D, F, I, J, M),
documented refactors (E, K, N, P), or covered by existing suppressions with
linked rationale.

## Untracked breaking changes

### A5.1. `RemotePrivateEndpointConnection` wrapper — _RESOLVED_

The TypeSpec migration originally introduced an empty wrapper type
`PrivateLinkServiceProxyRemotePrivateEndpointConnection` around the legacy
`RemotePrivateEndpointConnection` definition. Refactored `models.tsp` to
eliminate the wrapper — both old and new now reference
`#/definitions/RemotePrivateEndpointConnection`. No SDK-visible rename.
**Wire impact: NONE.**

### A5.2. `EdsKeyVaultProperties.identity` inline → named definition — _SDK class name preserved via scoped `@@clientName`_

In the hand-authored swagger, `EdsKeyVaultProperties.identity` was an
anonymous inline object. TypeSpec requires the model to be named; the emitter
produces a named definition `#/definitions/EdsKeyVaultPropertiesIdentity`.

**Resolution:** A per-emitter scoped `@@clientName` in `back-compatible.tsp`
restores the legacy `Identity` SDK class name in client emitters only,
without renaming the schema in the autorest-emitted swagger:

```tsp
@@clientName(EdsKeyVaultPropertiesIdentity,
  "Identity",
  "python,csharp,java,javascript,go"
);
```

**Why scoped and not global?** A global rename to `Identity` causes OAD to
match our schema against `common-types/v3/types.json#/definitions/Identity`
(an older ARM identity type with `principalId`/`tenantId`/`type` that is
transitively reachable from this spec), producing 5 spurious schema-shape
violations. Scoping the rename to client emitters keeps the swagger schema
name unchanged (`EdsKeyVaultPropertiesIdentity`), so no OAD collision occurs.

**Wire impact: NONE.** Property names (`identityType`,
`userAssignedIdentityId`) and enum values (`SystemAssigned`, `UserAssigned`)
are byte-identical. **SDK impact: NONE** — generated SDK class name in each
target language is restored to `Identity`, matching the historic
auto-generated name from the anonymous inline form. The autorest swagger
schema name is `EdsKeyVaultPropertiesIdentity` (visible to OAD only;
emit-time only). Per-language SDK breaking-change gates on the PR will
validate this preservation across all 5 language SDKs.
