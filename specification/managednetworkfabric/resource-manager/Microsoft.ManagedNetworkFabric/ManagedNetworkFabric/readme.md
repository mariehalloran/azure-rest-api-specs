# ManagedNetworkFabric

> see https://aka.ms/autorest

This is the AutoRest configuration file for Managed Network Fabric.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the Managed Network Fabric.

```yaml
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-07-15-preview
```

### Tag: package-2026-07-15-preview

These settings apply only when `--tag=package-2026-07-15-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-07-15-preview'
input-file:
  - preview/2026-07-15-preview/managednetworkfabric.json
suppressions:
  - code: AvoidAnonymousTypes
    where: $.definitions
    reason: This error is caused by typespec inbuilt managed identity model.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    where: $.paths
    reason: Older API versions (e.g., 2024-02-15-preview, 2023-06-15) contain deprecated APIs that have been removed and are not listed in the default tag.
  - code: GuidUsage
    where: $.definitions.Azure.Core.uuid
    reason: GUIDs are required for validationId and correlationId fields as per ARM API review guidance.
  - code: AvoidAdditionalProperties
    where: $.definitions.DeviceCommand.properties.validationRules
    reason: validationRules is intentionally a free-form JSON object so callers can define their own arbitrary validation rules to evaluate device command output.
```

### Tag: package-2026-01-15-preview

These settings apply only when `--tag=package-2026-01-15-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-01-15-preview'
input-file:
  - preview/2026-01-15-preview/managednetworkfabric.json
suppressions:
  - code: AvoidAnonymousTypes
    where: $.definitions
    reason: This error is caused by typespec inbuilt managed identity model.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    where: $.paths
    reason: Previous API versions not included in default tag as they are documented in their own tags
```

### Tag: package-2025-07-15

These settings apply only when `--tag=package-2025-07-15` is specified on the command line.

```yaml $(tag) == 'package-2025-07-15'
input-file:
  - stable/2025-07-15/managednetworkfabric.json
suppressions:
  - code: AvoidAnonymousTypes
    where: $.definitions
    reason: This error is caused by typespec inbuilt managed identity model.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    where: $.paths
    reason: Previous API versions not included in default tag as they are documented in their own tags
```

### Tag: package-2024-06-15-preview

These settings apply only when `--tag=package-2024-06-15-preview` is specified on the command line.

```yaml $(tag) == 'package-2024-06-15-preview'
input-file:
  - preview/2024-06-15-preview/managednetworkfabric.json
suppressions:
  - code: AvoidAnonymousTypes
    where: $.definitions
    reason: This error is caused by typespec inbuilt managed identity model.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    where: $.paths
    reason: Previous API versions not included in default tag as they are documented in their own tags
```

### Tag: package-2024-02-15-preview

These settings apply only when `--tag=package-2024-02-15-preview` is specified on the command line.

```yaml $(tag) == 'package-2024-02-15-preview'
input-file:
  - preview/2024-02-15-preview/managednetworkfabric.json
```

### Tag: package-2023-06-15

These settings apply only when `--tag=package-2023-06-15` is specified on the command line.

```yaml $(tag) == 'package-2023-06-15'
input-file:
  - stable/2023-06-15/AccessControlLists.json
  - stable/2023-06-15/InternetGateways.json
  - stable/2023-06-15/InternetGatewayRules.json
  - stable/2023-06-15/IpCommunities.json
  - stable/2023-06-15/IpExtendedCommunities.json
  - stable/2023-06-15/IpPrefixes.json
  - stable/2023-06-15/L2IsolationDomains.json
  - stable/2023-06-15/L3IsolationDomains.json
  - stable/2023-06-15/NeighborGroups.json
  - stable/2023-06-15/NetworkDeviceSkus.json
  - stable/2023-06-15/NetworkDevices.json
  - stable/2023-06-15/NetworkFabricControllers.json
  - stable/2023-06-15/NetworkFabricSkus.json
  - stable/2023-06-15/NetworkFabrics.json
  - stable/2023-06-15/NetworkPacketBrokers.json
  - stable/2023-06-15/NetworkRacks.json
  - stable/2023-06-15/NetworkTapRules.json
  - stable/2023-06-15/NetworkTaps.json
  - stable/2023-06-15/Operations.json
  - stable/2023-06-15/RoutePolicies.json
  - stable/2023-06-15/common.json
```

