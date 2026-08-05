import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.ApplicationMigration;

// ═══════════════════════════════════════════════════════════════════════════════
// COMMON MODELS
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Base tracked resource type for PATCH updates.")
model TagsUpdate {
  ...ArmTagsProperty;
}

@doc("The status of the current operation.")
union ProvisioningState {
  ResourceProvisioningState,
  @doc("Creating provisioning state.") Creating: "Creating",
  @doc("Deleting provisioning state.") Deleting: "Deleting",
  @doc("Updating provisioning state.") Updating: "Updating",
}

@doc("Common properties for all azure tracked and proxy resources.")
model AzureResourceProperties {
  @doc("The status of the last operation.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Request body for Proxy site refresh action.")
model ProxySiteRefreshBody {
  @doc("Gets or sets the appliance name of the agent in the site.")
  applianceName?: string;
}

@doc("The Site Tags patch resource definition.")
model SiteTagsPatch {
  ...TagsUpdate;
}

@doc("The extended location for off-azure resources.")
model ExtendedLocation {
  @doc("The extended location type.") type?: string;
  @doc("The extended location name.") name?: string;
}

@doc("Software-specific attributes and metadata.")
model SoftwareAttributes {
  @doc("Name of the software (e.g., Kubernetes, Docker).")
  softwareName?: string;

  @doc("Name of the software provider or vendor.") providerName?: string;
  @doc("Version of the software.") softwareVersion?: string;
  @doc("Unique identifier for the software instance.") softwareId?: string;

  @doc("List of additional custom properties with string value types.")
  @identifiers(#["key"])
  customProperties?: CustomProperties[];
}

@doc("Custom property with mixed value types.")
model CustomProperties {
  @doc("Property key.") key: string;
  @doc("Property value - string.") value: string;
}

@doc("A key-value pair for labels, annotations, and other metadata.")
model KeyValuePair {
  @doc("The key of the pair.") key?: string;
  @doc("The value of the pair.") value?: string;
}

@doc("Represents an Enum with boolean values.")
union BoolValue {
  @doc("Unknown value.") Unknown: "Unknown",
  @doc("True value.") True: "True",
  @doc("False value.") False: "False",
  string,
}

@doc("Support status of a software component.")
union SupportStatus {
  string,
  @doc("Unknown support status.") Unknown: "Unknown",
  @doc("Out of support.") OutOfSupport: "OutOfSupport",
  @doc("Extended support.") Extended: "Extended",
  @doc("Mainstream support.") Mainstream: "Mainstream",
}

// ═══════════════════════════════════════════════════════════════════════════════
// ERROR MODEL
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Discovery or validation error for a container resource.")
model ContainerDiscoveryError {
  @doc("Unique error identifier.") id?: string;
  @doc("Error code.") code?: string;
  @doc("Error severity.") severity?: ErrorSeverity;
  @doc("Detailed error message.") message?: string;
  @doc("Summary error message.") summaryMessage?: string;
  @doc("Possible cause of the error.") possibleCause?: string;
  @doc("Recommended action to resolve.") recommendedAction?: string;
  @doc("Run-as account ID used during discovery.") runAsAccountId?: string;
  @doc("Time when the error was last updated.") updatedTimeStamp?: utcDateTime;
}

@doc("Error severity level.")
union ErrorSeverity {
  string,
  @doc("Error severity.") Error: "Error",
  @doc("Warning severity.") Warning: "Warning",
}

// ═══════════════════════════════════════════════════════════════════════════════
// HOST MACHINE MODEL (shared across Cluster + Instance)
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Host machine identity for correlation with discovered VMs.")
model HostMachineProperties {
  @doc("Azure Migrate internal host GUID for Kusto correlation.")
  hostId?: string;

  @doc("ARM resource ID of the discovered VM/machine.")
  machineArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OffAzure/serverSites/machines";
    },
    {
      type: "Microsoft.OffAzure/vmwareSites/machines";
    },
    {
      type: "Microsoft.OffAzure/hyperVSites/machines";
    }
  ]>;

  @doc("Fully qualified domain name of the host.") hostFqdn?: string;
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("Primary IP address of the host.") hostPrimaryIp?: string;
}

#suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
@doc("Host machine identity with OS details (for containerInstances).")
model HostMachineWithOsProperties {
  ...HostMachineProperties;
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("Host operating system type.") hostOsType?: OsType;
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("Host operating system version.") hostOsVersion?: string;
  @doc("Host kernel version.") hostKernelVersion?: string;
  @doc("Host CPU architecture.") hostCpuArchitecture?: CpuArchitecture;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONTAINER-SPECIFIC ENUMS
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Container orchestrator type.")
union OrchestratorType {
  string,

  // P0 (MVP / must-support)
  @doc("Kubernetes orchestrator.") Kubernetes: "kubernetes",

  @doc("VMware Tanzu Kubernetes Grid orchestrator.") TKG: "tkg",
  @doc("Red Hat OpenShift orchestrator.") OpenShift: "openshift",
  @doc("Docker Swarm orchestrator.") Swarm: "swarm",

  // P1 (later / nice-to-have)
  @doc("Cloud Foundry Diego orchestrator.") Diego: "diego",

  @doc("HashiCorp Nomad orchestrator.") Nomad: "nomad",
  @doc("Apache Mesos orchestrator.") Mesos: "mesos",
  @doc("Rancher orchestrator.") Rancher: "rancher",
}

@doc("Container orchestrator distribution/flavor.")
union OrchestratorDistribution {
  string,
  @doc("Vanilla kubeadm.") Kubeadm: "kubeadm",
  @doc("Azure Kubernetes Service.") AKS: "aks",
  @doc("Amazon EKS.") EKS: "eks",
  @doc("Google GKE.") GKE: "gke",
  @doc("Oracle OKE.") OKE: "oke",
  @doc("VMware Tanzu Kubernetes Grid.") TKG: "tkg",
  @doc("Rancher RKE.") RKE: "rke",
  @doc("Rancher RKE2.") RKE2: "rke2",
  @doc("Lightweight K3s.") K3s: "k3s",
  @doc("Canonical MicroK8s.") MicroK8s: "microk8s",
  @doc("Kind (K8s in Docker).") Kind: "kind",
  @doc("OKD (community OpenShift).") OKD: "okd",
  @doc("Red Hat OpenShift.") OpenShift: "openshift",
  @doc("Docker Swarm.") DockerSwarm: "docker-swarm",
}

@doc("Container runtime type.")
union ContainerRuntimeType {
  string,
  @doc("containerd runtime.") Containerd: "containerd",
  @doc("Docker runtime.") Docker: "docker",
  @doc("CRI-O runtime.") CriO: "cri-o",
  @doc("Podman runtime.") Podman: "podman",
}

@doc("Cluster state.")
union ClusterState {
  string,
  @doc("Active cluster.") Active: "active",
  @doc("Inactive cluster.") Inactive: "inactive",
  @doc("Cluster being provisioned.") Provisioning: "provisioning",
  @doc("Degraded cluster.") Degraded: "degraded",
  @doc("Unknown state.") Unknown: "unknown",
}

@doc("Cluster ID source.")
union ClusterIdSource {
  string,
  @doc("From kube-system namespace UID.") KubeSystemUid: "kube-system-uid",

  @doc("From ClusterVersion UID (OpenShift).")
  ClusterVersionUid: "clusterversion-uid",

  @doc("From vCenter L0 API (TKG).") VCenterL0: "vcenter-l0",
  @doc("From Docker Swarm cluster ID.") SwarmClusterId: "swarm-cluster-id",
  @doc("From hostname.") Hostname: "hostname",
}

@doc("Node role in the cluster.")
union NodeRole {
  string,
  @doc("Control plane node.") ControlPlane: "control-plane",
  @doc("Worker node.") Worker: "worker",
  @doc("Swarm manager node.") Manager: "manager",
  @doc("Agent node.") Agent: "agent",

  @doc("Standalone container host (no orchestrator).")
  StandaloneHost: "standalone-host",
}

@doc("Node availability status.")
union NodeAvailability {
  string,
  @doc("Node is ready.") Ready: "Ready",
  @doc("Node is not ready.") NotReady: "NotReady",
  @doc("Node is active (Swarm).") NodeActive: "active",
  @doc("Node is draining.") Drain: "drain",
  @doc("Node is paused.") Pause: "pause",
  @doc("Node is down.") Down: "down",
  @doc("Unknown availability.") Unknown: "unknown",
}

@doc("Operating system type.")
union OsType {
  string,
  @doc("Linux operating system.") Linux: "linux",
  @doc("Windows operating system.") Windows: "windows",
}

@doc("CPU architecture.")
union CpuArchitecture {
  string,
  @doc("x86_64 architecture.") X86_64: "x86_64",
  @doc("ARM64 architecture.") Arm64: "arm64",
  @doc("IBM s390x architecture.") S390x: "s390x",
  @doc("PowerPC 64-bit LE architecture.") Ppc64le: "ppc64le",
}

@doc("Hypervisor type.")
union HypervisorType {
  string,
  @doc("VMware ESXi.") VMware: "vmware",
  @doc("Microsoft Hyper-V.") HyperV: "hyperv",
  @doc("KVM hypervisor.") KVM: "kvm",
  @doc("Bare metal (no hypervisor).") BareMetal: "bare-metal",
  @doc("Unknown hypervisor.") Unknown: "unknown",
}

@doc("Container state.")
union ContainerState {
  string,
  @doc("Container is running.") Running: "running",
  @doc("Container is stopped.") Stopped: "stopped",
  @doc("Container is paused.") Paused: "paused",
  @doc("Container has exited.") Exited: "exited",
}

@doc("Network mode for standalone containers.")
union NetworkMode {
  string,
  @doc("Bridge network mode.") Bridge: "bridge",
  @doc("Host network mode.") Host: "host",
  @doc("No network.") None: "none",
  @doc("Overlay network.") Overlay: "overlay",
}

@doc("Container restart policy.")
union RestartPolicy {
  string,
  @doc("Never restart.") No: "no",
  @doc("Restart on failure.") OnFailure: "on-failure",
  @doc("Always restart.") Always: "always",
  @doc("Unless stopped.") UnlessStopped: "unless-stopped",
}

// ═══════════════════════════════════════════════════════════════════════════════
// DISCOVERY METADATA
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Discovery completeness level.")
union DiscoveryCompleteness {
  string,
  @doc("Only shallow discovery data available.") Shallow: "shallow",
  @doc("Deep discovery partially completed.") DeepPartial: "deep-partial",
  @doc("Deep discovery fully completed.") DeepComplete: "deep-complete",
}

// ═══════════════════════════════════════════════════════════════════════════════
// CLUSTER SUB-MODELS
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Slim node entry for cluster-level assessment reads.")
model SlimNodeEntry {
  @doc("Node identifier.") nodeId?: string;
  @doc("Node role.") nodeRole?: NodeRole;

  @doc("ARM resource ID of the underlying VM.")
  machineArmId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.OffAzure/serverSites/machines";
    },
    {
      type: "Microsoft.OffAzure/vmwareSites/machines";
    },
    {
      type: "Microsoft.OffAzure/hyperVSites/machines";
    }
  ]>;
}

