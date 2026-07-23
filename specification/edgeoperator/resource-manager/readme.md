# edgeoperator

> see https://aka.ms/autorest

This is the AutoRest configuration file for Microsoft.EdgeOperator.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the edgeoperator.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-06-01-preview
```

### Tag: package-2026-06-01-preview

These settings apply only when `--tag=package-2026-06-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-06-01-preview'
input-file:
  - Microsoft.EdgeOperator/BillingConfigurations/preview/2026-06-01-preview/edgeoperator.json
```

### Suppressions

```yaml
suppressions:
  - code: AllProxyResourcesShouldHaveDelete
    where: $.definitions.BillingConfiguration
    reason: BillingConfiguration is a singleton resource that intentionally does not support DELETE. The active configuration can only be replaced via PUT /billingConfigurations/default.
```

---