### Tag: package-2023-02-01-preview

These settings apply only when `--tag=package-2023-02-01-preview` is specified on the command line.

```yaml $(tag) == 'package-2023-02-01-preview'
input-file:
  - preview/2023-02-01-preview/AccessControlLists.json
  - preview/2023-02-01-preview/IpCommunities.json
  - preview/2023-02-01-preview/IpExtendedCommunities.json
  - preview/2023-02-01-preview/IpPrefixes.json
  - preview/2023-02-01-preview/L2IsolationDomains.json
  - preview/2023-02-01-preview/L3IsolationDomains.json
  - preview/2023-02-01-preview/NetworkDeviceSkus.json
  - preview/2023-02-01-preview/NetworkDevices.json
  - preview/2023-02-01-preview/NetworkFabricControllers.json
  - preview/2023-02-01-preview/NetworkFabricSkus.json
  - preview/2023-02-01-preview/NetworkFabrics.json
  - preview/2023-02-01-preview/NetworkRackSkus.json
  - preview/2023-02-01-preview/NetworkRacks.json
  - preview/2023-02-01-preview/Operations.json
  - preview/2023-02-01-preview/RoutePolicies.json
  - preview/2023-02-01-preview/common.json
```

### Tag: package-2022-01-15-privatepreview

These settings apply only when `--tag=package-2022-01-15-privatepreview` is specified on the command line.

```yaml $(tag) == 'package-2022-01-15-privatepreview'
input-file:
  - preview/2022-01-15-privatepreview/common.json
  - preview/2022-01-15-privatepreview/Operations.json
  - preview/2022-01-15-privatepreview/NetworkFabricControllers.json
  - preview/2022-01-15-privatepreview/NetworkFabrics.json
  - preview/2022-01-15-privatepreview/NetworkDevices.json
  - preview/2022-01-15-privatepreview/NetworkRacks.json
  - preview/2022-01-15-privatepreview/L2IsolationDomains.json
  - preview/2022-01-15-privatepreview/L3IsolationDomains.json
  - preview/2022-01-15-privatepreview/RoutePolicies.json
  - preview/2022-01-15-privatepreview/AccessControlLists.json
  - preview/2022-01-15-privatepreview/IpCommunityLists.json
  - preview/2022-01-15-privatepreview/IpPrefixLists.json
  - preview/2022-01-15-privatepreview/NetworkFabricSkus.json
  - preview/2022-01-15-privatepreview/NetworkRackSkus.json
  - preview/2022-01-15-privatepreview/NetworkDeviceSkus.json
```

---

# Code Generation

## Swagger to SDK

This section describes what SDK should be generated by the automatic system.
This is not used by Autorest itself.

```yaml $(swagger-to-sdk)
swagger-to-sdk:
  - repo: azure-sdk-for-go-track2
  - repo: azure-sdk-for-java
  - repo: azure-sdk-for-js
  - repo: azure-sdk-for-ruby
    after_scripts:
      - bundle install && rake arm:regen_all_profiles['azure_mgmt_managednetworkfabric']
```

## Go

See configuration in [readme.go.md](./readme.go.md)

## Python

See configuration in [readme.python.md](./readme.python.md)

## Ruby

See configuration in [readme.ruby.md](./readme.ruby.md)

## TypeScript

See configuration in [readme.typescript.md](./readme.typescript.md)

## CSharp

See configuration in [readme.csharp.md](./readme.csharp.md)
