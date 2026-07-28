import "../Common/Enums/Enums.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;
using OpenAPI;

namespace Microsoft.Migrate;

@doc("The Migrate project that is the parent of the Migrate plan. This resource is owned by the Microsoft.Migrate GA API and is referenced here only to establish the parent scope; it is intentionally not modeled by this API version.")
@armVirtualResource
model MigrateProject {
  @doc("Migrate Project Name")
  @segment("migrateProjects")
  @key("projectName")
  @path
  @pattern("^[A-Za-z0-9](?:[A-Za-z0-9-]{0,62}[A-Za-z0-9])?$")
  name: string;
}

@doc("A Migrate plan (Data Center Plan).")
@parentResource(MigrateProject)
model MigratePlan is ProxyResource<MigratePlanProperties> {
  @doc("The name of the Migrate plan.")
  @key("planName")
  @segment("plans")
  @path
  @maxLength(40)
  @pattern("^[A-Za-z0-9][A-Za-z0-9_.-]{0,39}$")
  name: string;
}

@doc("The properties of a Migrate plan (Data Center Plan).")
model MigratePlanProperties {
  @doc("The type of the plan. Defaults to 'DataCenter' when not specified.")
  planType?: PlanType;

  @doc("The status of the last operation performed on the plan.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("The status of the plan.")
  @visibility(Lifecycle.Read)
  status?: Status;

  @doc("The Azure Resource Manager ID of the artifact resource generated for the plan.")
  @visibility(Lifecycle.Read)
  artifactId?: armResourceIdentifier<[
    {
      type: "Microsoft.Migrate/migrateProjects/artifacts";
    }
  ]>;

  @doc("The settings that control how the plan is generated.")
  settings?: MigratePlanSettings;

  @doc("The artifacts associated with the plan.")
  artifacts?: MigratePlanArtifacts;

  @doc("The error encountered while generating the plan, if any.")
  @visibility(Lifecycle.Read)
  error?: MigratePlanErrorDetails;
}

@doc("The settings for a Migrate plan.")
model MigratePlanSettings {
  @doc("The migration strategy selected for the plan.")
  migrationStrategy?: MigrationStrategy;
}

@doc("The collection of artifacts associated with a Migrate plan.")
model MigratePlanArtifacts {
  @doc("The discovery artifact.")
  discovery?: MigratePlanDiscoveryArtifact;

  @doc("The heterogeneous assessment artifact.")
  heterogeneousAssessment?: MigratePlanSourceArtifact;

  @doc("The business case artifacts, one per migration strategy.")
  @identifiers(#[])
  businessCases?: MigratePlanStrategyArtifact[];

  @doc("The wave plan artifacts, one per migration strategy.")
  @identifiers(#[])
  wavePlans?: MigratePlanStrategyArtifact[];

  @doc("The platform landing zone artifact.")
  platformLandingZone?: MigratePlanSourceArtifact;

  @doc("The application migration evaluation (AME) report artifacts.")
  @identifiers(#[])
  ameReports?: MigratePlanStrategyArtifact[];
}

@doc("The base representation of an artifact within a Migrate plan.")
model MigratePlanArtifact {
  @doc("The status of the artifact.")
  @visibility(Lifecycle.Read)
  status?: Status;

  @doc("The error encountered while generating the artifact, if any.")
  @visibility(Lifecycle.Read)
  error?: MigratePlanErrorDetails;
}

@doc("The discovery artifact for a Migrate plan.")
model MigratePlanDiscoveryArtifact {
  ...MigratePlanArtifact;

  @doc("The scope that controls which resources are included in discovery.")
  scope?: MigratePlanDiscoveryScope;
}

@doc("The scope that controls which resources are included in discovery for a Migrate plan.")
model MigratePlanDiscoveryScope {
  @doc("The Azure Resource Graph query used to scope discovery.")
  @maxLength(5000)
  azureResourceGraphQuery?: string;
}

@doc("The details of an error encountered during Migrate plan generation.")
model MigratePlanErrorDetails {
  @doc("The error code.")
  @visibility(Lifecycle.Read)
  code?: string;

  @doc("The error message.")
  @visibility(Lifecycle.Read)
  message?: string;

  @doc("The timestamp, in UTC, at which the error was last updated.")
  @visibility(Lifecycle.Read)
  updatedTimeStamp?: utcDateTime;
}

@doc("An artifact within a Migrate plan that is backed by a source resource.")
model MigratePlanSourceArtifact {
  @doc("The Azure Resource Manager ID of the source resource for this artifact.")
  armId?: armResourceIdentifier;

  ...MigratePlanArtifact;
}

@doc("An artifact within a Migrate plan that is associated with a migration strategy.")
model MigratePlanStrategyArtifact {
  ...MigratePlanSourceArtifact;

  @doc("The migration strategy associated with the artifact.")
  migrationStrategy?: MigrationStrategy;
}