@doc("Container orchestrator details.")
model OrchestratorProperties {
  @doc("Orchestrator type.") type?: OrchestratorType;

  @doc("Orchestrator distribution/flavor.")
  distribution?: OrchestratorDistribution;

  @doc("Orchestrator version.") version?: string;
  @doc("Cluster state.") state?: ClusterState;
  @doc("API server endpoint URL.") apiServerEndpoint?: string;
  @doc("Source of the cluster ID.") clusterIdSource?: ClusterIdSource;
  @doc("Cluster CPU architecture.") architecture?: CpuArchitecture;
}

@doc("Cluster-wide resource allocation.")
model ClusterResources {
  @doc("Total allocated resources.") resourceAllocated?: ResourceMetrics;
}

@doc("CPU and memory metrics.")
model ResourceMetrics {
  @doc("CPU cores.") cpuCores?: float64;
  @doc("Memory in MB.") memoryMb?: float64;
}

@doc("Cluster network profile.")
model ClusterNetworkProfile {
  @doc("Pod network CIDR.") clusterCidr?: string;
  @doc("Service network CIDR.") serviceCidr?: string;
  @doc("DNS provider details.") dnsProvider?: DnsProviderInfo;
  @doc("Network plugin details.") networkPlugin?: NetworkPluginInfo;
  @doc("Network policy engine.") networkPolicyEngine?: string;
  @doc("Ingress controller details.") ingress?: IngressInfo;
}

