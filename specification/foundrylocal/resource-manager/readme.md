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
tag: package-2026-05-01-preview
```

### Suppression

```yaml
directive:
  - suppress: AvoidAdditionalProperties
    from: openapi.json
    where: $.definitions.ModelDeploymentProperties.properties.configurationSettings
    reason: >-
      K8s Bridge Extensions pattern requires configurationSettings as an opaque
      key-value map (Record<string>). Same pattern used by
      Microsoft.KubernetesConfiguration/extensions.
  - suppress: AvoidAdditionalProperties
    from: openapi.json
    where: $.definitions.ModelDeploymentProperties.properties.configurationProtectedSettings
    reason: >-
      K8s Bridge Extensions pattern requires configurationProtectedSettings as an
      opaque key-value map (Record<string>). Same pattern used by
      Microsoft.KubernetesConfiguration/extensions.
  - suppress: AvoidAdditionalProperties
    from: openapi.json
    where: $.definitions.ModelDeploymentProperties.properties.status
    reason: >-
      K8s Bridge Extensions pattern returns status as an opaque key-value map
      (Record<string>). Same pattern used by
      Microsoft.KubernetesConfiguration/extensions.
```

### Tag: package-2026-05-01-preview

These settings apply only when `--tag=package-2026-05-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-05-01-preview'
input-file:
  - Microsoft.FoundryLocal/foundrylocal/preview/2026-05-01-preview/openapi.json
```
