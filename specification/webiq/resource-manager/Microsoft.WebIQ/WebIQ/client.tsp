import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using Microsoft.WebIQ;

@@clientName(
  CustomSearchConfigurations.createOrUpdate::parameters.resource,
  "customSearchConfiguration"
);

// Additional @@clientName decorators for operations with @operationId
@@clientName(WebIQAccounts.get, "Get");
@@clientName(WebIQAccounts.create, "Create");
@@clientName(WebIQAccounts.update, "Update");
@@clientName(WebIQAccounts.delete, "Delete");
@@clientName(WebIQAccounts.listByResourceGroup, "ListByResourceGroup");
@@clientName(WebIQAccounts.list, "List");
@@clientName(WebIQAccounts.listSkus, "ListSkus");
@@clientName(WebIQAccounts.listUsages, "ListUsages");

@@clientName(CustomSearchConfigurations.get, "Get");
@@clientName(CustomSearchConfigurations.createOrUpdate, "CreateOrUpdate");
@@clientName(CustomSearchConfigurations.delete, "Delete");
@@clientName(CustomSearchConfigurations.listByAccount, "ListByAccount");

@@clientName(SkusOperationGroup.list, "List");
@@clientName(SkusOperationGroup.checkAvailability, "CheckAvailability");

@@clientName(WebIQAccounts.create::parameters.resource, "account");
@@clientName(WebIQAccounts.update::parameters.properties, "account");
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

// WebIQAccounts interface operations
@@clientLocation(WebIQAccounts.get, "Accounts");
@@clientLocation(WebIQAccounts.create, "Accounts");
@@clientLocation(WebIQAccounts.update, "Accounts");
@@clientLocation(WebIQAccounts.delete, "Accounts");
@@clientLocation(WebIQAccounts.listByResourceGroup, "Accounts");
@@clientLocation(WebIQAccounts.list, "Accounts");
@@clientLocation(WebIQAccounts.listSkus, "Accounts");
@@clientLocation(WebIQAccounts.listUsages, "Accounts");

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
