import "@typespec/http";
import "@typespec/rest";
import "@azure-tools/typespec-azure-resource-manager";
import "./common.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;

namespace Microsoft.SecurityContext;

/** A network endpoint or service observed as reachable from the internet. */
@tenantResource
model InternetExposure is ProxyResource<InternetExposureProperties, false> {
  /** The stable human-readable resource name: `{source-system-slug}--{source-record-slug}`. */
  @key("internetExposureName")
  @path
  @segment("internetExposures")
  @visibility(Lifecycle.Read)
  @minLength(4)
  @maxLength(256)
  @pattern("^[a-z0-9]+(?:-[a-z0-9]+)*--[a-z0-9]+(?:-[a-z0-9]+)*$")
  name: string;

  /** The fully qualified ARM resource ID. */
  @visibility(Lifecycle.Read)
  id: Azure.Core.armResourceIdentifier;

  /** The ARM resource type. */
  @visibility(Lifecycle.Read)
  type: Azure.Core.armResourceType;

  /** ARM metadata for resource creation and modification. */
  @visibility(Lifecycle.Read)
  systemData: Azure.ResourceManager.CommonTypes.SystemData;
}

/** Properties of an internet exposure observation. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "This read-only observation is computed by the service and is not provisioned through ARM."
model InternetExposureProperties {
  ...ObservationProperties;

  /** The source-defined type of exposure. */
  @visibility(Lifecycle.Read)
  @minLength(1)
  @maxLength(128)
  exposureType: string;

  /** The transport protocol on which the endpoint was observed. */
  @visibility(Lifecycle.Read)
  transportProtocol?: TransportProtocol;

  /** The application protocol identified on the endpoint. */
  @visibility(Lifecycle.Read)
  @maxLength(128)
  applicationProtocol?: string;

  /** The network port on which the endpoint was observed. */
  @visibility(Lifecycle.Read)
  @minValue(0)
  @maxValue(65535)
  port?: int32;

  /** The source-defined scan or observation method. */
  @visibility(Lifecycle.Read)
  @minLength(1)
  @maxLength(128)
  scanType: string;

  /** The source confidence in the observation, from zero through one. */
  @visibility(Lifecycle.Read)
  @minValue(0)
  @maxValue(1)
  confidence?: float32;

  /** A privacy-preserving SHA-256 fingerprint of the observed endpoint. */
  @visibility(Lifecycle.Read)
  @minLength(64)
  @maxLength(64)
  @pattern("^[0-9a-f]{64}$")
  endpointFingerprint?: string;
}

/** Read-only operations for internet exposure observations. */
@armResourceOperations
interface InternetExposures {
  /** Gets an internet exposure observation. */
  get is ArmResourceRead<InternetExposure>;

  /** Lists internet exposure observations in the tenant. */
  list is ArmResourceListByParent<
    InternetExposure,
    Azure.ResourceManager.Foundations.TenantBaseParameters
  >;
}
