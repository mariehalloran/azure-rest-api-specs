import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.PortalServices;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "@Azure.ClientGenerator.Core.Legacy.flattenProperty decorator is not recommended to use."
@@Azure.ClientGenerator.Core.Legacy.flattenProperty(
  PatchablePortalExtension.properties,
  "!autorest"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "@Azure.ClientGenerator.Core.Legacy.flattenProperty decorator is not recommended to use."
@@Azure.ClientGenerator.Core.Legacy.flattenProperty(
  PatchableExtensionVersion.properties,
  "!autorest"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "@Azure.ClientGenerator.Core.Legacy.flattenProperty decorator is not recommended to use."
@@Azure.ClientGenerator.Core.Legacy.flattenProperty(
  PatchableExtensionSlot.properties,
  "!autorest"
);
