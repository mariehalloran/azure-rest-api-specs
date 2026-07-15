namespace Microsoft.Migrate;

@doc("Security configuration produced by the stock Azure Landing Zones policy baseline.")
model Security {
  @doc("Whether Microsoft Defender for Cloud configuration is enabled through the stock Azure Landing Zones policy assignment.")
  defenderForCloudEnabled?: boolean;

  @doc("Security contact email. Omitted until the caller supplies a real address.")
  securityContactEmail?: string;
}
