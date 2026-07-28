import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("A Migrate project Resource. Defined locally as the parent for PlatformLandingZone; the canonical resource is owned by the sibling Microsoft.Migrate TypeSpec projects.")
model MigrateProject is TrackedResource<MigrateProjectProperties> {
  @doc("Migrate Project Name. The name constraint mirrors the existing GA Microsoft.Migrate/migrateProjects contract.")
  @segment("migrateProjects")
  @key("projectName")
  @path
  @pattern("^[^<>&:\\?/#]{1,260}$")
  name: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Migrate Project is already GA and does not expose a provisioning state on this stub."
@doc("Properties of a migrate project. Minimal stub used solely to anchor PlatformLandingZone as a child resource; the full property set is defined by the sibling Microsoft.Migrate TypeSpec projects.")
model MigrateProjectProperties {
  @doc("Service endpoint.")
  serviceEndpoint?: string;
}
