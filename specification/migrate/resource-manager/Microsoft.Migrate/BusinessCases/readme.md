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

```yaml
openapi-type: arm
tag: package-preview-2026-06
```

### Tag: package-preview-2026-06

These settings apply only when `--tag=package-preview-2026-06` is specified on the command line.

```yaml $(tag) == 'package-preview-2026-06'
input-file:
  - preview/2026-06-06-preview/businessCases.json
suppressions:
  - code: MISSING_APIS_IN_DEFAULT_TAG
    reason: The getReportDownloadUrl action was intentionally removed in the 2026-06-06-preview version, where report generation is modeled as a separate ARM resource (reportArmId/reportsRequired). The operation remains available in prior preview versions (package-preview-2025-09 and earlier).
```

### Tag: package-preview-2025-09

These settings apply only when `--tag=package-preview-2025-09` is specified on the command line.

```yaml $(tag) == 'package-preview-2025-09'
input-file:
  - preview/2025-09-09-preview/businessCases.json
```

### Tag: package-preview-2024-03

These settings apply only when `--tag=package-preview-2024-03` is specified on the command line.

```yaml $(tag) == 'package-preview-2024-03'
input-file:
  - preview/2024-03-03-preview/businessCases.json
suppressions:
  - code: OperationsAPIImplementation
    reason: Microsoft.Migrate resource provider has one RP with multiple SDKs. Operations API is centrally implemented at the AssessmentProjects level and intentionally excluded from individual service specifications to avoid duplication across multiple SDK instances.
```
