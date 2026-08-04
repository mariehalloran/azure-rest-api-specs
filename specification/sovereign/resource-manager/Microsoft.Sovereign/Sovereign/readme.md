# sovereign

> see https://aka.ms/autorest

This is the AutoRest configuration file for sovereign.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the sovereign.

```yaml
title: Microsoft.Sovereign
openapi-type: arm
openapi-subtype: rpaas
tag: package-2026-07-31-preview
```

### Tag: package-2023-09-28-preview

These settings apply only when `--tag=package-2023-09-28-preview` is specified on the command line.

```yaml $(tag) == 'package-2023-09-28-preview'
input-file:
  - preview/2023-09-28-preview/sovereign.json
suppressions:
  - code: TopLevelResourcesListBySubscription
    reason: The resource types in the Microsoft.Sovereign resource provider are tenant level, so subscription list operation is not valid.
```

### Tag: package-2024-03-31-preview

These settings apply only when `--tag=package-2024-03-31-preview` is specified on the command line.

```yaml $(tag) == 'package-2024-03-31-preview'
input-file:
  - preview/2024-03-31-preview/sovereign.json
suppressions:
  - code: TopLevelResourcesListBySubscription
    reason: The resource types in the Microsoft.Sovereign resource provider are tenant level, so subscription list operation is not valid.
```

### Tag: package-2024-10-31-preview

These settings apply only when `--tag=package-2024-10-31-preview` is specified on the command line.

```yaml $(tag) == 'package-2024-10-31-preview'
input-file:
  - preview/2024-10-31-preview/sovereign.json
suppressions:
  - code: TopLevelResourcesListBySubscription
    reason: The transparency log resource type in the Microsoft.Sovereign resource provider is tenant level, so subscription list operation is not valid.
  - code: TenantLevelAPIsNotAllowed
    reason: The resource type /providers/transparencyLogs was added in previous version of this api where we got the approval for this resource type to be at tenant.
  - code: AvoidAnonymousTypes
    reason: This error is caused by typespec inbuilt managed identity model.
```

---

### Tag: package-2026-03-15-preview

These settings apply only when `--tag=package-2026-03-15-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-03-15-preview'
input-file:
  - preview/2026-03-15-preview/sovereign.json
suppressions:
  - code: AvoidAdditionalProperties
    from: sovereign.json
    where: $.definitions.SovereignViewPolicyInitiativeDetail.properties.assignmentParameters
    reason: Parameters vary based on the selected policy initiatives.
  - code: GuidUsage
    from: sovereign.json
    where:
      - $.definitions["SovereignViewSubscriptionScope"].properties.id.format
      - $.definitions["Azure.Core.uuid"].format
    reason: Subscription Ids are uuids.
```

---

### Tag: package-2026-07-31-preview

These settings apply only when `--tag=package-2026-07-31-preview` is specified on the command line.

```yaml $(tag) == 'package-2026-07-31-preview'
input-file:
  - preview/2026-07-31-preview/sovereign.json
suppressions:
  - code: AvoidAdditionalProperties
    from: sovereign.json
    where: $.definitions.SovereignViewPolicyInitiativeDetail.properties.assignmentParameters
    reason: Parameters vary based on the selected policy initiatives.
  - code: GuidUsage
    from: sovereign.json
    where:
      - $.definitions["SovereignViewSubscriptionScope"].properties.id.format
      - $.definitions["Azure.Core.uuid"].format
    reason: Subscription Ids are uuids.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/providers/Microsoft.Sovereign/transparencyLogs"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/providers/Microsoft.Sovereign/transparencyLogs/{name}"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/providers/Microsoft.Sovereign/landingZoneAccounts"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneConfigurations"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneRegistrations"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneConfigurations"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneConfigurations/{landingZoneConfigurationName}"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneConfigurations/{landingZoneConfigurationName}/createCopy"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneConfigurations/{landingZoneConfigurationName}/generateLandingZone"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneConfigurations/{landingZoneConfigurationName}/updateAuthoringStatus"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneRegistrations"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneRegistrations/{landingZoneRegistrationName}"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
  - code: MISSING_APIS_IN_DEFAULT_TAG
    from: sovereign.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sovereign/landingZoneAccounts/{landingZoneAccountName}/landingZoneRegistrations/{landingZoneRegistrationName}/drift"]
    reason: This resource type was removed in the 2026-07-31-preview API version and is intentionally not part of the default tag.
```

---

# Code Generation

## Swagger to SDK

This section describes what SDK should be generated by the automatic system.
This is not used by Autorest itself.

```yaml $(swagger-to-sdk)
swagger-to-sdk:
  - repo: azure-sdk-for-python-track2
  - repo: azure-sdk-for-java
  - repo: azure-sdk-for-go
  - repo: azure-sdk-for-js
  - repo: azure-resource-manager-schemas
  - repo: azure-cli-extensions
  - repo: azure-powershell
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