@doc("DNS provider information.")
model DnsProviderInfo {
  @doc("DNS provider name (CoreDNS, kube-dns).") name?: string;
  @doc("DNS provider version.") version?: string;
}

@doc("Network plugin information.")
model NetworkPluginInfo {
  @doc("Plugin name (Calico, Cilium, Flannel, etc.).") name?: string;
  @doc("Plugin version.") version?: string;
}

@doc("Ingress controller information.")
model IngressInfo {
  @doc("Controller type (NGINX, Traefik, HAProxy, Contour, Istio).")
  controllerType?: string;

  @doc("Controller version.") version?: string;
}

@doc("Cluster storage profile.")
model StorageProfile {
  @doc("Storage classes available in the cluster.")
  @identifiers(#[])
  storageClasses?: StorageClassInfo[];

  @doc("Persistent volume summary.")
  persistentVolumes?: PersistentVolumeSummary;

  @doc("Persistent volume claim summary.")
  persistentVolumeClaims?: PersistentVolumeClaimSummary;

  @doc("CSI drivers installed.") csiDrivers?: string[];
}

@doc("Storage class information.")
model StorageClassInfo {
  @doc("Storage class name.") name?: string;
  @doc("Storage provisioner.") provisioner?: string;
  @doc("Whether this is the default storage class.") isDefault?: boolean;
}

@doc("Persistent volume summary.")
model PersistentVolumeSummary {
  @doc("Total PV count.") count?: int32;
  @doc("Total PV capacity in GB.") totalCapacityGb?: float64;
}

@doc("Persistent volume claim summary.")
model PersistentVolumeClaimSummary {
  @doc("Total PVC count.") count?: int32;
}

@doc("Cluster-wide configuration and policies.")
model ClusterConfiguration {
  @doc("Service mesh type (Istio, Linkerd, etc.).") serviceMeshType?: string;
  @doc("RBAC mode (RBAC, ABAC, none).") rbacMode?: string;
  @doc("Pod Security Standard level.") podSecurityStandard?: string;
  @doc("Whether etcd is encrypted at rest.") etcdEncryptedAtRest?: boolean;

  @doc("Whether Kubernetes audit logging is enabled.")
  auditLoggingEnabled?: boolean;

  @doc("Count of admission webhooks.") admissionWebhookCount?: int32;
  @doc("Count of Custom Resource Definitions.") crdCount?: int32;
  @doc("Count of namespaces.") namespaceCount?: int32;

  @doc("Namespace details.")
  @identifiers(#[])
  namespaces?: NamespaceInfo[];
}

@doc("Namespace information for cluster detail view.")
model NamespaceInfo {
  @doc("Namespace name.") name?: string;
  @doc("Namespace classification.") classification?: NamespaceClassification;
  @doc("Number of workloads in this namespace.") workloadCount?: int32;
  @doc("Number of pods in this namespace.") podCount?: int32;
}

@doc("Namespace classification.")
union NamespaceClassification {
  string,
  @doc("Application namespace.") Application: "Application",
  @doc("Platform namespace.") Platform: "Platform",
  @doc("System namespace.") System: "System",
}

@doc("Deprecated Kubernetes API usage.")
model DeprecatedApiUsage {
  @doc("Count of deprecated API usages found.") count?: int32;

  @doc("Target K8s version for deprecation check.")
  targetKubernetesVersion?: string;
}

@doc("Security assessment signals.")
model SecurityAssessment {
  @doc("Pod security policy/standard assessment.")
  podSecurity?: PodSecurityAssessment;

  @doc("Number of privileged containers across the cluster.")
  privilegedContainerCount?: int32;
}

@doc("Pod security assessment.")
model PodSecurityAssessment {
  @doc("Whether PodSecurityPolicy is in use.") pspInUse?: boolean;

  @doc("Whether Pod Security Standards labels are enabled.")
  podSecurityStandardsEnabled?: boolean;

  @doc("K8s version affected by PSP removal.") affectsUpgradeTo?: string;
}

@doc("Helm release information.")
model HelmReleaseInfo {
  @doc("Helm release name.") releaseName?: string;
  @doc("Helm chart name.") chartName?: string;
  @doc("Helm chart version.") chartVersion?: string;
  @doc("Kubernetes namespace of the release.") releaseNamespace?: string;
  @doc("Release status.") status?: string;
}

@doc("Deployment assessment signals.")
model DeploymentAssessment {
  @doc("Helm releases summary.") helmReleases?: HelmReleasesSummary;
}

@doc("Helm releases summary.")
model HelmReleasesSummary {
  @doc("Total Helm release count.") count?: int32;

  @doc("Individual Helm releases.")
  @identifiers(#[])
  releases?: HelmReleaseInfo[];
}

@doc("Sizing quality metrics.")
model SizingQuality {
  @doc("Coverage of resource requests and limits.")
  resourceRequestsLimitsCoverage?: RequestsLimitsCoverage;
}

@doc("Resource requests/limits coverage percentages.")
model RequestsLimitsCoverage {
  @doc("Percentage of containers with CPU/memory requests.")
  requestsCoveragePercent?: int32;

  @doc("Percentage of containers with CPU/memory limits.")
  limitsCoveragePercent?: int32;

  @doc("Percentage with both requests and limits.") fullCoveragePercent?: int32;
}

@doc("Storage assessment signals.")
model StorageAssessmentSignals {
  @doc("Number of hostPath volume mounts across the cluster.")
  hostPathMountCount?: int32;
}

@doc("Network assessment signals.")
model NetworkAssessmentSignals {
  @doc("NodePort range configuration.") nodePortRange?: NodePortRangeInfo;
}

@doc("NodePort range information.")
model NodePortRangeInfo {
  @doc("Configured NodePort range.") configuredRange?: string;
  @doc("Default NodePort range.") defaultRange?: string;
  @doc("Whether a custom range is configured.") isCustom?: boolean;
}

@doc("Cluster node topology summary.")
model NodeSummary {
  @doc("Total node count.") totalNodes?: int32;
  @doc("Control plane node count.") controlPlaneNodes?: int32;
  @doc("Worker node count.") workerNodes?: int32;
}

@doc("Workload controller type counts across the cluster.")
model WorkloadControllerSummary {
  @doc("Total Deployment count.") deployments?: int32;
  @doc("Total StatefulSet count.") statefulSets?: int32;
  @doc("Total DaemonSet count.") daemonSets?: int32;
  @doc("Total ReplicaSet count.") replicaSets?: int32;
  @doc("Total Job count.") jobs?: int32;
  @doc("Total CronJob count.") cronJobs?: int32;
}

@doc("Cluster-wide capacity and utilization summary.")
model ClusterCapacitySummary {
  @doc("Total running pod count.") totalPodCount?: int32;
  @doc("Total pod capacity across all nodes.") podCapacityCount?: int32;
}

// ═══════════════════════════════════════════════════════════════════════════════
// NODE SUB-MODELS (full detail for child sub-resource)
// ═══════════════════════════════════════════════════════════════════════════════

#suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
@doc("Host OS details.")
model HostOsProperties {
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("Operating system type.") osType?: OsType;
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("OS distribution name.") osDistribution?: string;
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("OS version.") osVersion?: string;
  @doc("Kernel version.") kernelVersion?: string;
  @doc("CPU architecture.") cpuArchitecture?: CpuArchitecture;
}

@doc("Full container runtime details.")
model ContainerRuntimeDetails {
  @doc("Runtime name.") runtimeName?: string;
  @doc("Runtime type.") runtimeType?: ContainerRuntimeType;
  @doc("Runtime version.") runtimeVersion?: string;
  @doc("Socket path.") socketPath?: string;
  @doc("Storage driver (overlayfs, overlay2, etc.).") storageDriver?: string;
  @doc("Storage root path.") storageRootPath?: string;
  @doc("Whether running in rootless mode.") isRootless?: boolean;
  @doc("Cgroup driver (systemd, cgroupfs).") cgroupDriver?: string;
  @doc("Number of running containers.") runningContainerCount?: int32;
  @doc("Runtime support status.") runtimeSupportStatus?: SupportStatus;
  @doc("Client version.") clientVersion?: string;
  @doc("Server version.") serverVersion?: string;
}

@doc("Orchestrator agent details.")
model OrchestratorAgentProperties {
  @doc("Agent name (kubelet, dockerd-swarm, etc.).") agentName?: string;
  @doc("Agent version.") agentVersion?: string;
  @doc("Node status as reported by agent.") nodeStatus?: NodeAvailability;
}

@doc("Full node capacity details.")
model FullNodeCapacity {
  @doc("Total CPU capacity on the node (from node.status.capacity.cpu).")
  totalCpu?: string;

  @doc("Total memory capacity on the node (from node.status.capacity.memory).")
  totalMemory?: string;

  @doc("Total ephemeral storage capacity on the node.")
  totalEphemeralStorage?: string;

  @doc("CPU available for pod scheduling after system reserves (from node.status.allocatable.cpu).")
  allocatableCpu?: string;

  @doc("Memory available for pod scheduling after system reserves (from node.status.allocatable.memory).")
  allocatableMemory?: string;

  @doc("Ephemeral storage available for pod scheduling after system reserves.")
  allocatableEphemeralStorage?: string;

  @doc("Sum of CPU requests from all pods scheduled on this node.")
  requestedCpu?: string;

  @doc("Sum of memory requests from all pods scheduled on this node.")
  requestedMemory?: string;

  @doc("Maximum pods allowed on this node.") maxPods?: int32;
  @doc("Currently running pod count.") runningPodCount?: int32;
  @doc("Pod density ratio (runningPodCount / maxPods).") podDensity?: float64;
}

@doc("GPU information on a node.")
model GpuProperties {
  @doc("Whether GPU is present.") gpuPresent?: boolean;
  @doc("GPU type/model.") gpuType?: string;
  @doc("Number of GPUs.") gpuCount?: int32;
}

@doc("Hypervisor information.")
model HypervisorProperties {
  @doc("Hypervisor type.") type?: HypervisorType;
  @doc("Hypervisor version.") version?: string;
}

@doc("Kubernetes node condition.")
model NodeCondition {
  @doc("Condition type (Ready, MemoryPressure, etc.).") type?: string;
  @doc("Condition status (True, False, Unknown).") status?: string;
  @doc("Reason for the condition.") reason?: string;
  @doc("Human-readable message.") message?: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONTAINER INSTANCE SUB-MODELS
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Container runtime with resource usage (for standalone hosts).")
model ContainerRuntimeWithUsage {
  ...ContainerRuntimeDetails;
  @doc("Current resource usage.") resourceUsage?: ResourceMetrics;
  @doc("Total allocated resources.") resourceAllocated?: ResourceMetrics;
}

@doc("Container command/entrypoint.")
model ContainerCommand {
  @doc("Container entrypoint.") entrypoint?: string[];
  @doc("Container arguments.") args?: string[];
}

@doc("Container image details.")
model ContainerImageProperties {
  @doc("Image name.") imageName?: string;
  @doc("Image tag.") imageTag?: string;
  @doc("Image content digest.") imageDigest?: string;
  @doc("Image registry.") imageRegistry?: string;
  @doc("Image size in MB.") imageSizeMb?: float64;
  @doc("Image architecture.") imageArchitecture?: string;
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("Image OS type.") osType?: OsType;
}

@doc("Container port mapping.")
model ContainerPortMapping {
  @doc("Host port.") hostPort?: int32;
  @doc("Container port.") containerPort?: int32;
  @doc("Protocol (tcp/udp).") protocol?: string;
}

@doc("Container volume mount.")
model ContainerVolumeMount {
  @doc("Host path.") hostPath?: string[];
  @doc("Container path.") containerPath?: string[];
  @doc("Whether mount is read-only.") readOnly?: boolean;
  @doc("Whether mount uses host path.") usesHostPath?: boolean;
  @doc("Volume type.") volumeType?: string;
  @doc("Volume name.") volumeName?: string;
}

@doc("Container network connection.")
model ContainerNetworkInfo {
  @doc("Network name.") networkName?: string;
  @doc("Network driver.") networkDriver?: string;
  #suppress "@azure-tools/typespec-client-generator-core/csharp-use-standard-acronyms" "Name kept for backward compatibility"
  @doc("Container IP address.") ipAddress?: string;
}

@doc("Container resource allocation.")
model ContainerResourceAllocation {
  @doc("CPU request.") cpuRequest?: string;
  @doc("CPU limit.") cpuLimit?: string;
  @doc("Memory request.") memoryRequest?: string;
  @doc("Memory limit.") memoryLimit?: string;
  @doc("GPU request.") gpuRequest?: string;
  @doc("GPU type.") gpuType?: string;
  @doc("Whether resource limits are configured.") hasResourceLimits?: boolean;

  @doc("Whether resource requests are configured.")
  hasResourceRequests?: boolean;
}

@doc("Container security context.")
model ContainerSecurityContext {
  @doc("Whether container runs in privileged mode.") isPrivileged?: boolean;
  @doc("User ID the container runs as (null = root).") runAsUser?: int32;
  @doc("Whether container must run as non-root.") runAsNonRoot?: boolean;

  @doc("Whether root filesystem is read-only.")
  readOnlyRootFilesystem?: boolean;

  @doc("Whether privilege escalation is allowed.")
  allowPrivilegeEscalation?: boolean;

  @doc("Added Linux capabilities.") addedCapabilities?: string[];

  @doc("Dropped Linux capabilities.")
  droppedCapabilities?: string[];
}

@doc("Container health check configuration.")
model ContainerHealthCheck {
  @doc("Whether a health check is configured.") hasHealthcheck?: boolean;
  @doc("Health check command.") healthcheckCmd?: string;
  @doc("Health check interval in seconds.") intervalSeconds?: int32;
  @doc("Health check timeout in seconds.") timeoutSeconds?: int32;
  @doc("Number of retries before marking unhealthy.") retries?: int32;
}

@doc("Signals for grouping related standalone containers.")
model ContainerGroupSignals {
  @doc("Docker Compose project label.") composeProjectLabel?: string;
  @doc("Docker Compose service label.") composeServiceLabel?: string;
  @doc("Docker Compose config hash.") composeConfigHash?: string;
  @doc("Podman pod name.") podmanPodName?: string;

  @doc("Custom application labels as key-value pairs.")
  @identifiers(#[])
  customAppLabels?: KeyValuePair[];

  @doc("Published host ports.") publishedHostPorts?: int32[];
  @doc("Container name pattern.") containerNamePattern?: string;

  @doc("Shared Docker network names for grouping.")
  sharedNetworkNames?: string[];

  @doc("IDs of linked containers (e.g., Docker --link).")
  linkedContainerIds?: string[];

  @doc("Port-based dependencies between containers.")
  @identifiers(#[])
  portDependencies?: PortDependency[];
}

@doc("Port dependency between two standalone containers.")
model PortDependency {
  @doc("Source container ID.") sourceContainerId?: string;
  @doc("Target container ID.") targetContainerId?: string;
  @doc("Target port number.") targetPort?: int32;
  @doc("Protocol (tcp/udp).") protocol?: string;
}

@doc("Portability signals for migration readiness.")
model PortabilitySignals {
  @doc("Runs in privileged mode.") isPrivileged?: boolean;
  @doc("Uses host network mode.") usesHostNetwork?: boolean;
  @doc("Has hostPath volume mounts.") hasHostPathVolumes?: boolean;
  @doc("Uses Windows container image.") hasWindowsImage?: boolean;
  @doc("Has persistent data.") hasPersistentData?: boolean;
  @doc("Exposes multiple ports.") exposesMultiplePorts?: boolean;
  @doc("Requires GPU.") hasGpuRequirement?: boolean;
  @doc("Uses Docker/K8s secrets.") usesSecrets?: boolean;
  @doc("Uses ConfigMaps.") usesConfigMaps?: boolean;
  @doc("Uses private container registry.") hasPrivateRegistry?: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// APPLICATION GROUP MODELS
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Application group source.")
union ApplicationGroupSource {
  string,
  @doc("Derived from app label.") AppLabel: "app-label",
  @doc("Derived from Helm release.") HelmRelease: "helm-release",
  @doc("Derived from Service selector.") ServiceSelector: "service-selector",
  @doc("Namespace fallback.") Namespace: "namespace",
  @doc("Docker Compose project.") ComposeProject: "compose-project",
  @doc("Podman pod.") PodmanPod: "podman-pod",
  @doc("Port/network based.") PortNetwork: "port-network",
  @doc("Manual override.") Manual: "manual",
}

@doc("Application group entry for cluster-level grouping.")
model ApplicationGroupEntry {
  @doc("Unique identifier for the application group.")
  applicationGroupId?: string;

  @doc("Source of the grouping.") source?: ApplicationGroupSource;
  @doc("Number of workloads in this group.") workloadCount?: int32;
  @doc("Number of containers in this group.") containerCount?: int32;
  @doc("Namespaces this group spans.") namespaces?: string[];
  @doc("Total CPU requests across group.") totalCpuRequest?: string;
  @doc("Total memory requests across group.") totalMemoryRequest?: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// AGENT SUB-MODELS
// ═══════════════════════════════════════════════════════════════════════════════

@doc("Agent service principal identity details.")
model AgentSpnProperties {
  @doc("Tenant ID for the service principal.") tenantId?: string;
  @doc("Application/client ID.") applicationId?: string;
  @doc("Object ID.") objectId?: string;
}

@doc("Agent health details.")
model AgentHealthProperties {
  @doc("Agent version.") version?: string;
  @doc("Last heartbeat time in UTC.") lastHeartBeatUtc?: utcDateTime;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIST MODELS
// ═══════════════════════════════════════════════════════════════════════════════

@doc("List of ContainerSites.")
model ContainerSiteList is Azure.Core.Page<ContainerSite>;
@doc("List of ContainerClusters.")
model ContainerClusterList is Azure.Core.Page<ContainerCluster>;
@doc("List of ContainerNodes.")
model ContainerNodeList is Azure.Core.Page<ContainerNode>;
@doc("List of ContainerWorkloads.")
model ContainerWorkloadList is Azure.Core.Page<ContainerWorkload>;
@doc("List of ContainerAgents.")
model ContainerAgentList is Azure.Core.Page<ContainerAgent>;
