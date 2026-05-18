import "../Enums/Enums.tsp";

namespace Microsoft.Migrate;

@doc("Address space allocated to platform services in a given region.")
model RegionAddressSpace {
  @doc("Address space allocated for hub virtual networks in this region, in CIDR notation.")
  hub: string;

  @doc("Address space allocated for spoke virtual networks in this region, in CIDR notation.")
  spoke: string;
}

@doc("An Azure region included in the landing zone design.")
model PlatformRegion {
  @doc("Azure region name, for example \"eastus\".")
  name: string;

  @doc("Role of this region within the landing zone.")
  role: RegionRole;

  @doc("Address space allocated to platform services in this region.")
  addressSpace: RegionAddressSpace;

  @doc("Availability zones in this region that the landing zone targets, for example [\"1\",\"2\",\"3\"]. Empty when the region does not support availability zones or zonal deployment is not desired.")
  availabilityZones?: string[];

  @doc("Whether a connectivity hub (or VirtualWan virtual hub) is deployed in this region. Defaults to true. Set to false for regions that are pure DR targets and rely on hubs in other regions.")
  deployHub?: boolean;

  @doc("Whether the per-region sidecar VNet (used for shared platform services such as DNS resolvers or NVA management) is deployed in this region. Defaults to true.")
  deploySidecar?: boolean;
}
