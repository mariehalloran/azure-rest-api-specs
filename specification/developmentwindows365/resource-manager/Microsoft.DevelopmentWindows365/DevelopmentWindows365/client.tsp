import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.DevelopmentWindows365;

@@clientLocation(
  DevelopmentCloudPcDelegatedMsis.get,
  "DevelopmentCloudPcDelegatedMsi"
);
@@clientLocation(
  DevelopmentCloudPcDelegatedMsis.createOrUpdate,
  "DevelopmentCloudPcDelegatedMsi"
);
@@clientLocation(
  DevelopmentCloudPcDelegatedMsis.update,
  "DevelopmentCloudPcDelegatedMsi"
);
@@clientLocation(
  DevelopmentCloudPcDelegatedMsis.delete,
  "DevelopmentCloudPcDelegatedMsi"
);
@@clientLocation(
  DevelopmentCloudPcDelegatedMsis.listByResourceGroup,
  "DevelopmentCloudPcDelegatedMsi"
);
@@clientLocation(
  DevelopmentCloudPcDelegatedMsis.listBySubscription,
  "DevelopmentCloudPcDelegatedMsi"
);
