# Resource

> see https://aka.ms/autorest
This is the AutoRest configuration file for microsoftphysicalnetwork.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the Resource API.

``` yaml
openapi-type: arm
openapi-subtype: providerHub
tag: package-changes-2025-03
```

### Tag: package-changes-2025-03

These settings apply only when `--tag=package-changes-2025-03` is specified on the command line.

``` yaml $(tag) == 'package-changes-2025-03'
input-file:
- stable/2025-03-01/changes.json

suppressions:
- code: OperationsAPIImplementation
  from: changes.json
  reason: Duplicate Operations API causes generation issues
- code: ResourceNameRestriction
  from: changes.json
  reason: Change resources cannot be created or named by end users
- code: AvoidAdditionalProperties
  from: changes.json
  where: $.definitions.ChangesDictionary
  reason: Change properties including the dictionary of individual property changes are dynamic types. Where clause is not working on all parent fields using this property bag, hence we're suppressing the entire file for now.
```
