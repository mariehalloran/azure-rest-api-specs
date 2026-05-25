# Azure Migrate

> see https://aka.ms/autorest
> This is the AutoRest configuration file for Azure Migrate - Platform Landing Zones.

---

## Getting Started

To build the SDK for Migrate, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> `autorest`
> To see additional help and options, run:

> `autorest --help`

---

## Configuration

### Basic Information

These are the global settings for the API.

```yaml
openapi-type: arm
tag: package-preview-2026-02
```

### Tag: package-preview-2026-02

These settings apply only when `--tag=package-preview-2026-02` is specified on the command line.

```yaml $(tag) == 'package-preview-2026-02'
input-file:
  - preview/2026-02-01-preview/platformlandingzones.json
suppressions:
  - code: AvoidAdditionalProperties
    reason: AMH feature is widely adopted and requires additionalProperties for these swagger properties.
  - code: DescriptionMustNotBeNodeName
    reason: Migrate Project swagger is not in typespec.
  - code: NestedResourcesMustHaveListOperation
    reason: BillOfMaterials is a singleton ('default') projection of its parent Platform Landing Zone and therefore has no list operation by design.
  - code: ValidFormats
    reason: Bill of Materials monetary amounts use decimal128 to avoid float rounding for currency totals. The autorest emitter renders this as 'format: decimal' which is intentional and reviewed by the API stewardship board.
```
