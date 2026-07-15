namespace Microsoft.Migrate;

@doc("Security configuration produced by the stock ALZ policy baseline.")
model Security {
  @doc("Whether Microsoft Defender for Cloud configuration is enabled through the stock ALZ policy assignment.")
  defenderForCloudEnabled?: boolean;

  @doc("Security contact email. Omitted until the caller supplies a real address.")
  securityContactEmail?: string;
}
