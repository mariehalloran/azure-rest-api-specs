import "../Enums/Enums.tsp";

namespace Microsoft.Migrate;

@doc("Domain Services configuration. Required when IdentityConfig.provider is EntraIdWithDomainServices or HybridAdDs.")
model DomainServicesConfig {
  @doc("Fully qualified DNS domain name, for example \"contoso.local\".")
  domainName: string;

  @doc("CIDR for the subnet hosting domain controllers or Azure AD Domain Services.")
  subnetAddressPrefix: string;
}

@doc("Identity configuration for the landing zone.")
model IdentityConfig {
  @doc("Identity provider strategy.")
  provider: IdentityProvider;

  @doc("Domain Services configuration. Required when provider is EntraIdWithDomainServices or HybridAdDs; ignored when provider is EntraIdOnly.")
  domainServices?: DomainServicesConfig;
}
