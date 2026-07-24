# storage data management

> see https://aka.ms/autorest
This is the AutoRest configuration file for storage data management.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`
To see additional help and options, run:
> `autorest --help`
For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the storage data management.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-06-01
```

### Tag: package-2025-01-01-preview

These settings apply only when `--tag=package-2025-01-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2025-01-01-preview'
input-file:
  - preview/2025-01-01-preview/StorageDataManagementRP.json
suppressions:
  - code: PatchBodyParametersSchema
    from:
      - StorageDataManagementRP.json
    reason: We have used kind property as discriminator to support polymorphic resource and during patch also need to pass discriminator to allow patch on certain polymorphic resource type property.
    where:
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/connectors/{connectorName}"].patch.parameters[5].schema.properties.properties
```

### Tag: package-2025-05-01-preview

These settings apply only when `--tag=package-2025-05-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2025-05-01-preview'
input-file:
  - preview/2025-05-01-preview/StorageDataManagementRP.json
suppressions:
  - code: PatchBodyParametersSchema
    from:
      - StorageDataManagementRP.json
    reason: We have used kind property as discriminator to support polymorphic resource and during patch also need to pass discriminator to allow patch on certain polymorphic resource type property.
    where:
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/connectors/{connectorName}"].patch.parameters[5].schema.properties.properties
```

### Tag: package-2025-07-01-preview

These settings apply only when `--tag=package-2025-07-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2025-07-01-preview'
input-file:
  - preview/2025-07-01-preview/StorageDataManagementRP.json
suppressions:
  - code: PatchBodyParametersSchema
    from:
      - StorageDataManagementRP.json
    reason: We have used kind property as discriminator to support polymorphic resource and during patch also need to pass discriminator to allow patch on certain polymorphic resource type property.
    where:
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/connectors/{connectorName}"].patch.parameters[5].schema.properties.properties
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/dataShares/{dataShareName}"].patch.parameters[5].schema.properties.properties
```

### Tag: package-2026-06-01

These settings apply only when `--tag=package-2026-06-01` is specified on the command line.

```yaml $(tag) == 'package-2026-06-01'
input-file:
  - stable/2026-06-01/StorageDataManagementRP.json
suppressions:
  - code: PatchBodyParametersSchema
    from:
      - StorageDataManagementRP.json
    reason: >
      The Connector PATCH contract is carried forward from prior API versions,
      and the Blob Access Point authentication discriminator is required to
      select the credential shape.
    where:
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/connectors/{connectorName}"].patch.parameters[5].schema.properties.properties
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/blobAccessPointConfigurations/{blobAccessPointConfigurationName}"].patch.parameters[5].schema.properties.properties
  - code: ConsistentPatchProperties
    from:
      - StorageDataManagementRP.json
    reason: >
      The validator does not correlate mutable properties with the concrete
      variants of the discriminated Blob Access Point source model.
    where:
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/blobAccessPointConfigurations/{blobAccessPointConfigurationName}"].patch.parameters[5].schema
  - code: PathForResourceAction
    from:
      - StorageDataManagementRP.json
    reason: >
      proposedconnectiontest validates a configuration before a Blob Access
      Point configuration resource exists, so it is intentionally a collection
      action.
    where:
      - $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}/blobAccessPointConfigurations/proposedconnectiontest"]
```

## Code Generation

## Swagger to SDK

This section describes what SDK should be generated by the automatic system.
This is not used by Autorest itself.
