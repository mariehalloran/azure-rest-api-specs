# MEDS

> see https://aka.ms/autorest

This is the AutoRest configuration file for MEDS.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the MEDS.

``` yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-07-21-preview
```
### Tag: package-2025-08-06

These settings apply only when `--tag=package-2025-08-06` is specified on the command line.

```yaml $(tag) == 'package-2025-08-06'
input-file:
  - stable/2025-08-06/oep.json
```

### Tag: package-2024-05-21

These settings apply only when `--tag=package-2024-05-21` is specified on the command line.

```yaml $(tag) == 'package-2024-05-21'
input-file:
  - stable/2024-05-21/oep.json
```

### Tag: package-2024-02-09-preview

These settings apply only when `--tag=package-2024-02-09-preview` is specified on the command line.

```yaml $(tag) == 'package-2024-02-09-preview'
input-file:
  - preview/2024-02-09-preview/oep.json
```

### Tag: package-2023-11

These settings apply only when `--tag=package-2023-11-12` is specified on the command line.

``` yaml $(tag) == 'package-2023-11-12'
input-file:
  - stable/2023-11-12/oep.json
```

### Tag: package-2023-06

These settings apply only when `--tag=package-2023-06` is specified on the command line.

``` yaml $(tag) == 'package-2023-06'
input-file:
  - stable/2023-06-12/oep.json
```

### Tag: package-2021-06-01-preview

These settings apply only when `--tag=package-2021-06-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2021-06-01-preview'
input-file:
  - preview/2021-06-01-preview/oep.json
```

### Tag: package-2022-04-04-preview

These settings apply only when `--tag=package-2022-04-04-preview` is specified on the command line.

``` yaml $(tag) == 'package-2022-04-04-preview'
input-file:
  - preview/2022-04-04-preview/oep.json
```

### Tag: package-2022-07-21-preview

These settings apply only when `--tag=package-2022-07-21-preview` is specified on the command line.

``` yaml $(tag) == 'package-2022-07-21-preview'
input-file:
  - preview/2022-07-21-preview/oep.json
```

### Tag: package-2022-12-01-preview

These settings apply only when `--tag=package-2022-12-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2022-12-01-preview'
input-file:
  - preview/2022-12-01-preview/meds.json
```

### Tag: package-2023-02-21-preview

These settings apply only when `--tag=package-2023-02-21-preview` is specified on the command line.

``` yaml $(tag) == 'package-2023-02-21-preview'
input-file:
  - preview/2023-02-21-preview/oep.json
```

### Tag: package-2023-10-01-preview

These settings apply only when `--tag=package-2023-10-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2023-10-01-preview'
input-file:
  - preview/2023-10-01-preview/oep.json
```

### Tag: package-2025-09-22-preview

These settings apply only when `--tag=package-2025-09-22-preview` is specified on the command line.

```yaml $(tag) == 'package-2025-09-22-preview'
input-file:
  - preview/2025-09-22-preview/oep.json
```

### Tag: package-2025-11-11

These settings apply only when `--tag=package-2025-11-11` is specified on the command line.

```yaml $(tag) == 'package-2025-11-11'
input-file:
  - stable/2025-11-11/oep.json
```

### Tag: package-2025-12-15

These settings apply only when `--tag=package-2025-12-15` is specified on the command line.

```yaml $(tag) == 'package-2025-12-15'
input-file:
  - stable/2025-12-15/oep.json
```

### Tag: package-2026-07-21-preview

