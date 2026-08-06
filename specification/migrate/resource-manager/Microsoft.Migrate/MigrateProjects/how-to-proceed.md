# How to proceed with the concrete MigrateProject resource

## Decision

Introduce the concrete tracked `MigrateProject` in a **new preview API version**. Do not change the published `2026-06-01-preview` contract in place.

This project currently has one preview version and no stable version in its TypeSpec version enum ([`ApiVersions.tsp`](./ApiVersions.tsp#L8-L14)). Microsoft.Migrate also treats the current `MigrateProject` as a virtual route parent owned by an existing GA API, rather than as a resource implemented by this service ([`MigrateProject.tsp`](./MigrateProjects/MigrateProject.tsp#L7-L18)).

The official TypeSpec guidance for a preview following another preview, when no stable API version exists, is to advance the active preview version, remove unnecessary versioning decorators, make the new API changes, retain the old OpenAPI only when required, and update the AutoRest configuration: [Adding a Preview Version when the Last Version was Preview](https://azure.github.io/typespec-azure/docs/howtos/versioning/02-preview-after-preview/).

## Why a new preview is required

Changing `MigrateProject` from `@armVirtualResource` to `TrackedResource<MigrateProjectProperties>` introduces the standard tracked-resource envelope, including required `location`. Making that change in the existing `2026-06-01-preview` Swagger is an in-place contract change and can trigger OAD rule 1034, `AddedRequiredProperty`.

The repository classifies `AddedRequiredProperty` as an error in an ordinary cross-version comparison ([`oad-rule-map.ts`](/eng/tools/openapi-diff-runner/src/utils/oad-rule-map.ts#L28)). However, the breaking-change runner explicitly demotes errors to warnings when a cross-version comparison is against a previous preview ([`apply-rules.ts`](/eng/tools/openapi-diff-runner/src/utils/apply-rules.ts#L76-L95)). The runner checks a new Swagger against preceding stable and preview versions separately ([`detect-breaking-change.ts`](/eng/tools/openapi-diff-runner/src/detect-breaking-change.ts#L207-L230)).

Therefore, under the current repository version set:

- The existing `2026-06-01-preview` Swagger must remain unchanged, so the same-version check has no published-contract modification to report.
- The new preview can be compared with `2026-06-01-preview` by the cross-version check.
- Rule 1034 and other differences may still appear, but errors found only against the previous preview are reduced to warnings.
- A clean report is not guaranteed; the expected result is **non-blocking warnings**, not necessarily no findings.
- If a preceding stable Swagger becomes part of this service's comparison set, incompatibilities with that stable version remain blocking.

Breaking-change checks cannot be permanently suppressed. A PR-level approval requires the Breaking Change Board, as documented in the repository's [suppression policy](/documentation/design/specs-pr-guides/pr-suppressions.md#L57-L58).

## Recommended implementation

### 1. Select the new preview version

Use the release-approved date rather than inventing one solely to satisfy validation. For example, if approved, add `2026-10-01-preview` as the active preview.

Because this project has no stable version, follow the single-active-preview guidance:

1. Replace `v2026_06_01_preview` in `ApiVersions` with the new preview member and value.
2. Keep `@previewVersion` and the appropriate ARM common-types version on that member.
3. Remove versioning decorators that only say the existing MigratePlans surface was added in `2026-06-01-preview`; those decorators are unnecessary after advancing the only active TypeSpec preview.
4. Do not delete or edit the checked-in `preview/2026-06-01-preview/migrateProjects.json`.

The current MigratePlan operations are individually decorated with `@added(ApiVersions.v2026_06_01_preview)` ([`routes.tsp`](./MigratePlans/routes.tsp#L12-L32)); these are the decorators to remove when advancing the single active preview.

### 2. Convert the existing parent symbol into the resource

Update the existing `MigrateProject` model rather than introducing a second public resource model with the same route:

```typespec
model MigrateProject is TrackedResource<MigrateProjectProperties> {
  @key("projectName")
  @segment("migrateProjects")
  @pattern("^[A-Za-z0-9](?:[A-Za-z0-9-]{0,62}[A-Za-z0-9])?$")
  name: string;
}
```

Define the complete `MigrateProjectProperties` bag using the canonical service contract. Do not infer that contract from the virtual placeholder. The placeholder currently defines only route identity and does not establish the concrete resource payload.

Using the existing symbol preserves `@parentResource(MigrateProject)` on `MigratePlan`. This avoids trying to version `@parentResource`, which accepts a model directly and has no version argument: [TypeSpec REST `@parentResource` reference](https://typespec.io/docs/libraries/rest/reference/decorators/#@parentresource).

### 3. Add the complete tracked-resource lifecycle

A tracked ARM resource requires the full lifecycle in the new preview:

- Point GET
- PUT create or replace
- PATCH update
- DELETE
- List by resource group
- List by subscription

Use the ARM resource operation templates and choose synchronous or asynchronous variants according to the service's actual behavior. The repository's tracked-resource guidance lists the required operations and template pattern ([tracked-resource lifecycle guidance](/.github/skills/azure-api-review/references/tracked-resource-lifecycle.md#L19-L38)).

The PATCH model must correctly represent writable fields, including tags at minimum. GET, PUT, PATCH, and LIST must return a consistent resource schema.

### 4. Preserve the old Swagger and publish the new one

The emitter already writes versioned output to `preview/<version>/migrateProjects.json` through its `{version-status}/{version}` output pattern ([`tspconfig.yaml`](./tspconfig.yaml#L13-L21)). Compilation should produce a new file such as:

```text
preview/<new-preview-version>/migrateProjects.json
```

The existing file must remain byte-for-byte unchanged:

```text
preview/2026-06-01-preview/migrateProjects.json
```

Update [`readme.md`](./readme.md#L22-L34) so the new preview tag is the default/current package tag. Retain a tag for `2026-06-01-preview` if consumers must still be able to generate from that published contract.

### 5. Update examples

Move or copy the applicable examples into the new preview version folder and update every `api-version` value. Add examples for all new `MigrateProject` operations. Keep MigratePlan examples aligned with the new active preview.

### 6. Validate before opening the PR

Run the project compiler and repository-supported TypeSpec validation, then verify both generated contracts:

```bash
cd specification/migrate/resource-manager/Microsoft.Migrate/MigrateProjects
npx tsp compile .
```

Validation must establish all of the following:

- `preview/2026-06-01-preview/migrateProjects.json` has no diff from the base branch.
- The new preview Swagger contains the full tracked `MigrateProject` schema and lifecycle.
- Existing MigratePlan paths, methods, operation IDs, and response shapes remain intentional.
- MigratePlan routes still use the `migrateProjects/{projectName}` parent scope.
- TypeSpec validation and ARM linting pass.
- Cross-version findings are reviewed even when they are warning-only.
- Generated SDK/APIView changes are reviewed separately from REST breaking-change validation.

## External GA compatibility gate

The source states that `MigrateProject` is owned by a Microsoft.Migrate GA API ([`MigrateProject.tsp`](./MigrateProjects/MigrateProject.tsp#L7-L8)). Before implementing the concrete model, obtain that canonical GA Swagger or service contract and align at least:

- Resource path and project-name constraints
- Required and optional properties
- Property visibility and mutability
- Provisioning state
- PUT, PATCH, GET, DELETE, and LIST behavior
- Operation IDs, response codes, and LRO behavior
- Error responses and common-types version

A new preview prevents an in-place edit of `2026-06-01-preview`; it does not authorize divergence from an existing stable service contract. If a stable Swagger is discovered or added to the comparison set, validate the new preview against it before proceeding.

## Expected PR classification

For the future concrete-resource PR, select **New API version for an existing resource provider** in the control-plane PR template. Do not classify it as an update to the existing version. State explicitly that the PR:

- Adds a new preview API version.
- Introduces the concrete tracked `MigrateProject` and its full lifecycle.
- Preserves the published `2026-06-01-preview` Swagger.
- Retains the existing MigratePlan route hierarchy.
- May show non-blocking cross-version warnings against the previous preview.
