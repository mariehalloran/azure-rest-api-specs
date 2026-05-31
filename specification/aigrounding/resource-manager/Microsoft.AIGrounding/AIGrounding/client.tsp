import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using Microsoft.AIGrounding;

@@clientName(
  CustomSearchConfigurations.createOrUpdate::parameters.resource,
  "customSearchConfiguration"
);

// Additional @@clientName decorators for operations with @operationId
@@clientName(AIGroundingAccounts.get, "Get");
@@clientName(AIGroundingAccounts.create, "Create");
@@clientName(AIGroundingAccounts.update, "Update");
@@clientName(AIGroundingAccounts.delete, "Delete");
@@clientName(AIGroundingAccounts.listByResourceGroup, "ListByResourceGroup");
@@clientName(AIGroundingAccounts.list, "List");
@@clientName(AIGroundingAccounts.listSkus, "ListSkus");
@@clientName(AIGroundingAccounts.listUsages, "ListUsages");

@@clientName(CustomSearchConfigurations.get, "Get");
@@clientName(CustomSearchConfigurations.createOrUpdate, "CreateOrUpdate");
@@clientName(CustomSearchConfigurations.delete, "Delete");
@@clientName(CustomSearchConfigurations.listByAccount, "ListByAccount");

@@clientName(SkusOperationGroup.list, "List");
@@clientName(SkusOperationGroup.checkAvailability, "CheckAvailability");

@@clientName(AIGroundingAccounts.create::parameters.resource, "account");
@@clientName(AIGroundingAccounts.update::parameters.properties, "account");
@@clientName(
  SkusOperationGroup.checkAvailability::parameters.body,
  "parameters"
);

@@clientName(
  CheckSkuAvailabilityParameter,
  "CheckSkuAvailabilityContent",
  "csharp"
);

// @@clientLocation decorators for operations with custom @operationId
// These ensure consistent operationId generation in the output

// AIGroundingAccounts interface operations
@@clientLocation(AIGroundingAccounts.get, "Accounts");
@@clientLocation(AIGroundingAccounts.create, "Accounts");
@@clientLocation(AIGroundingAccounts.update, "Accounts");
@@clientLocation(AIGroundingAccounts.delete, "Accounts");
@@clientLocation(AIGroundingAccounts.listByResourceGroup, "Accounts");
@@clientLocation(AIGroundingAccounts.list, "Accounts");
@@clientLocation(AIGroundingAccounts.listSkus, "Accounts");
@@clientLocation(AIGroundingAccounts.listUsages, "Accounts");

// CustomSearchConfigurations interface operations
@@clientLocation(CustomSearchConfigurations.get, "CustomSearchConfigurations");
@@clientLocation(
  CustomSearchConfigurations.createOrUpdate,
  "CustomSearchConfigurations"
);
@@clientLocation(
  CustomSearchConfigurations.delete,
  "CustomSearchConfigurations"
);
@@clientLocation(
  CustomSearchConfigurations.listByAccount,
  "CustomSearchConfigurations"
);

// SkusOperationGroup interface operations
@@clientLocation(SkusOperationGroup.list, "Skus");
@@clientLocation(SkusOperationGroup.checkAvailability, "Skus");
