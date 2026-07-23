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
```

## Suppression

```yaml
directive:
  - suppress: MissingSegmentsInNestedResourceListOperation
    from: platformlandingzones.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{projectName}/platformLandingZones"].get
    reason: The generated list-by-parent route contains the complete migrateProjects parent path and the platformLandingZones child segment.
```
