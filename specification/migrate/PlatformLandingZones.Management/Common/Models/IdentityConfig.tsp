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

  @doc("Whether Microsoft Entra Connect (or Microsoft Entra Cloud Sync) is used to synchronize on-premises identities. Only meaningful when provider is HybridAdDs.")
  entraConnectEnabled?: boolean;

  @doc("Whether Microsoft Entra Privileged Identity Management (PIM) is enabled for just-in-time elevation of privileged roles.")
  privilegedIdentityManagementEnabled?: boolean;

  @doc("Whether Conditional Access policies are enforced for landing-zone administrators.")
  conditionalAccessEnabled?: boolean;

  @doc("Whether multi-factor authentication is required for all administrative accounts.")
  mfaForAdminsEnabled?: boolean;

  @doc("Number of break-glass (emergency access) accounts to provision. Microsoft recommends at least 2.")
  @minValue(0)
  @maxValue(10)
  breakGlassAccountCount?: int32;
}
