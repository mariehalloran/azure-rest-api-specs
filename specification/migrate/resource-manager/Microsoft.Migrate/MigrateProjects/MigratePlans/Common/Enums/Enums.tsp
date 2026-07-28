using Azure.ResourceManager;
using TypeSpec.Versioning;

namespace Microsoft.Migrate;

@doc("The status of a Migrate plan or one of its artifacts.")
union Status {
  @doc("The plan or artifact has been created.")
  Created: "Created",

  @doc("The plan or artifact has been updated.")
  Updated: "Updated",

  @doc("The plan or artifact is currently running.")
  Running: "Running",

  @doc("The plan or artifact has completed and is ready.")
  Completed: "Completed",

  @doc("The plan or artifact is invalid.")
  Invalid: "Invalid",

  @doc("The plan or artifact is out of sync.")
  OutOfSync: "OutOfSync",

  @doc("The plan or artifact is out of date.")
  OutDated: "OutDated",

  @doc("The plan or artifact has been deleted.")
  Deleted: "Deleted",

  @doc("The plan or artifact has failed.")
  Failed: "Failed",

  string,
}

@doc("The migration strategy selected for a Migrate plan or artifact.")
union MigrationStrategy {
  @doc("Modernize the workload to a managed or PaaS target.")
  Modernize: "Modernize",

  @doc("Migrate the workload to Azure VMware Solution (AVS).")
  AVS: "AVS",

  @doc("Lift and shift the workload to Azure IaaS.")
  LiftAndShift: "LiftAndShift",

  string,
}

@doc("The type of a Migrate plan. Data center is the first supported kind; the type is extensible so additional plan kinds can be introduced in future versions.")
union PlanType {
  @doc("A data center plan spanning the full set of plan artifacts for a Migrate project.")
  DataCenter: "DataCenter",

  string,
}
