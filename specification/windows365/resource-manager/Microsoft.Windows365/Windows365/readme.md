# Windows 365

> see https://aka.ms/autorest

This is the AutoRest configuration file for the Windows 365 resource provider.

## Getting Started

To build the SDKs, install AutoRest via `npm` (`npm install -g autorest`) and run:

> `autorest readme.md`

For additional help and options, run:

> `autorest --help`

---

## Configuration

### Basic Information

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-09-01-preview
```

### Tag: package-2026-09-01-preview

These settings apply only when `--tag=package-2026-09-01-preview` is specified.

```yaml $(tag) == 'package-2026-09-01-preview'
input-file:
  - preview/2026-09-01-preview/windows365.json
```

---

# Code Generation

## Swagger to SDK

```yaml $(swagger-to-sdk)
swagger-to-sdk:
  - repo: azure-resource-manager-schemas
  - repo: azure-cli-extensions
```
