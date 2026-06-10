import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Rest;
using Http;
using Azure.Core;
using Azure.ResourceManager;

namespace Microsoft.AAD;

/** Entra Resilience Service. Parent resource that aggregates one or more resilience hosts and provides the shared infrastructure that those hosts rely on. */
model ResilienceService is TrackedResource<ResilienceProperties> {
  ...ResourceNameParameter<ResilienceService>;
}

/** Resilience properties */
model ResilienceProperties {
  /** The status of the last operation. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** Configuration for the customer attestation service used by hosts in this resilience service. Populated by the service after host attestation; not writable by clients. */
  @visibility(Lifecycle.Read)
  attestationService?: AttestationServiceConfig;
}

/** Configuration for the customer attestation service. Fields are populated by the service after the first host attests successfully. */
model AttestationServiceConfig {
  /** IP address of the attestation service. */
  @visibility(Lifecycle.Read)
  ipAddress?: string;

  /** Domain name of the attestation service. */
  @visibility(Lifecycle.Read)
  domainName?: string;
}

/** Entra Resilience Host. Child resource representing a physical host running the nested virtual machine, attached to a parent Entra Resilience Service. */
@parentResource(ResilienceService)
model ResilienceHost is ProxyResource<ResilienceHostProperties> {
  ...ResourceNameParameter<ResilienceHost, SegmentName = "hosts">;
}

/** Resilience host properties. */
model ResilienceHostProperties {
  /** The Azure Resource Manager (ARM) resource ID of the Azure Arc machine that hosts the nested virtual machine. Immutable after the host is created; to point at a different Arc machine, delete and recreate the host. */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  arcMachineResourceId: armResourceIdentifier<[
    {
      type: "Microsoft.HybridCompute/machines";
      scopes: ["Tenant"];
    }
  ]>;

  /** The status of the last operation on this host. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /** Storage configuration for the resilience host. */
  storage?: HostStorageConfig;

  /** Network configuration for the resilience host. */
  network: HostNetworkConfig;
}

/** Storage configuration for a resilience host. */
model HostStorageConfig {
  /** Optional folder under which to install the resilience service. Immutable after the host is created. */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  rootFolder?: string;
}

/** Network configuration for a resilience host. */
model HostNetworkConfig {
  /** Network mode. 'default' uses NAT and ignores the other network fields; 'custom' uses the supplied network settings. */
  mode?: NetworkMode;

  /** Name of the internet switch the nested virtual machine is connected to. Required when mode is 'custom'. */
  internetSwitchName?: string;

  /** IPv4 address of the nested virtual machine. Required when mode is 'custom'. */
  ipV4Address?: string;

  /** Subnet mask of the nested virtual machine. Required when mode is 'custom'. */
  netMask?: string;

  /** Gateway IPv4 address of the nested virtual machine. Required when mode is 'custom'. */
  gatewayIpV4Address?: string;

  /** Primary DNS IPv4 address. Required when mode is 'custom'. */
  primaryDnsIpV4Address?: string;

  /** Alternate DNS IPv4 address. Optional when mode is 'custom'. */
  alternateDnsIpV4Address?: string;
}

/** Network mode for a resilience host. */
union NetworkMode {
  /** Default network mode; the host uses NAT and other network fields are ignored. */
  Default: "default",

  /** Custom network mode; the host uses the supplied network settings. */
  Custom: "custom",

  string,
}

/** The resource provisioning state. */
@lroStatus
union ProvisioningState {
  ResourceProvisioningState,

  /** The resource is being provisioned */
  Provisioning: "Provisioning",

  /** The resource is updating */
  Updating: "Updating",

  /** The resource is being deleted */
  Deleting: "Deleting",

  /** The resource create request has been accepted */
  Accepted: "Accepted",

  string,
}

@armResourceOperations
interface ResilienceServices {
  get is ArmResourceRead<ResilienceService>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ResilienceService>;
  update is ArmCustomPatchSync<
    ResilienceService,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      ResilienceService,
      ResilienceProperties
    >
  >;
  delete is ArmResourceDeleteWithoutOkAsync<ResilienceService>;
  listByResourceGroup is ArmResourceListByParent<ResilienceService>;
  listBySubscription is ArmListBySubscription<ResilienceService>;
}

@armResourceOperations
interface ResilienceHosts {
  get is ArmResourceRead<ResilienceHost>;
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ResilienceHost>;
  update is ArmCustomPatchSync<
    ResilienceHost,
    Azure.ResourceManager.Foundations.ResourceUpdateModel<
      ResilienceHost,
      ResilienceHostProperties
    >
  >;
  delete is ArmResourceDeleteWithoutOkAsync<ResilienceHost>;
  listByParent is ArmResourceListByParent<ResilienceHost>;
}
