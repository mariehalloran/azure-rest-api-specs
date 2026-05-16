import "@azure-tools/typespec-azure-resource-manager";
import "../Enums/Enums.tsp";

using Azure.ResourceManager;

namespace Microsoft.Migrate;

@doc("Microsoft Defender for Cloud plan setting.")
model DefenderPlanSetting {
  @doc("Defender plan to configure.")
  name: DefenderPlanName;

  @doc("Plan tier.")
  tier: DefenderPlanTier;
}

@doc("Key Vault configuration.")
model KeyVaultConfig {
  @doc("Key Vault kind.")
  kind: KeyVaultKind;

  @doc("Whether RBAC authorization is enabled (required for ALZ baseline).")
  rbacAuthorizationEnabled: boolean;

  @doc("Whether purge protection is enabled.")
  purgeProtectionEnabled: boolean;

  @doc("Soft-delete retention in days.")
  @minValue(7)
  @maxValue(90)
  softDeleteRetentionInDays: int32;
}

@doc("Customer-managed key configuration for platform service encryption.")
model CustomerManagedKeyConfig {
  @doc("Key Vault resource id holding the encryption key.")
  keyVaultId: string;

  @doc("Key name.")
  keyName: string;

  @doc("Key version. Omit for auto-rotation to the latest version.")
  keyVersion?: string;
}

@doc("Encryption configuration for platform services.")
model EncryptionConfig {
  @doc("Whether customer-managed keys are used. When false, Microsoft-managed keys are used.")
  customerManagedKeyEnabled: boolean;

  @doc("Customer-managed key configuration. Required when customerManagedKeyEnabled is true.")
  customerManagedKey?: CustomerManagedKeyConfig;
}

@doc("Security configuration for the landing zone.")
model Security {
  @doc("Microsoft Defender for Cloud plan settings.")
  @identifiers(#["name"])
  defenderPlans: DefenderPlanSetting[];

  @doc("Key Vault configuration for the landing zone.")
  keyVault: KeyVaultConfig;

  @doc("Encryption configuration for platform services.")
  encryption?: EncryptionConfig;
}