These settings apply only when `--tag=package-2026-07-21-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-07-21-preview'
input-file:
  - preview/2026-07-21-preview/oep.json
suppressions:
  - code: PatchBodyParametersSchema
    from: oep.json
    reason: "The EnergyService PATCH body reuses shared resource models (Encryption, Eds, UpgradeSettings) and the ManagedServiceIdentity common type, which carry required and default sub-properties by design (e.g. Encryption.keyVaultProperties.keyName, Eds.keyVaultProperties, ManagedServiceIdentity.type, UpgradeSettings.upgradePolicy/readyForUpgrade defaults). This preserves the established PATCH wire contract from prior API versions for this brownfield RP; omitted fields are not reset server-side. Applied file-wide because the affected properties span multiple shared model definitions and `where:` scoping is not reliably honored by LintDiff's `suppressions:` block."
  - code: BodyTopLevelProperties
    from: oep.json
    reason: "PrivateEndpointConnectionProxy is an internal RPaaS-only DO NOT USE resource consumed by the Network Resource Provider. Its eTag / remotePrivateEndpoint / status are intentionally top-level (not under `properties`) to match the control-plane RP and the stable 2025-12-15 contract, correcting the nested defect that shipped in 2026-02-02-preview. This resource was historically suppressed for the same rule via the legacy directive block that references the pre-migration file name."
  - code: LroLocationHeader
    from: oep.json
    reason: "The PATCH on EnergyService uses an existing async pattern that returns Azure-AsyncOperation and Retry-After headers but no Location header. This wire contract predates the rule and is already suppressed at the TypeSpec level for the same operation. Note: scoping via `where:` was attempted but is not honored by LintDiff's `suppressions:` block — file-wide is required for this rule code."
  - code: ProvisioningStateSpecifiedForLROPut
    from: oep.json
    where: '$.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OpenEnergyPlatform/energyServices/{resourceName}/privateEndpointConnectionProxies/{privateEndpointConnectionProxyId}"].put'
    reason: "PrivateEndpointConnectionProxies is an internal RPaaS-only DO NOT USE API consumed by the Network Resource Provider. Its 201 response intentionally omits provisioningState from the resource properties. Already suppressed at the TypeSpec level on the same model."
```

### Tag: package-2026-02-02-preview

These settings apply only when `--tag=package-2026-02-02-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-02-02-preview'
input-file:
  - preview/2026-02-02-preview/oep.json
suppressions:
  - code: LroLocationHeader
    from: oep.json
    reason: "The PATCH on EnergyService uses an existing async pattern that returns Azure-AsyncOperation and Retry-After headers but no Location header. This wire contract predates the rule and is already suppressed at the TypeSpec level for the same operation. Note: scoping via `where:` was attempted but is not honored by LintDiff's `suppressions:` block — file-wide is required for this rule code."
  - code: ProvisioningStateSpecifiedForLROPut
    from: oep.json
    where: '$.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OpenEnergyPlatform/energyServices/{resourceName}/privateEndpointConnectionProxies/{privateEndpointConnectionProxyId}"].put'
    reason: "PrivateEndpointConnectionProxies is an internal RPaaS-only DO NOT USE API consumed by the Network Resource Provider. Its 201 response intentionally omits provisioningState from the resource properties. Already suppressed at the TypeSpec level on the same model."
```

## Suppression

``` yaml
directive:
  - suppress: RequiredPropertiesMissingInResourceModel
    from: meds.json
    where: $.definitions.DataPartitionsList
    reason: DataPartitionsList is a proxy resource
  - suppress: BodyTopLevelProperties
    from: meds.json
    where: $.definitions.DataPartitionsList.properties
    reason: DataPartitionsList is a proxy resource
  - suppress: BodyTopLevelProperties
    from: meds.json
    where: $.definitions.PrivateEndpointConnectionProxy.properties
    reason: Internal NRP resource, all properties are top level properties
```

---

# Code Generation

## Swagger to SDK

This section describes what SDK should be generated by the automatic system.
This is not used by Autorest itself.

``` yaml $(swagger-to-sdk)
swagger-to-sdk:
  - repo: azure-sdk-for-python-track2
  - repo: azure-sdk-for-java
  - repo: azure-sdk-for-js
  - repo: azure-cli-extensions
```

## Az

See configuration in [readme.az.md](./readme.az.md)

## Go

See configuration in [readme.go.md](./readme.go.md)

## Python

See configuration in [readme.python.md](./readme.python.md)

## TypeScript

See configuration in [readme.typescript.md](./readme.typescript.md)

## CSharp

See configuration in [readme.csharp.md](./readme.csharp.md)
