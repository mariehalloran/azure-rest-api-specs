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
  - suppress: LocationMustHaveXmsMutability
    from: securitybaseplatform.json
    where: $.definitions.ManagedResourceGroupConfiguration.properties.location
    reason: The managed resource group configuration is service-generated and read-only.
  - suppress: AvoidAdditionalProperties
    from: securitybaseplatform.json
    where: $.definitions.StringMap
    reason: >
      StringMap models user-defined Kubernetes labels and annotations whose keys
      are not knowable in advance, so an open string-to-string map is required.
```

### Tag: avocado-examples

These settings are used for CI reference validation of example files.

```yaml $(tag) == 'avocado-examples'
input-file:
  - examples/2025-03-01-preview/Clusters_CreateOrUpdate.json
  - examples/2025-03-01-preview/Clusters_Delete.json
  - examples/2025-03-01-preview/Clusters_Get.json
  - examples/2025-03-01-preview/Clusters_ListByResourceGroup.json
  - examples/2025-03-01-preview/Clusters_ListBySubscription.json
  - examples/2025-03-01-preview/Clusters_Update.json
  - examples/2025-03-01-preview/CronJobDeployments_Get.json
  - examples/2025-03-01-preview/CronJobDeployments_ListByCronJob.json
  - examples/2025-03-01-preview/CronJobs_CreateOrUpdate.json
  - examples/2025-03-01-preview/CronJobs_Delete.json
  - examples/2025-03-01-preview/CronJobs_Get.json
  - examples/2025-03-01-preview/CronJobs_ListByNamespace.json
  - examples/2025-03-01-preview/CronJobs_Update.json
  - examples/2025-03-01-preview/Deployments_Get.json
  - examples/2025-03-01-preview/Deployments_ListByNamespace.json
  - examples/2025-03-01-preview/JobDeployments_Get.json
  - examples/2025-03-01-preview/JobDeployments_ListByJob.json
  - examples/2025-03-01-preview/Jobs_CreateOrUpdate.json
  - examples/2025-03-01-preview/Jobs_Delete.json
  - examples/2025-03-01-preview/Jobs_Get.json
  - examples/2025-03-01-preview/Jobs_ListByNamespace.json
  - examples/2025-03-01-preview/Jobs_Update.json
  - examples/2025-03-01-preview/Namespaces_CreateOrUpdate.json
  - examples/2025-03-01-preview/Namespaces_Delete.json
  - examples/2025-03-01-preview/Namespaces_Get.json
  - examples/2025-03-01-preview/Namespaces_ListByCluster.json
  - examples/2025-03-01-preview/Namespaces_Update.json
  - examples/2025-03-01-preview/Operations_List.json
  - examples/2025-03-01-preview/ServiceDeployments_Get.json
  - examples/2025-03-01-preview/ServiceDeployments_ListByService.json
  - examples/2025-03-01-preview/Services_CreateOrUpdate.json
  - examples/2025-03-01-preview/Services_CreateOrUpdate_Minimal.json
  - examples/2025-03-01-preview/Services_Delete.json
  - examples/2025-03-01-preview/Services_Get.json
  - examples/2025-03-01-preview/Services_ListByNamespace.json
  - examples/2025-03-01-preview/Services_Update.json
  - examples/2025-03-01-preview/Workspaces_CreateOrUpdate.json
  - examples/2025-03-01-preview/Workspaces_Delete.json
  - examples/2025-03-01-preview/Workspaces_Get.json
  - examples/2025-03-01-preview/Workspaces_ListByResourceGroup.json
  - examples/2025-03-01-preview/Workspaces_ListBySubscription.json
  - examples/2025-03-01-preview/Workspaces_Update.json
```
