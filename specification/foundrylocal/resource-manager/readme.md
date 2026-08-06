# foundrylocal

> see https://aka.ms/autorest

This is the AutoRest configuration file for foundrylocal.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the foundrylocal.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-09-01-preview
```

### Suppression

```yaml
directive:
  - suppress: AvoidAdditionalProperties
    from: openapi.json
    where: $.definitions.VllmConfig.properties.preferences
    reason: >-
      vLLM engine arguments (keys vary by vLLM version). Pure pass-through;
      RP performs no validation, map is forwarded verbatim to the vLLM
      process which owns the schema.
  - suppress: AvoidAdditionalProperties
    from: openapi.json
    where: $.definitions.ModelDeploymentProperties.properties.nodeSelector
    reason: >-
      Kubernetes node selector key-value pairs (defined by cluster
      admin). Pure pass-through; RP performs no validation.
  - suppress: AvoidAdditionalProperties
    from: openapi.json
    where: $.definitions.ModelDeploymentUpdateProperties.properties.nodeSelector
    reason: >-
      Kubernetes node selector key-value pairs (defined by cluster
      admin). Pure pass-through; RP performs no validation.
  - suppress: XMSSecretInResponse
    from: openapi.json
    reason: >-
      usernameKey and passwordKey on SecretReference are NAMES of keys
      within the referenced Kubernetes Secret (e.g. "username", "password"),
      not secret credential values. The actual credentials live inside the
      Secret object on the cluster. The property names contain "Key" which
      triggers a false positive on this rule.
```

### Tag: package-2026-09-01-preview

These settings apply only when `--tag=package-2026-09-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-09-01-preview'
input-file:
  - Microsoft.FoundryLocal/foundrylocal/preview/2026-09-01-preview/openapi.json
```

### Tag: package-2026-05-01-preview

These settings apply only when `--tag=package-2026-05-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-05-01-preview'
input-file:
  - Microsoft.FoundryLocal/foundrylocal/preview/2026-05-01-preview/openapi.json
```
