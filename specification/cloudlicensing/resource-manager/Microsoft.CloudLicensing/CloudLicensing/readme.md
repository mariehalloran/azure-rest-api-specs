# CloudLicensing

> see https://aka.ms/autorest

This is the AutoRest configuration file for CloudLicensing.

## Configuration

### Basic Information

This is a TypeSpec project so we only want the readme to default the default tag and point to the outputted swagger file.
This is used for some tools such as doc generation and swagger apiview generation it isn't used for SDK code gen as we
use the native TypeSpec code generation configured in the tspconfig.yaml file.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2025-07-01-preview
```

### Tag: package-2025-07-01-preview

These settings apply only when `--tag=package-2025-07-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2025-07-01-preview'
input-file:
  - preview/2025-07-01-preview/openapi.json
suppressions:
  - code: GuidUsage
    reason: UUID types are required for tenant IDs, identity IDs, and SKU IDs per ARM reviewer feedback. These are existing GUIDs from Microsoft Entra and the commerce catalog.
```
