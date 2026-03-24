# Azure Resource Notifications

> see https://aka.ms/autorest

This is the AutoRest configuration file for Azure Resource Notifications.

## Getting Started

To build the SDK for Azure Resource Notifications, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> `autorest`

To see additional help and options, run:

> `autorest --help`

## Configuration

### Basic Information

These are the global settings for the Azure Resource Notifications API.

``` yaml
openapi-type: arm
tag: package-2026-03-01-preview
```

### Tag: package-2026-03-01-preview

These settings apply only when `--tag=package-2026-03-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2026-03-01-preview'
input-file:
- Microsoft.ResourceNotifications/preview/2026-03-01-preview/resourcenotifications.json
```

### Tag: package-2025-11-19-preview

These settings apply only when `--tag=package-2025-11-19-preview` is specified on the command line.

``` yaml $(tag) == 'package-2025-11-19-preview'
input-file:
- Microsoft.ResourceNotifications/preview/2025-11-19-preview/resourcenotifications.json
```

## Suppression

``` yaml
suppressions:
  - code: GuidUsage
    from: resourcenotifications.json
    reason: appId is an Azure Active Directory application ID which is a GUID by definition.
    where: $.definitions["Azure.Core.uuid"].format
  - code: TrackedResourcesMustHavePut
    from: resourcenotifications.json
    reason: Namespace is a read-only resource pre-provisioned by the platform. Publishers cannot create or replace namespaces.
    where: $.definitions.Namespace
  - code: TrackedResourcePatchOperation
    from: resourcenotifications.json
    reason: Namespace is a read-only resource pre-provisioned by the platform. Publishers cannot update namespaces.
    where: $.definitions.Namespace
  - code: AllTrackedResourcesMustHaveDelete
    from: resourcenotifications.json
    reason: Namespace is a read-only resource pre-provisioned by the platform. Publishers cannot delete namespaces.
    where: $.definitions.Namespace
  - code: AvoidAdditionalProperties
    from: resourcenotifications.json
    reason: DeploymentConfig.stageDefinition uses Record<Array<string>> for flexible stage-to-region mapping required by SDP.
    where: $.definitions["DeploymentConfig"].properties.stageDefinition
  - code: EnumInsteadOfBoolean
    from: resourcenotifications.json
    reason: managedSdpEnabled is a simple on/off toggle for managed Safe Deployment Practices; an enum adds no value.
    where: $.definitions["DeploymentConfig"].properties.managedSdpEnabled
  - code: EnumInsteadOfBoolean
    from: resourcenotifications.json
    reason: sendToArg is a simple on/off toggle for whether to send data to Azure Resource Graph; an enum adds no value.
    where: $.definitions["AllowedPublisherProperties"].properties.sendToArg
```

## Code Generation

### C#

See configuration in [readme.csharp.md](./readme.csharp.md)

### Python

See configuration in [readme.python.md](./readme.python.md)

### Java

See configuration in [readme.java.md](./readme.java.md)

### JavaScript

See configuration in [readme.nodejs.md](./readme.nodejs.md)

### Go

See configuration in [readme.go.md](./readme.go.md)
