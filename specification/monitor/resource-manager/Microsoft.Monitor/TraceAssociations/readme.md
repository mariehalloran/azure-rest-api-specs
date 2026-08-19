# Microsoft.Monitor - Trace Associations

> see https://aka.ms/autorest

This is the AutoRest configuration file for Trace Associations.

## Getting Started

To build the SDKs for Trace Associations, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the Trace Associations.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-01-01-preview

suppressions:
  - code: OperationsAPIImplementation
    reason: Operations API for the Microsoft.Monitor namespace is defined in sibling Microsoft.Monitor specs (specification/monitoringservice/resource-manager/Microsoft.Monitor/Accounts and PipelineGroups).
```

### Tag: package-2026-01-01-preview

These settings apply only when `--tag=package-2026-01-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-01-01-preview'
input-file:
  - preview/2026-01-01-preview/traceAssociations.json
```
