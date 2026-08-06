# Azure Migrate

> see https://aka.ms/autorest

This is the AutoRest configuration file for Azure Migrate Projects, Plans, and Artifacts.

---

## Getting Started

To build the SDK for Migrate, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> `autorest`

To see additional help and options, run:

> `autorest --help`

---

## Configuration

### Basic Information

These are the global settings for the API.

```yaml
openapi-type: arm
tag: package-preview-2026-06-15
```

### Tag: package-preview-2026-06-15

These settings apply only when `--tag=package-preview-2026-06-15` is specified on the command line.

```yaml $(tag) == 'package-preview-2026-06-15'
input-file:
  - preview/2026-06-15-preview/migrateProjects.json
suppressions:
  - code: OperationsAPIImplementation
    reason: Microsoft.Migrate resource provider has one RP with multiple SDKs. Operations API is centrally implemented at the AssessmentProjects level and intentionally excluded from individual service specifications to avoid duplication across multiple SDK instances.
  - code: RequiredPropertiesMissingInResourceModel
    from: migrateProjects.json
    where: $.definitions.GenerateDownloadUrlOperationStatus
    reason: GenerateDownloadUrlOperationStatus is the long-running-operation status monitor returned by the subscription/location-scoped operationStatuses GET, not an ARM resource. It intentionally follows the ARM operation status result contract (top-level status, startTime, endTime, percentComplete, error, properties) rather than the tracked/proxy resource envelope, so the name/id/type resource properties do not apply.
  - code: BodyTopLevelProperties
    from: migrateProjects.json
    where: $.definitions.GenerateDownloadUrlOperationStatus
    reason: GenerateDownloadUrlOperationStatus is the long-running-operation status monitor returned by the operationStatuses GET, not an ARM resource. Its top-level status/startTime/endTime/percentComplete/error properties are required by the ARM async operation status result contract; the LRO poller reads status from the top level, so these properties cannot be moved into a properties bag without breaking asynchronous polling.
  - code: EnumInsteadOfBoolean
    from: migrateProjects.json
    where: $.definitions.GenerateDownloadUrlRequest.properties.includeMetadata
    reason: includeMetadata is a genuine two-state include/exclude flag with no foreseeable additional states. Modeling it as an enum would add no descriptive value and would complicate client usage, so it is intentionally kept as a boolean.
  - code: LroLocationHeader
    from: migrateProjects.json
    where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{projectName}/artifacts/{artifactName}/generateDownloadUrl"].post.responses["202"].headers
    reason: The generateDownloadUrl action is an ARM asynchronous operation whose terminal state is reported exclusively via the Azure-AsyncOperation header (final-state-via azure-async-operation). The 202 intentionally omits the Location header because there is no interim result resource to poll; clients poll the subscription/location-scoped operationStatuses status monitor referenced by Azure-AsyncOperation. The Location header required by RPC-Async-V1-07 does not apply to this azure-async-operation-only polling model.
```

### Tag: package-preview-2026-06

These settings apply only when `--tag=package-preview-2026-06` is specified on the command line.

```yaml $(tag) == 'package-preview-2026-06'
input-file:
  - preview/2026-06-01-preview/migrateProjects.json
suppressions:
  - code: OperationsAPIImplementation
    reason: Microsoft.Migrate resource provider has one RP with multiple SDKs. Operations API is centrally implemented at the AssessmentProjects level and intentionally excluded from individual service specifications to avoid duplication across multiple SDK instances.
```

## Suppression

```yaml
directive:
  - suppress: SECRET_PROPERTY
    from: preview/2026-06-15-preview/migrateProjects.json
    where: $.definitions.GenerateDownloadUrlResult.properties.sasUrl
    reason: The read-only sasUrl is a short-lived, per-request download credential produced only by the generateDownloadUrl POST action and surfaced through its asynchronous operation status monitor. All clients with `Microsoft.Migrate/locations/operationStatuses/read` (or higher) should (intentionally) be able to use the storage resource referred to by the read-only SAS URL, as per the product design of Azure Migrate.
```
