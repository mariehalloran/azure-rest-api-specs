namespace Microsoft.Migrate;

@doc("Security configuration for the platform landing zone.")
model Security {
  @doc("Whether Microsoft Defender for Cloud configuration is enabled.")
  defenderForCloudEnabled?: boolean;

  @doc("Security contact email. Omitted until the caller supplies a real address.")
  securityContactEmail?: string;
}
