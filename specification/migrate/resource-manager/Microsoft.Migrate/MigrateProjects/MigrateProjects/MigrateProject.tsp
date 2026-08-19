using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.Migrate;

/** The Migrate project that is the parent of the Migrate plan. This resource is owned by the Microsoft.Migrate GA API and is referenced here only to establish the parent scope; it is intentionally not modeled by this API version. */
@armVirtualResource
model MigrateProject {
  /** Migrate Project Name */
  @segment("migrateProjects")
  @key("projectName")
  @path
  @pattern("^[A-Za-z0-9](?:[A-Za-z0-9-]{0,62}[A-Za-z0-9])?$")
  name: string;
}
