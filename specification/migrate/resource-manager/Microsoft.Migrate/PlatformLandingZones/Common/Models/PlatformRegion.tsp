import "../Enums/Enums.tsp";
import "./NetworkTypes.tsp";

namespace Microsoft.Migrate;

@doc("Address space allocated to platform services in a given region.")
model RegionAddressSpace {
  @doc("Address space allocated for hub virtual networks in this region, in Classless Inter-Domain Routing notation.")
  hub?: Ipv4CidrPrefix;
}

@doc("An Azure region included in the landing zone design.")
model PlatformRegion {
  @doc("Azure region name, for example \"eastus\".")
  name: string;

  @doc("Role of this region within the landing zone.")
  role?: RegionRole;

  @doc("Address space allocated to platform services in this region.")
  addressSpace?: RegionAddressSpace;

  @doc("Availability zones in this region that the landing zone targets, for example [\"1\",\"2\",\"3\"]. Empty when the region does not support availability zones or zonal deployment is not desired.")
  availabilityZones?: string[];

  @doc("Connectivity resources deployed in this region.")
  connectivityDeploymentMode?: RegionalConnectivityDeploymentMode;
}
