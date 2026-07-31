import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Windows365;

@@clientName(CloudPcDelegatedMsis.createOrUpdate::parameters.resource, "body");
@@clientName(CloudPcDelegatedMsis.update::parameters.properties, "body");
@@clientLocation(CloudPcDelegatedMsis.get, "CloudPcDelegatedMsi");
@@clientLocation(CloudPcDelegatedMsis.createOrUpdate, "CloudPcDelegatedMsi");
@@clientLocation(CloudPcDelegatedMsis.update, "CloudPcDelegatedMsi");
@@clientLocation(CloudPcDelegatedMsis.delete, "CloudPcDelegatedMsi");
@@clientLocation(
  CloudPcDelegatedMsis.listByResourceGroup,
  "CloudPcDelegatedMsi"
);
@@clientLocation(
  CloudPcDelegatedMsis.listBySubscription,
  "CloudPcDelegatedMsi"
);

@@clientLocation(ServiceConnectors.get, "ServiceConnector");
@@clientLocation(ServiceConnectors.createOrUpdate, "ServiceConnector");
@@clientLocation(ServiceConnectors.update, "ServiceConnector");
@@clientLocation(ServiceConnectors.delete, "ServiceConnector");
@@clientLocation(ServiceConnectors.listByResourceGroup, "ServiceConnector");
@@clientLocation(ServiceConnectors.listBySubscription, "ServiceConnector");
