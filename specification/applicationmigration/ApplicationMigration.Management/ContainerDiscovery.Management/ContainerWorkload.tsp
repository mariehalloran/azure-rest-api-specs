import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ContainerSite.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.ApplicationMigration;

/**
 * The ContainerWorkload resource — UNIFIED proxy resource for both orchestrated pods
 * and standalone containers. Replaces the former ContainerInstance resource.
 * Child of ContainerSite (NOT child of ContainerCluster — enables standalone scenario).
 */
@parentResource(ContainerSite)
model ContainerWorkload is Azure.ResourceManager.ProxyResource<
  ContainerWorkloadProperties,
  false
> {
  ...ResourceNameParameter<
    Resource = ContainerWorkload,
    KeyName = "workloadName",
    SegmentName = "containerWorkloads",
    NamePattern = "^[a-zA-Z0-9]([a-zA-Z0-9_-]*[a-zA-Z0-9])?$"
  >;
}

/**
 * ContainerWorkload properties — unified for orchestrated + standalone.
 */
model ContainerWorkloadProperties is AzureResourceProperties {
  // ── Scenario Discriminator ──
  @doc("Discriminator: orchestrated (K8s pods) or standalone (Docker/Podman).")
  workloadScenario?: WorkloadScenario;

  @doc("Workload type denormalized from parent cluster orchestrator for portal display.")
  workloadType?: WorkloadType;

  // ── Cluster Back-Reference (orchestrated only) ──
  @doc("ARM resource ID of parent cluster (empty for standalone).")
  clusterArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ApplicationMigration/containerSites/containerClusters";
    }
  ]>;

  @doc("Cluster identifier.") clusterId?: string;
  @doc("Parent cluster name.") parentClusterName?: string;

  // ── Node Back-References ──
  @doc("Node IDs this workload runs on.")
  nodeIds?: string[];

  @doc("ARM resource ID of the parent node (standalone only).")
  parentNodeArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ApplicationMigration/containerSites/containerNodes";
    }
  ]>;

  // ── Software & Discovery Metadata ──
  @doc("Software attributes.") softwareAttributes?: SoftwareAttributes;

  @doc("Support status.") supportStatus?: SupportStatus;
  @doc("End of support date.") endOfSupportDate?: plainDate;
  @doc("Discovery source.") discoverySource?: string;
  @doc("Appliance name.") applianceName?: string;
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Tags are ARM standard key-value pairs"
  @doc("Resource tags as key-value pairs.") tags?: Record<string>;

  // ── Discovery Metadata ──
  @doc("Discovery completeness level.")
  discoveryCompleteness?: DiscoveryCompleteness;

  @doc("Whether shallow discovery has completed.") isShallowCompleted?: boolean;

  @doc("Whether deep discovery has completed.")
  isDeepDiscoveryCompleted?: boolean;

  // ── Workload Identity (Orchestrated only — empty for standalone) ──
  @encodedName("application/json", "namespace")
  @doc("Namespace (empty for standalone).")
  workloadNamespace?: string;

  @doc("Namespace labels as key-value pairs.")
  @identifiers(#[])
  namespaceLabels?: KeyValuePair[];

  @doc("Namespace annotations as key-value pairs.")
  @identifiers(#[])
  namespaceAnnotations?: KeyValuePair[];

  @doc("Controller type.") controllerType?: ControllerType;
  @doc("Controller name.") controllerName?: string;

  @doc("Controller labels as key-value pairs.")
  @identifiers(#[])
  controllerLabels?: KeyValuePair[];

  @doc("Controller annotations as key-value pairs.")
  @identifiers(#[])
  controllerAnnotations?: KeyValuePair[];

  @doc("Workload status.") workloadStatus?: WorkloadStatus;
  @doc("Creation timestamp.") creationTimestamp?: utcDateTime;
  @doc("Current replicas.") replicasCurrent?: int32;
  @doc("Desired replicas.") replicasDesired?: int32;

  // ── Application Grouping ──
  @doc("Application group identifier.") applicationGroupId?: string;

  @doc("How applicationGroupId was derived.")
  applicationGroupSource?: ApplicationGroupSource;

  @doc("Pod template labels (spec.template.metadata.labels).")
  @identifiers(#[])
  podTemplateLabels?: KeyValuePair[];

  @doc("Selector labels (spec.selector.matchLabels).")
  @identifiers(#[])
  selectorLabels?: KeyValuePair[];

  @doc("Pod annotations as key-value pairs.")
  @identifiers(#[])
  podAnnotations?: KeyValuePair[];

  // ── Matching Services & Ingresses (Orchestrated only — empty for standalone) ──
  @doc("K8s Services selecting this workload.")
  @identifiers(#[])
  matchingServices?: MatchingServiceInfo[];

  @doc("Ingresses routing to this workload.")
  @identifiers(#[])
  matchingIngresses?: MatchingIngressInfo[];

  @doc("OpenShift Routes routing to this workload.")
  @identifiers(#[])
  matchingRoutes?: MatchingRouteInfo[];

  @doc("Gateway API HTTPRoutes routing to this workload.")
  @identifiers(#[])
  matchingGatewayRoutes?: MatchingGatewayRouteInfo[];

  // ── Assessment Summaries ──
  @doc("Pre-computed workload summary.") workloadSummary?: WorkloadSummary;

  @doc("Migration readiness signals (24 booleans).")
  readinessSignals?: ReadinessSignals;

  @doc("Network exposure summary.") networkExposure?: NetworkExposureSummary;

  @doc("Network policies affecting this workload.")
  networkPolicies?: NetworkPolicySummary;

  @doc("Storage summary.") storageSummary?: StorageSummary;
  @doc("Operations profile.") operationsProfile?: OperationsProfile;

  @doc("Dependency summary for migration wave planning.")
  dependencySummary?: DependencySummary;

  // ── Container Details ──
  // Orchestrated: slim container specs (image, resources, probes). Standalone fields inside ContainerDetail are empty.
  // Standalone: full container details including state, command, labels, volumes, networks.
  @doc("Container details (full for standalone, slim for orchestrated).")
  @identifiers(#[])
  containers?: ContainerDetail[];

  // ── Standalone-Only Sections ──
  @doc("Standalone container grouping signals.")
  containerGroupSignals?: ContainerGroupSignals;

  // ── Errors ──
  @doc("Discovery or processing errors for this workload.")
  @identifiers(#[])
  errors?: ContainerDiscoveryError[];

  @doc("The number of critical errors.") criticalErrorCount?: int64;
  @doc("The number of warnings.") warningsCount?: int64;
}

// ── Enums ──
@doc("Workload scenario discriminator.")
union WorkloadScenario {
  string,
  @doc("Orchestrated by K8s/Swarm.") Orchestrated: "orchestrated",
  @doc("Standalone Docker/Podman.") Standalone: "standalone",
}

@doc("Workload type denormalized from parent cluster orchestrator.")
union WorkloadType {
  string,
  @doc("Kubernetes workload.") Kubernetes: "Kubernetes",
  @doc("OpenShift workload.") OpenShift: "OpenShift",
  @doc("VMware Tanzu workload.") TKG: "TKG",
  @doc("Docker Swarm workload.") DockerSwarm: "DockerSwarm",
  @doc("Standalone container workload.") Standalone: "Standalone",
}

@doc("Controller type.")
union ControllerType {
  string,
  @doc("Kubernetes Deployment controller.") Deployment: "deployment",
  @doc("Kubernetes StatefulSet controller.") StatefulSet: "statefulset",
  @doc("Kubernetes DaemonSet controller.") DaemonSet: "daemonset",
  @doc("Kubernetes Job controller.") Job: "job",
  @doc("Kubernetes CronJob controller.") CronJob: "cronjob",
  @doc("Kubernetes ReplicaSet controller.") ReplicaSet: "replicaset",

  @doc("OpenShift DeploymentConfig controller.")
  DeploymentConfig: "deploymentconfig",

  @doc("Docker Swarm replicated service.") SwarmReplicated: "swarm-replicated",
  @doc("Docker Swarm global service.") SwarmGlobal: "swarm-global",
  @doc("None (standalone).") None: "none",
}

@doc("Workload status.")
union WorkloadStatus {
  string,
  @doc("The workload is currently running.") Running: "running",
  @doc("The workload is scheduled but not yet running.") Pending: "pending",
  @doc("The workload completed successfully.") Succeeded: "succeeded",
  @doc("The workload terminated with a failure.") Failed: "failed",
  @doc("The workload state could not be determined.") Unknown: "unknown",
}

// ── Sub-Models ──
@doc("Service matching this workload.")
model MatchingServiceInfo {
  @doc("Service name.") serviceName?: string;
  @doc("Service namespace.") serviceNamespace?: string;
  @doc("Service type.") serviceType?: string;

  @doc("Selector labels as key-value pairs.")
  @identifiers(#[])
  selectorLabels?: KeyValuePair[];

  @doc("Service ports exposed by this service.")
  @identifiers(#[])
  ports?: ServicePortInfo[];

  @doc("Load balancer IP address.") loadBalancerIp?: string;
  @doc("External traffic policy.") externalTrafficPolicy?: string;
  @doc("Cluster-internal IP address.") clusterIp?: string;
}

@doc("Service port info.")
model ServicePortInfo {
  @doc("Port name.") name?: string;
  @doc("Transport protocol (for example, TCP or UDP).") protocol?: string;
  @doc("Port number.") port?: int32;
  @doc("Target port.") targetPort?: int32;
  @doc("Node port.") nodePort?: int32;
}

@doc("Ingress matching this workload.")
model MatchingIngressInfo {
  @doc("Ingress name.") ingressName?: string;
  @doc("Ingress namespace.") ingressNamespace?: string;
  @doc("Ingress class.") ingressClassName?: string;

  @doc("Ingress routing rules.")
  @identifiers(#[])
  rules?: IngressRuleInfo[];

  @doc("Has TLS.") hasTls?: boolean;
  @doc("TLS secret ref.") tlsSecretRef?: string;
}

@doc("OpenShift Route matching this workload.")
model MatchingRouteInfo {
  @doc("Route name.") routeName?: string;
  @doc("Route namespace.") routeNamespace?: string;
  @doc("Route hostname.") host?: string;
  @doc("Route path.") path?: string;

  @doc("TLS termination type (edge, passthrough, reencrypt).")
  tlsTermination?: string;

  @doc("Backend service name.") targetServiceName?: string;
  @doc("Backend port.") targetPort?: string;
  @doc("Wildcard policy.") wildcardPolicy?: string;
}

@doc("Ingress rule.")
model IngressRuleInfo {
  @doc("Hostname for the ingress rule (e.g., example.com).") host?: string;
  @doc("URL path for the ingress rule (e.g., /api).") path?: string;

  @doc("Path matching type (Prefix, Exact, ImplementationSpecific).")
  pathType?: string;

  @doc("Name of the backend Kubernetes service.") backendServiceName?: string;

  @doc("Namespace of the backend Kubernetes service.")
  backendServiceNamespace?: string;

  @doc("Numeric port of the backend service.") backendServicePortNumber?: int32;
  @doc("Named port of the backend service.") backendServicePortName?: string;
}

@doc("Gateway API route matching this workload.")
model MatchingGatewayRouteInfo {
  @doc("Route resource name.") routeName?: string;
  @doc("Route namespace.") routeNamespace?: string;
  @doc("Parent Gateway name.") parentGatewayName?: string;
  @doc("Parent Gateway namespace.") parentGatewayNamespace?: string;

  @doc("Route type (HTTPRoute, GRPCRoute, TCPRoute, TLSRoute).")
  routeType?: string;

  @doc("Hostnames from the route spec.") hostnames?: string[];
  @doc("URL path match value.") path?: string;

  @doc("Path match type (PathPrefix, Exact, RegularExpression).")
  pathType?: string;

  @doc("Backend service name.") backendServiceName?: string;
  @doc("Backend service namespace.") backendServiceNamespace?: string;
  @doc("Backend service port number.") backendServicePortNumber?: int32;
  @doc("Backend service port name.") backendServicePortName?: string;

  @doc("Traffic weight for this backend (0-100, for traffic splitting).")
  backendWeight?: int32;
}

@doc("Workload summary for quick assessment.")
model WorkloadSummary {
  @doc("Container count.") containerCount?: int32;
  @doc("Init container count.") initContainerCount?: int32;
  @doc("Total CPU request.") totalCpuRequest?: string;
  @doc("Total CPU limit.") totalCpuLimit?: string;
  @doc("Total memory request.") totalMemoryRequest?: string;
  @doc("Total memory limit.") totalMemoryLimit?: string;
  @doc("Has GPU requests.") hasGpuRequests?: boolean;
  @doc("Distinct images.") distinctImages?: string[];

  @doc("Image CPU architectures (e.g., amd64, arm64).")
  imageArchitectures?: string[];

  @doc("Distinct ConfigMap references across all containers in this workload.")
  configMapRefCount?: int32;

  @doc("Distinct Secret references across all containers in this workload.")
  secretRefCount?: int32;

  @doc("Secret types referenced by this workload (e.g., Opaque, kubernetes.io/tls, kubernetes.io/dockerconfigjson).")
  secretTypes?: string[];

  @doc("Whether this workload references external secret providers (e.g., ExternalSecret CRD, CSI SecretProviderClass).")
  hasExternalSecrets?: boolean;
}

@doc("Migration readiness signals (24 booleans).")
model ReadinessSignals {
  @doc("Uses host network.") usesHostNetwork?: boolean;
  @doc("Uses host PID.") usesHostPid?: boolean;
  @doc("Uses host IPC.") usesHostIpc?: boolean;
  @doc("Has privileged containers.") hasPrivilegedContainers?: boolean;
  @doc("Has root containers.") hasRootContainers?: boolean;
  @doc("Mounts docker socket.") mountsDockerSocket?: boolean;
  @doc("Uses node selector.") usesNodeSelector?: boolean;
  @doc("Has node affinity.") hasNodeAffinity?: boolean;
  @doc("Has pod anti-affinity.") hasPodAntiAffinity?: boolean;
  @doc("Has topology spread.") hasTopologySpreadConstraints?: boolean;
  @doc("Has tolerations.") hasTolerations?: boolean;
  @doc("Has Windows containers.") hasWindowsContainers?: boolean;
  @doc("Uses secrets.") usesSecrets?: boolean;
  @doc("Uses ConfigMaps.") usesConfigMaps?: boolean;
  @doc("Has private registry.") hasPrivateRegistry?: boolean;
  @doc("Has HPA.") hasHpa?: boolean;
  @doc("Has VPA.") hasVpa?: boolean;
  @doc("Has PDB.") hasPdb?: boolean;
  @doc("Has ingress rules.") hasIngressRules?: boolean;
  @doc("Has liveness probes.") hasLivenessProbes?: boolean;
  @doc("Has readiness probes.") hasReadinessProbes?: boolean;
  @doc("Exposes multiple ports.") exposesMultiplePorts?: boolean;
}

@doc("Network exposure summary.")
model NetworkExposureSummary {
  @doc("Service types.") serviceTypes?: string[];
  @doc("Load balancer count.") loadBalancerCount?: int32;
  @doc("NodePort count.") nodePortCount?: int32;
  @doc("ClusterIP count.") clusterIpCount?: int32;
  @doc("Ingress count.") ingressCount?: int32;
  @doc("Has TLS.") hasTls?: boolean;
  @doc("Network mode (standalone).") networkMode?: string;
}

@doc("Network policy summary.")
model NetworkPolicySummary {
  @doc("Has network policy.") hasNetworkPolicy?: boolean;

  @doc("Allowed ingress.")
  @identifiers(#[])
  allowedIngress?: NetworkPolicyRule[];

  @doc("Allowed egress.")
  @identifiers(#[])
  allowedEgress?: NetworkPolicyRule[];
}

@doc("Network policy rule.")
model NetworkPolicyRule {
  @doc("From/to labels as key-value pairs.")
  @identifiers(#[])
  labels?: KeyValuePair[];

  @doc("Kubernetes namespaces in the policy scope.")
  namespaces?: string[];

  @doc("Port numbers included in the policy rule.")
  ports?: int32[];
}

@doc("Storage summary.")
model StorageSummary {
  @doc("Volume types.") volumeTypes?: string[];
  @doc("Volume drivers used.") volumeDrivers?: string[];
  @doc("Storage classes used.") storageClassesUsed?: string[];
  @doc("CSI drivers used.") csiDriversUsed?: string[];
  @doc("PVC count.") pvcCount?: int32;
  @doc("Total PVC size GB.") totalPvcSizeGb?: float64;
  @doc("Has host path volumes.") hasHostPathVolumes?: boolean;
  @doc("Has emptyDir memory.") hasEmptyDirMemory?: boolean;

  @doc("PVC access modes used by this workload (e.g., ReadWriteOnce, ReadWriteMany, ReadOnlyMany).")
  pvcAccessModes?: string[];
}

@doc("Operations profile.")
model OperationsProfile {
  @doc("Update strategy.") updateStrategy?: string;
  @doc("Service account name.") serviceAccountName?: string;
  @doc("Restart policy.") restartPolicy?: string;
  @doc("Termination grace period.") terminationGracePeriodSeconds?: int32;
  @doc("Priority class name.") priorityClassName?: string;
}

@doc("Dependency summary.")
model DependencySummary {
  @doc("Inbound service count.") inboundServiceCount?: int32;
  @doc("Outbound service count.") outboundServiceCount?: int32;
  @doc("External endpoint count.") outboundExternalEndpointCount?: int32;
  @doc("Inbound service names.") inboundServiceNames?: string[];
  @doc("Outbound service names.") outboundServiceNames?: string[];

  @doc("External endpoints.")
  outboundExternalEndpoints?: string[];
}

@doc("Container detail.")
model ContainerDetail {
  @doc("Container ID.") containerId?: string;
  @doc("Container name.") containerName?: string;
  @doc("Container image.") containerImage?: ContainerImageProperties;
  @doc("Whether this is an init container.") isInitContainer?: boolean;
  @doc("Resource allocation.") resourceAllocation?: ContainerResourceAllocation;
  @doc("Security context.") securityContext?: ContainerSecurityContext;
  @doc("Mounts docker socket.") mountsDockerSocket?: boolean;
  @doc("Health probes.") healthProbes?: ContainerHealthProbes;

  @doc("Container port mappings.")
  @identifiers(#[])
  ports?: ContainerPortMapping[];

  // Standalone-only fields
  @doc("Container state (standalone).") state?: ContainerState;

  @doc("Container creation timestamp (standalone).") createdAt?: utcDateTime;
  @doc("Container start timestamp (standalone).") startedAt?: utcDateTime;
  @doc("Container restart count (standalone).") restartCount?: int32;
  @doc("Container restart policy (standalone).") restartPolicy?: string;
  @doc("Container command (standalone).") containerCommand?: ContainerCommand;

  @doc("Container labels (standalone) as key-value pairs.")
  @identifiers(#[])
  containerLabels?: KeyValuePair[];

  @doc("Volume mounts (standalone).")
  @identifiers(#[])
  volumeMounts?: ContainerVolumeMount[];

  @doc("Network mode (standalone).") networkMode?: NetworkMode;

  @doc("Container networks (standalone).")
  @identifiers(#[])
  containerNetworks?: ContainerNetworkInfo[];

  @doc("Resource usage snapshot (standalone).") resourceUsage?: ResourceMetrics;
  @doc("Health check (standalone).") healthCheck?: ContainerHealthCheck;
}

@doc("Container health probes (orchestrated).")
model ContainerHealthProbes {
  @doc("Has liveness probe.") hasLivenessProbe?: boolean;
  @doc("Has readiness probe.") hasReadinessProbe?: boolean;
  @doc("Has startup probe.") hasStartupProbe?: boolean;
}

/**
 * Patch envelope for ContainerWorkload.
 */
model ContainerWorkloadPatchProperties {
  @doc("Container workload patch properties.")
  properties?: ContainerWorkloadPatch;
}

/**
 * Patch properties for ContainerWorkload.
 */
model ContainerWorkloadPatch {
  @doc("Node IDs this workload runs on.")
  nodeIds?: string[];

  @doc("ARM resource ID of the parent node (standalone only).")
  parentNodeArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.ApplicationMigration/containerSites/containerNodes";
    }
  ]>;

  @doc("Software attributes.") softwareAttributes?: SoftwareAttributes;
  @doc("Support status.") supportStatus?: SupportStatus;
  @doc("End of support date.") endOfSupportDate?: plainDate;

  @doc("Discovery completeness level.")
  discoveryCompleteness?: DiscoveryCompleteness;

  @doc("Whether shallow discovery has completed.") isShallowCompleted?: boolean;

  @doc("Whether deep discovery has completed.")
  isDeepDiscoveryCompleted?: boolean;

  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "Tags are ARM standard key-value pairs"
  @doc("Resource tags as key-value pairs.") tags?: Record<string>;

  @doc("Namespace labels as key-value pairs.")
  @identifiers(#[])
  namespaceLabels?: KeyValuePair[];

  @doc("Namespace annotations as key-value pairs.")
  @identifiers(#[])
  namespaceAnnotations?: KeyValuePair[];

  @doc("Controller labels as key-value pairs.")
  @identifiers(#[])
  controllerLabels?: KeyValuePair[];

  @doc("Controller annotations as key-value pairs.")
  @identifiers(#[])
  controllerAnnotations?: KeyValuePair[];

  @doc("Workload status.") workloadStatus?: WorkloadStatus;
  @doc("Current replica count.") replicasCurrent?: int32;
  @doc("Desired replica count.") replicasDesired?: int32;
  @doc("Application group identifier.") applicationGroupId?: string;

  @doc("Pod template labels.")
  @identifiers(#[])
  podTemplateLabels?: KeyValuePair[];

  @doc("Selector labels.")
  @identifiers(#[])
  selectorLabels?: KeyValuePair[];

  @doc("Pod annotations.")
  @identifiers(#[])
  podAnnotations?: KeyValuePair[];

  @doc("Matching services.")
  @identifiers(#[])
  matchingServices?: MatchingServiceInfo[];

  @doc("Matching ingresses.")
  @identifiers(#[])
  matchingIngresses?: MatchingIngressInfo[];

  @doc("OpenShift Routes.")
  @identifiers(#[])
  matchingRoutes?: MatchingRouteInfo[];

  @doc("Gateway API HTTPRoutes.")
  @identifiers(#[])
  matchingGatewayRoutes?: MatchingGatewayRouteInfo[];

  @doc("Pre-computed workload summary.") workloadSummary?: WorkloadSummary;
  @doc("Migration readiness signals.") readinessSignals?: ReadinessSignals;
  @doc("Network exposure summary.") networkExposure?: NetworkExposureSummary;
  @doc("Network policies.") networkPolicies?: NetworkPolicySummary;
  @doc("Storage summary.") storageSummary?: StorageSummary;
  @doc("Operations profile.") operationsProfile?: OperationsProfile;
  @doc("Dependency summary.") dependencySummary?: DependencySummary;

  @doc("List of containers discovered for the workload.")
  @identifiers(#[])
  containers?: ContainerDetail[];

  @doc("Standalone container grouping signals.")
  containerGroupSignals?: ContainerGroupSignals;

  @doc("Discovery or processing errors.")
  @identifiers(#[])
  errors?: ContainerDiscoveryError[];

  @doc("The number of critical errors.") criticalErrorCount?: int64;
  @doc("The number of warnings.") warningsCount?: int64;
}

@armResourceOperations
interface ContainerWorkloads {
  get is ArmResourceRead<ContainerWorkload>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<ContainerWorkload>;
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    ContainerWorkload,
    ContainerWorkloadPatchProperties
  >;
  delete is ArmResourceDeleteSync<ContainerWorkload>;
  listBySite is ArmResourceListByParent<
    ContainerWorkload,
    Response = ArmResponse<ContainerWorkloadList>
  >;
}

@@maxLength(ContainerWorkload.name, 253);
@@minLength(ContainerWorkload.name, 1);
@@doc(ContainerWorkload.name, "The workload identifier.");
@@doc(ContainerWorkload.properties, "Container workload properties.");
@@doc(
  ContainerWorkloads.createOrUpdate::parameters.resource,
  "The container workload resource."
);
@@doc(
  ContainerWorkloads.update::parameters.properties,
  "Container workload patch payload."
);
