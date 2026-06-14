# Microsoft.Copilot

> see https://aka.ms/autorest

This is the AutoRest configuration file for Microsoft.Copilot.

---

## Configuration

### Basic Information

These are the global settings for the Microsoft.Copilot API.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-preview-2026-05
```

### Tag: package-preview-2026-05

These settings apply only when `--tag=package-preview-2026-05` is specified on the command line.

```yaml $(tag) == 'package-preview-2026-05'
input-file:
  - preview/2026-05-01-preview/copilotmanagement.json
```
