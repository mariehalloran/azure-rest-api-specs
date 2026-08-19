# Azure Migrate

> see https://aka.ms/autorest

This is the AutoRest configuration file for Azure Migrate - Assessment.

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

``` yaml
openapi-type: arm
tag: package-preview-2025-09
```

### Tag: package-preview-2025-09

These settings apply only when `--tag=package-preview-2025-09` is specified on the command line.

```yaml $(tag) == 'package-preview-2025-09'
input-file:
  - preview/2025-09-09-preview/assessmentProjects.json
suppressions:
  - code: RequiredPropertiesMissingInResourceModel
    reason: OperationResults is the standard ARM operation-status envelope (the ArmOperationStatus template returned by the subscription-level operationStatuses GET), not a tracked or proxy resource, so it intentionally does not expose resource name/id/type in the ARM resource sense.
    from: assessmentProjects.json
    where: $.definitions.OperationResults
  - code: BodyTopLevelProperties
    reason: OperationResults is the standard ARM operation-status envelope; status, startTime, endTime, percentComplete and error are the well-known ARM operation-status fields defined by common-types, not resource top-level properties.
    from: assessmentProjects.json
    where: $.definitions.OperationResults
```

### Tag: package-preview-2024-03

These settings apply only when `--tag=package-preview-2024-03` is specified on the command line.

```yaml $(tag) == 'package-preview-2024-03'
input-file:
  - preview/2024-03-03-preview/assessmentProjects.json
```
