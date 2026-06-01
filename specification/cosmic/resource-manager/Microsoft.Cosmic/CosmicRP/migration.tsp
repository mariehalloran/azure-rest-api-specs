import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./environment.tsp";

using Azure.ResourceManager;

namespace Microsoft.Cosmic;

// --- Preview models -------------------------------------------------

@doc("Request body for the preview action.")
model PreviewRequest {
  @doc("The name of the environment to preview.")
  environmentName: string;

  @doc("The environment properties to preview.")
  properties: EnvironmentProperties;
}

@doc("Response body for the preview action. Includes the stored environment properties along with projected inventory status showing how existing brownfield instances map to the ARM model.")
model PreviewResult {
  @doc("The name of the previewed environment.")
  environmentName: string;

  @doc("The environment properties as stored in ARM, including projected inventory status with per-region realizations derived from live inventory.")
  properties: EnvironmentProperties;
}

// --- Validate models ------------------------------------------------

@doc("Request body for the validate action.")
model ValidateRequest {
  @doc("The name of the environment to validate.")
  environmentName: string;

  @doc("Platform ring classification (e.g. test, sdf, msit, prod). Used by APIM to route the request to the target ring's RP instance.")
  platformRing: CosmicRing;
}

@doc("Response body for the validate action.")
model ValidateResult {
  @doc("Whether the ARM template is consistent with inventory.")
  isConsistent: boolean;

  @doc("List of differences found between ARM and inventory.")
  @identifiers(#[])
  differences?: ValidationDifference[];
}

@doc("A single difference between ARM template and inventory.")
model ValidationDifference {
  @doc("The type of difference.")
  differenceType: ValidationDifferenceType;

  @doc("Human-readable description of the difference.")
  description: string;

  @doc("The Azure region where the difference was found.")
  location?: string;

  @doc("The partition name involved, if applicable.")
  partition?: string;

  @doc("The instance ID involved, if applicable.")
  instanceId?: string;

  @doc("The instance count in the ARM template, if applicable.")
  templateCount?: int32;

  @doc("The instance count in inventory, if applicable.")
  inventoryCount?: int32;

  @doc("The instance state, if applicable.")
  state?: string;
}

@doc("The type of validation difference.")
union ValidationDifferenceType {
  @doc("Instance exists in inventory but not in the ARM template.")
  MissingInTemplate: "MissingInTemplate",

  @doc("Instance count mismatch between ARM and inventory.")
  CapacityMismatch: "CapacityMismatch",

  @doc("Instance is deleted or cleaned up in inventory.")
  DeletedInstance: "DeletedInstance",

  @doc("Configuration difference between ARM and inventory.")
  ConfigDifference: "ConfigDifference",

  string,
}

// --- Migrate models -------------------------------------------------

@doc("Request body for the migrate action.")
model MigrateRequest {
  @doc("The name of the environment to migrate.")
  environmentName: string;

  @doc("Platform ring classification (e.g. test, sdf, msit, prod). Used by APIM to route the request to the target ring's RP instance.")
  platformRing: CosmicRing;
}

@doc("Response body for the migrate action.")
model MigrateResult {
  @doc("The name of the environment that was migrated.")
  environmentName: string;

  @doc("The overall status of the migration.")
  status: MigrationStatus;

  @doc("Total number of instances targeted for migration.")
  totalInstanceCount: int32;

  @doc("Number of instances successfully migrated.")
  migratedInstanceCount: int32;

  @doc("Number of instances skipped (e.g., deleted or cleaned up).")
  skippedInstanceCount: int32;

  @doc("Per-instance migration details.")
  @identifiers(#["instanceId"])
  instances?: MigratedInstance[];
}

@doc("The overall status of a migration operation.")
union MigrationStatus {
  @doc("Migration completed successfully.")
  Succeeded: "Succeeded",

  @doc("Migration failed.")
  Failed: "Failed",

  @doc("Migration partially succeeded - some instances could not be migrated.")
  PartiallySucceeded: "PartiallySucceeded",

  string,
}

@doc("Migration result for a single instance.")
model MigratedInstance {
  @doc("The instance identifier.")
  instanceId: string;

  @doc("The Azure region of the instance.")
  region: string;

  @doc("The partition the instance belongs to.")
  partition: string;

  @doc("Whether this instance was successfully migrated.")
  migrated: boolean;

  @doc("Reason the instance was skipped or failed, if applicable.")
  reason?: string;
}
