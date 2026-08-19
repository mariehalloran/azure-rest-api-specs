# Microsoft.StorageInventory TypeSpec

This directory contains the TypeSpec definition for the Microsoft.StorageInventory resource provider.

## Overview

Microsoft.StorageInventory provides APIs for managing storage tenant and internal storage account information across Azure storage infrastructure. This service enables customers to track and monitor storage inventory with metadata about deployment configuration and operational status.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) LTS version
- [TypeSpec](https://typespec.io/) compiler installed globally or via npm
- Git for version control

### Development Workflow

1. **Install Dependencies**

   ```bash
   npm ci
   ```

2. **Format Code**

   ```bash
   tsp format
   ```

3. **Compile Specification**

   ```bash
   tsp compile .
   ```

4. **Validate Generated Output**
   ```bash
   npx tsv .
   ```

## Resources

### Tenants (`/providers/Microsoft.StorageInventory/tenants`)

- **Resource Type**: `Microsoft.StorageInventory/tenants`
- **Description**: Manages storage inventory tenant configurations and metadata
- **Operations**: Get, List
- **Scope**: Tenant-level resource
- **Key Features**:
  - Geographic distribution tracking
  - Hardware configuration management
  - Environment and deployment status monitoring
  - Data center location mapping

### Storage Accounts (`/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageInventory/storageAccounts`)

- **Resource Type**: `Microsoft.StorageInventory/storageAccounts`
- **Description**: Represents internal storage accounts published through Storage Inventory
- **Operations**: Get, List by resource group
- **Scope**: Resource-group-level resource
- **ARM Identity**: Published inventory records use the `Microsoft.StorageInventory/storageAccounts` ID and type

## Project Structure

```
StorageInventory.Management/
├── main.tsp                      # Main namespace, versioning, and service definition
├── tenant.tsp                    # Tenant resource model and operations
├── operation.tsp                 # Provider operations interface
├── tspconfig.yaml                # TypeSpec compiler configuration
├── suppressions.yaml             # Linting rule suppressions
├── .gitignore                    # Git ignore patterns
├── README.md                     # This documentation
├── storageaccount.tsp            # Internal storage account resource model and operations
└── examples/                     # API operation examples
    ├── 2025-05-01-preview/       # Original tenant APIs
    └── 2026-07-01-preview/
        ├── StorageAccounts_Get.json
        ├── StorageAccounts_ListByResourceGroup.json
        ├── Tenants_Get.json      # Single tenant retrieval
        ├── Tenants_List.json     # Tenant collection listing
        └── Operations_List.json  # Available provider operations
```

## API Version

- **Current Version**: `2026-07-01-preview`
- **Status**: Preview
- **Stability**: Subject to breaking changes
- **Target GA**: TBD

## Generated Output

When compiled, this TypeSpec generates:

```
../resource-manager/Microsoft.StorageInventory/preview/
├── 2025-05-01-preview/                # Original tenant APIs
└── 2026-07-01-preview/
    ├── microsoft-storageinventory.json
    └── examples/
        ├── Tenants_Get.json
        ├── Tenants_List.json
        ├── StorageAccounts_Get.json
        ├── StorageAccounts_ListByResourceGroup.json
        └── Operations_List.json
```

## Resource Properties

The Tenant resource includes comprehensive storage inventory metadata:

### Core Identity

- **tenant**: Unique tenant name identifier
- **environment**: Deployment environment (Production, Staging, Development)
- **type**: Tenant classification type

### Geographic Configuration

- **geoRegion**: Geographic region (e.g., `asiaeast`, `asiasoutheast`)
- **geoDomain**: Geo-specific domain configuration
- **geoPairName**: Associated geo-pair tenant for redundancy
- **dataCenter**: Physical data center location (e.g., `HKG20`, `SG2`)
- **armRegion**: Azure Resource Manager region mapping

### Infrastructure Details

- **hardwareSetup**: Hardware generation and configuration (e.g., `Gen 5`)
- **zrsSetup**: Zone Redundant Storage configuration
- **isLimitless**: Limitless storage capability flag
- **isRdma**: Remote Direct Memory Access support
- **stg**: Storage configuration identifier

### Operational Status

- **provisioningState**: Current resource lifecycle state (Succeeded, Failed, etc.)
- **inBuildOut**: Tenant is in build-out phase
- **inDecom**: Tenant is being decommissioned
- **isReadyForCustomer**: Customer readiness status
- **intent**: Operational intent classification
- **rsrpName**: Associated Resource Service Registration Provider

The Storage Account resource publishes the following property subset:

- **dnsEndpointType**: DNS endpoint type
- **supportsHttpsTrafficOnly**: Whether HTTPS-only traffic is required
- **provisioningState**: Current resource lifecycle state
- **creationTime**: Resource creation date and time

## API Operations

### Resource Management

| Operation                                   | Method | Path                                                                                                                                           | Description                                        |
| ------------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| **Get Tenant**                              | `GET`  | `/providers/Microsoft.StorageInventory/tenants/{tenantName}`                                                                                   | Retrieve specific tenant details                   |
| **List Tenants**                            | `GET`  | `/providers/Microsoft.StorageInventory/tenants`                                                                                                | List all available tenants                         |
| **Get Storage Account**                     | `GET`  | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageInventory/storageAccounts/{storageAccountName}` | Retrieve an internal storage account               |
| **List Storage Accounts by Resource Group** | `GET`  | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageInventory/storageAccounts`                      | List internal storage accounts in a resource group |
| **List Operations**                         | `GET`  | `/providers/Microsoft.StorageInventory/operations`                                                                                             | Get available provider operations                  |

### Example Usage

```bash
# Get a specific tenant
GET /providers/Microsoft.StorageInventory/tenants/MS-HKG20PrdStr07A

# List all tenants
GET /providers/Microsoft.StorageInventory/tenants

# Get an internal storage account
GET /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageInventory/storageAccounts/{storageAccountName}

# Check available operations
GET /providers/Microsoft.StorageInventory/operations
```

## Standards Compliance

This specification adheres to:

- **[Azure REST API Guidelines](https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md)** - Microsoft's API design standards
- **[Azure Resource Manager Patterns](https://docs.microsoft.com/en-us/azure/azure-resource-manager/)** - ARM resource lifecycle and conventions
- **[TypeSpec Best Practices](https://typespec.io/docs/)** - Modern API specification practices
- **[OpenAPI 2.0](https://swagger.io/specification/v2/)** - Industry-standard API documentation format
- **[Azure TypeSpec Guidelines](https://azure.github.io/typespec-azure/)** - Azure-specific TypeSpec conventions

## Development Guidelines

### Code Style

- Use `tsp format` before committing changes
- Follow camelCase for property names (e.g., `isReadyForCustomer`)
- Include comprehensive documentation for all models and operations
- Maintain consistent naming patterns across resources

### Validation

- All changes must pass `tsp compile` without errors
- Examples must match the generated OpenAPI schema
- Follow ARM resource naming conventions for identifiers
- Include appropriate `@doc` decorators for all public APIs

### Contributing

When modifying this specification:

1. **Create a feature branch** from the `RPSaaSMaster` branch
2. **Make changes** to TypeSpec files following conventions
3. **Format and validate** using `tsp format` and `tsp compile`
4. **Update examples** to match any schema changes
5. **Test compilation** to ensure no breaking changes
6. **Submit PR** with clear description of changes
