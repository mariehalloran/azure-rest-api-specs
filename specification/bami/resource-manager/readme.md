# BAMI (Billing Account Management for Internal)

> see https://aka.ms/autorest

This is the AutoRest configuration file for the Microsoft.Bami resource provider.

---

## Getting Started

To build the SDK for BAMI, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> `autorest`

To see additional help and options, run:

> `autorest --help`

---

## Configuration

### Basic Information

These are the global settings for the BAMI API.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-preview-2026-06-01
```

### Tag: package-preview-2026-06-01

These settings apply only when `--tag=package-preview-2026-06-01` is specified on the command line.

```yaml $(tag) == 'package-preview-2026-06-01'
input-file:
  - Microsoft.Bami/preview/2026-06-01-preview/bami.json
```

### Suppressions

```yaml
directive:
  - suppress: AvoidAdditionalProperties
    from: bami.json
    where:
      - $.definitions.EnvironmentApplicationConsents
      - $.definitions.TenantApplicationConsents
    reason: >-
      AppConsentContext.appsToConsent is an inherently dynamic map (Azure environment name -> tenant ID ->
      first-party application IDs) that mirrors the wire contract the BAMI service serializes. It is modeled in
      TypeSpec as named Record-based definitions (EnvironmentApplicationConsents, TenantApplicationConsents) so
      SDKs get named types; the resulting additionalProperties usage is required and intentional.
```

