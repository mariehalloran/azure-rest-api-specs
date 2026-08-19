# Security Base Platform

> see https://aka.ms/autorest

This is the AutoRest configuration file for the Microsoft.SecurityBasePlatform ARM API.

## Configuration

```yaml
title: Security Base Platform
description: Microsoft.SecurityBasePlatform Resource Provider API
openapi-type: arm
openapi-subtype: rpaas
tag: package-preview-2025-03-01
```

### Tag: package-preview-2025-03-01

These settings apply only when `--tag=package-preview-2025-03-01` is specified on the command line.

```yaml $(tag) == 'package-preview-2025-03-01'
input-file:
  - preview/2025-03-01-preview/securitybaseplatform.json
```

## Suppressions

```yaml
directive:
  - suppress: AvoidAdditionalProperties
    from: securitybaseplatform.json
    where: $.definitions.StringMap
    reason: >
      StringMap models user-defined Kubernetes labels and annotations whose keys
      are not knowable in advance, so an open string-to-string map is required.
```
