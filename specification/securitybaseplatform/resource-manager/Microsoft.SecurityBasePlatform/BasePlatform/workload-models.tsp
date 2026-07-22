import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./shared-models.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.SecurityBasePlatform;

@doc("Common properties shared by all workload kinds (Service, Job, CronJob).")
model WorkloadProperties {
  @doc("Container image configuration.")
  image: ContainerImage;

  @doc("Compute resources.")
  resources?: ComputeResources;

  @doc("Non-sensitive environment variables. For secrets, mount them via `securityProfile.keyVaultSecrets` rather than passing them here.")
  @identifiers(#["name"])
  environmentVariables?: EnvironmentVariable[];

  @doc("Security context.")
  securityProfile?: SecurityProfile;

  @doc("Storage and persistence configuration.")
  storageProfile?: StorageProfile;

  @doc("Observability configuration for the workload (per-workload telemetry emission).")
  observability?: WorkloadObservability;

  @doc("Placement and scheduling constraints for this workload.")
  placement?: PlacementConfig;

  @doc("The provisioning state of the resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

@doc("Container image configuration.")
model ContainerImage {
  @doc("Container registry hostname (e.g. myregistry.azurecr.io).")
  registry?: string;

  @doc("Image repository.")
  repository: string;

  @doc("Image tag.")
  tag?: string;
}

@doc("Compute resources.")
model ComputeResources {
  @doc("CPU requests and limits.")
  cpu?: ResourceRequestsLimits;

  @doc("Memory requests and limits.")
  memory?: ResourceRequestsLimits;
}

@doc("Resource requests and limits.")
model ResourceRequestsLimits {
  @doc("Resource request.")
  request?: string;

  @doc("Resource limit.")
  limit?: string;
}

@doc("Security profile.")
model SecurityProfile {
  @doc("Read only root filesystem.")
  readOnlyRootFilesystem?: boolean;

  @doc("Key Vault secrets mounted into the workload as files.")
  keyVaultSecrets?: KeyVaultSecretsConfig;
}

@doc("The scaling mode of a workload.")
union ScalingMode {
  string,

  @doc("A fixed number of replicas.")
  Fixed: "Fixed",

  @doc("Autoscaled between a minimum and maximum replica count based on triggers.")
  Auto: "Auto",
}

@doc("Scaling configuration. Either a fixed replica count or autoscaling.")
model ScalingProfile {
  @doc("The scaling mode.")
  mode: ScalingMode;

  @doc("Fixed replica configuration. Set when `mode` is `Fixed`.")
  fixed?: FixedScalingConfig;

  @doc("Autoscaling configuration. Set when `mode` is `Auto`.")
  auto?: AutoScalingConfig;
}

@doc("Fixed-replica scaling.")
model FixedScalingConfig {
  @doc("The number of replicas to run.")
  @minValue(0)
  replicas: int32;
}

@doc("KEDA-compatible autoscaling configuration.")
model AutoScalingConfig {
  @doc("The minimum number of replicas.")
  @minValue(0)
  minReplicas?: int32;

  @doc("The maximum number of replicas.")
  @minValue(1)
  maxReplicas: int32;

  @identifiers(#["key"])
  @doc("KEDA-compatible triggers that drive autoscaling.")
  triggers?: ScalingTrigger[];
}

@doc("The type of autoscaling trigger.")
union ScalingTriggerType {
  string,

  @doc("Azure Queue Storage trigger.")
  AzureQueue: "azureQueue",

  @doc("Azure Service Bus trigger.")
  AzureServiceBus: "azureServiceBus",

  @doc("Prometheus metrics trigger.")
  Prometheus: "prometheus",

  @doc("CPU utilization trigger.")
  Cpu: "cpu",

  @doc("Memory utilization trigger.")
  Memory: "memory",
}

@doc("Base autoscaling trigger configuration.")
@discriminator("type")
model ScalingTrigger {
  @doc("Trigger type.")
  type: ScalingTriggerType;

  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" ""
  @doc("Rule identifier")
  key: string;
}

@doc("Azure Queue trigger.")
model AzureQueueTrigger extends ScalingTrigger {
  @doc("Trigger type.")
  type: ScalingTriggerType.AzureQueue;

  @doc("Azure Storage account name.")
  accountName: string;

  @doc("Azure Storage queue name.")
  queueName: string;

  @doc("Queue length threshold. Defaults to the platform/KEDA default when omitted.")
  @minValue(1)
  queueLength?: int32;
}

@doc("Azure Service Bus trigger.")
model AzureServiceBusTrigger extends ScalingTrigger {
  @doc("Trigger type.")
  type: ScalingTriggerType.AzureServiceBus;

  @doc("Azure Service Bus namespace.")
  serviceBusNamespace: string;

  @doc("Queue name. Use either `queueName` or `topicName` plus `subscriptionName`.")
  queueName?: string;

  @doc("Topic name. Use with `subscriptionName`.")
  topicName?: string;

  @doc("Subscription name for a topic trigger.")
  subscriptionName?: string;

  @doc("Message count threshold. Defaults to the platform/KEDA default when omitted.")
  @minValue(1)
  messageCount?: int32;
}

@doc("Prometheus trigger.")
model PrometheusTrigger extends ScalingTrigger {
  @doc("Trigger type.")
  type: ScalingTriggerType.Prometheus;

  @doc("Prometheus server address.")
  serverAddress: string;

  @doc("Metric name exposed to the autoscaler.")
  metricName: string;

  @doc("PromQL query expression to evaluate.")
  query: string;

  @doc("Prometheus threshold value.")
  threshold: string;
}

@doc("CPU trigger.")
model CpuTrigger extends ScalingTrigger {
  @doc("Trigger type.")
  type: ScalingTriggerType.Cpu;

  @doc("Metric target type.")
  metricType?: MetricTargetType;

  @doc("Target CPU value.")
  value: string;
}

@doc("Memory trigger.")
model MemoryTrigger extends ScalingTrigger {
  @doc("Trigger type.")
  type: ScalingTriggerType.Memory;

  @doc("Metric target type.")
  metricType?: MetricTargetType;

  @doc("Target memory value.")
  value: string;
}

@doc("Metric target type.")
union MetricTargetType {
  string,

  @doc("No metric target type specified.")
  None: "None",

  @doc("Target based on resource utilization percentage.")
  Utilization: "Utilization",

  @doc("Target based on an absolute metric value.")
  Value: "Value",

  @doc("Target based on the average value across all instances.")
  AverageValue: "AverageValue",
}

@doc("Storage configuration.")
model StorageProfile {
  @doc("Storage mounts. Each mount references a named storage definition on the parent namespace.")
  @identifiers(#["storageName", "mountPath"])
  mounts?: StorageMount[];
}

@doc("A workload mount of a namespace-level storage definition.")
model StorageMount {
  @doc("Name of the namespace storage definition to mount.")
  storageName: string;

  @doc("Path where the volume is mounted in the workload container.")
  mountPath: string;

  @doc("Mount the storage read-only. Defaults to false.")
  readOnly?: boolean;

  @doc("Optional sub-path within the storage definition to mount.")
  subPath?: string;
}

@doc("Key Vault secrets mounted into the workload as files. The platform provisions the secret mount and wiring; the workload's `identity` is used to authenticate to Key Vault.")
model KeyVaultSecretsConfig {
  @doc("The Key Vault name to pull secrets from.")
  keyVault: string;

  @doc("Names of the secrets/objects to mount.")
  secrets: string[];

  @doc("Path where the secrets are mounted in the workload container.")
  mountPath: string;
}

@doc("Container port configuration.")
model ContainerPortConfig {
  @doc("Port name.")
  name?: string;

  @doc("Container port number.")
  containerPort: int32;

  @doc("Protocol (TCP/UDP).")
  protocol?: string;
}

@doc("Ingress configuration for a Service.")
model ServiceIngressConfig {
  @doc("Whether the Service is exposed through cluster ingress. Defaults to false.")
  enabled?: boolean;

  @doc("""
    Public hostnames this Service is exposed on. Required when `enabled` is true
    and ignored otherwise. Exposing a Service through ingress requires the cluster
    to have ingress enabled (see ClusterIngressConfig).
    """)
  @identifiers(#["host"])
  hosts?: PublicHost[];
}

@doc("A public hostname exposed by a Service.")
model PublicHost {
  @doc("Fully-qualified hostname (e.g. api.securitycenter.windows.com).")
  host: string;

  @doc("""
    Routing rules mapping URL paths on this host to the Service ports that serve
    them. When omitted, all traffic ('/') is routed to the Service's sole port.
    """)
  @identifiers(#["path"])
  routes?: HostRoute[];

  @doc("TLS configuration for this host.")
  tls?: HostTls;
}

@doc("Routes a URL path prefix on a public host to a Service port.")
model HostRoute {
  @doc("URL path prefix to match. Defaults to '/'.")
  path?: string;

  @doc("The Service port that serves this path. Must match one of the Service's `ports[].containerPort`.")
  targetPort: int32;
}

@doc("TLS configuration for a public host. The platform provisions the certificate onto the ingress.")
model HostTls {
  @doc("Key Vault containing the TLS certificate for this host.")
  keyVault?: string;

  @doc("Name of the TLS certificate in the Key Vault.")
  certificateName?: string;
}

@doc("Observability configuration for a workload (per-workload telemetry emission).")
model WorkloadObservability {
  ...ObservabilityDefaults;
}

@doc("Shared observability settings used as cluster defaults, namespace overrides, and workload overrides.")
model ObservabilityDefaults {
  @doc("Metrics collection configuration.")
  metrics?: WorkloadMetricsConfig;

  @doc("Log collection configuration.")
  logs?: WorkloadLogsConfig;

  @doc("Audit log collection configuration.")
  auditLogs?: WorkloadAuditLogsConfig;

  @doc("Geneva MDM metrics sidecar configuration.")
  mdm?: MdmConfig;

  @doc("Additional Geneva MDM metrics sidecars when more than one metrics pipeline is needed.")
  @identifiers(#["name"])
  extraMdms?: NamedMdmConfig[];

  @doc("File log tailing sidecar configuration.")
  logTail?: LogTailConfig;

  @doc("Path mounted into telemetry sidecars for application log files.")
  logsMountPath?: string;

  @doc("High throughput telemetry pipeline configuration.")
  highThroughput?: HighThroughputConfig;

  @doc("Additional MDSD log collector sidecars when the high-throughput logs pipeline needs more than one collector.")
  @identifiers(#["name"])
  extraMdsds?: NamedMdsdConfig[];

  @doc("Container probe configuration surfaced with observability because ConfigGen treats liveness, readiness, and startup monitors as telemetry/operator health settings.")
  probes?: WorkloadProbesConfig;

  @doc("Kubernetes Service object settings used by ingress, probes, and service discovery.")
  service?: ObservabilityServiceConfig;

  @doc("Telemetry routing settings for selecting closed, supported log and metric destinations.")
  routing?: TelemetryRoutingConfig;

  @doc("Operator-managed observability integration flags.")
  operatorManaged?: OperatorManagedObservabilityConfig;
}

@doc("Metrics collection configuration.")
model WorkloadMetricsConfig {
  @doc("Whether metrics collection is enabled for the workload.")
  enabled?: boolean;

  @doc("Metrics scrape interval in seconds.")
  scrapeIntervalSeconds?: int32;

  @doc("HTTP path used for metrics scraping.")
  path?: string;

  @doc("Named service port used for metrics scraping.")
  portName?: string;

  @doc("Whether PII filtering is enabled before emitting metrics dimensions.")
  piiFilteringEnabled?: boolean;
}

@doc("Log collection configuration.")
model WorkloadLogsConfig {
  @doc("Whether log collection is enabled for the workload.")
  enabled?: boolean;

  @doc("Collect stdout from workload containers.")
  collectStdout?: boolean;

  @doc("Collect stderr from workload containers.")
  collectStderr?: boolean;

  @doc("Whether PII filtering is enabled before logs are routed to telemetry backends.")
  piiFilteringEnabled?: boolean;

  @doc("Whether raw application logs are excluded from generic collection and only explicitly configured sources are collected.")
  excludeRawLogs?: boolean;

  @doc("Closed set of log backends to receive this workload's logs.")
  destinations?: TelemetryLogDestination[];
}

@doc("Audit log collection configuration.")
model WorkloadAuditLogsConfig {
  @doc("Whether audit log collection is enabled for the workload.")
  enabled?: boolean;

  @doc("Audit log categories emitted by the workload.")
  categories?: AuditLogCategory[];
}

@doc("Audit log category.")
union AuditLogCategory {
  string,

  @doc("Administrative audit events.")
  Administrative: "Administrative",

  @doc("Security audit events.")
  Security: "Security",

  @doc("Data access audit events.")
  DataAccess: "DataAccess",

  @doc("Application-defined audit events.")
  Application: "Application",
}

@doc("High throughput telemetry pipeline configuration.")
model HighThroughputConfig {
  @doc("Application process name used by Geneva sidecars for shutdown ordering and attribution.")
  appName?: string;

  @doc("Geneva MDM namespace for high-throughput metrics.")
  genevaMdmNamespace?: string;

  @doc("Metrics configuration.")
  metrics?: HighThroughputMetricsConfig;

  @doc("Logs configuration.")
  logs?: HighThroughputLogsConfig;
}

@doc("High throughput metrics configuration.")
model HighThroughputMetricsConfig {
  @doc("Compute resources for the high-throughput metrics sidecar.")
  resources?: ComputeResources;

  @doc("Circular buffer size in MB.")
  circularBufferMb?: int32;

  @doc("Append metric display units to emitted metrics.")
  appendMetricDisplayUnits?: boolean;

  @doc("Polling interval in seconds.")
  pollingIntervalSeconds?: int32;

  @doc("MDM metrics polling interval in seconds.")
  mdmMetricsPollingIntervalSeconds?: int32;

  @doc("Use the shared MDM service instead of a local MDM endpoint.")
  useMdmService?: boolean;

  @doc("Explicit MDM hostname used by the metrics pipeline.")
  mdmHostname?: string;
}

@doc("High throughput logs configuration.")
model HighThroughputLogsConfig {
  @doc("Compute resources for the high-throughput logs sidecar.")
  resources?: ComputeResources;

  @doc("Circular buffer size in MB.")
  circularBufferMb?: int32;

  @doc("Append metric display units to log pipeline metrics.")
  appendMetricDisplayUnits?: boolean;

  @doc("Geneva configuration service environment.")
  gcsEnvironment?: string;

  @doc("Geneva configuration service namespace.")
  gcsNamespace?: string;

  @doc("Geneva configuration service account.")
  gcsAccount?: string;

  @doc("Geneva configuration service region.")
  gcsRegion?: string;

  @doc("Geneva configuration service version.")
  gcsVersion?: string;

  @doc("Log batch size.")
  batchSize?: int32;

  @doc("Parallelism level for log processing.")
  parallelismLevel?: int32;

  @doc("Max event rate for the high-throughput logs pipeline.")
  maxEventRate?: int32;

  @doc("MDSD collector used by the high-throughput logs pipeline.")
  mdsd?: MdsdConfig;
}

@doc("Geneva MDM metrics sidecar configuration.")
model MdmConfig {
  @doc("Whether the MDM sidecar is enabled.")
  enabled?: boolean;

  @doc("Compute resources for the MDM sidecar.")
  resources?: ComputeResources;

  @doc("Certificate secret name. The platform maps the secret through the configured secret/CSI mechanism.")
  secretName?: string;

  @doc("Application process name used for graceful metrics flush ordering.")
  appProcessName?: string;

  @doc("Geneva metrics account.")
  account?: string;

  @doc("Metrics protocol, for example ifx_tcp, ifx_local, or statsd_tcp.")
  protocol?: string;

  @doc("Metrics listening port.")
  port?: int32;

  @doc("Use Unix domain sockets for local MDM traffic.")
  unixDomainSockets?: boolean;

  @doc("Enable Geneva infra metrics enrichment and transform rules.")
  infraMetricsEnrichment?: boolean;

  @doc("Default dimensions added to metrics when infra metrics enrichment is enabled.")
  @identifiers(#["dimension"])
  defaultDimensions?: TelemetryDimension[];

  @doc("Geneva MDM transform rules.")
  @identifiers(#[])
  transformRules?: MdmTransformRule[];

  @doc("ACR URL used for the MDM image when the shared chart cannot infer it.")
  azureContainerRegistryUrl?: string;

  @doc("OpenTelemetry receiver settings for Geneva MDM.")
  openTelemetry?: OpenTelemetryConfig;
}

@doc("Named Geneva MDM sidecar configuration.")
model NamedMdmConfig {
  ...MdmConfig;

  @doc("Name of the additional MDM sidecar/pipeline.")
  name: string;
}

@doc("A metric dimension whose value is sourced from an environment variable.")
model TelemetryDimension {
  @doc("Dimension name emitted to Geneva.")
  dimension: string;

  @doc("Environment variable that supplies the dimension value at runtime.")
  envVar: string;
}

@doc("Geneva MDM transform rule.")
model MdmTransformRule {
  @doc("Condition selecting the metrics to transform.")
  condition: MdmTransformCondition;

  @doc("Operations applied to matching metrics.")
  @identifiers(#[])
  operations: MdmTransformOperation[];
}

@doc("Geneva MDM transform condition.")
model MdmTransformCondition {
  @doc("Condition type.")
  type: MdmTransformConditionType;

  @doc("Optional metrics account filter.")
  account?: string;

  @doc("Optional metrics namespace filter.")
  @encodedName("application/json", "namespace")
  namespaceName?: string;

  @doc("Optional metric name filter.")
  name?: string;
}

@doc("Geneva MDM transform condition type.")
union MdmTransformConditionType {
  string,

  @doc("Apply to every metric.")
  Any: "any",

  @doc("Apply to metrics matching account, namespace, or metric name.")
  SetDimension: "metric_key",
}

@doc("Geneva MDM transform operation.")
model MdmTransformOperation {
  @doc("Operation value type.")
  operationType: MdmTransformOperationValueType;

  @doc("Dimension name to set.")
  dimensionName: string;

  @doc("Literal value or environment-variable name used by value/envVar operation types.")
  dimensionValue?: string;

  @doc("Built-in Geneva function used by the function operation type.")
  function?: MdmTransformFunction;
}

@doc("Geneva MDM transform operation value type.")
union MdmTransformOperationValueType {
  string,

  @doc("Use a literal value.")
  Value: "value",

  @doc("Read the value from an environment variable.")
  EnvVar: "env_var",

  @doc("Use a built-in Geneva function.")
  Function: "function",
}

@doc("Built-in Geneva MDM transform functions exposed by ConfigGen.")
union MdmTransformFunction {
  string,

  @doc("Use the host name.")
  Hostname: "hostname",

  @doc("Use the application platform machine function.")
  ApMachineFunction: "ap_machine_function",

  @doc("Use the application platform machine name.")
  ApMachineName: "ap_machine_name",

  @doc("Use the application platform environment.")
  ApEnvironment: "ap_environment",

  @doc("Use the application platform cluster.")
  ApCluster: "ap_cluster",

  @doc("Use the source identifier.")
  SourceId: "source_id",
}

@doc("OpenTelemetry receiver settings for Geneva MDM.")
model OpenTelemetryConfig {
  @doc("Whether the OpenTelemetry receiver is enabled.")
  enabled?: boolean;

  @doc("OTLP receiver port.")
  otlpPort?: int32;

  @doc("Maximum OTLP receive message size in MB.")
  @encodedName("application/json", "maxReceiveMessageSizeMBytes")
  maxReceiveMessageSizeMbytes?: int32;
}

@doc("MDSD collector configuration.")
model MdsdConfig {
  @doc("MDSD certificate secret name. The platform maps the secret through the configured secret/CSI mechanism.")
  secretName?: string;

  @doc("Compute resources for the MDSD sidecar.")
  resources?: ComputeResources;
}

@doc("Named MDSD collector configuration.")
model NamedMdsdConfig {
  ...MdsdConfig;

  @doc("Name of the additional MDSD sidecar/pipeline.")
  name: string;
}

@doc("File log tailing sidecar configuration.")
model LogTailConfig {
  @doc("Whether log tailing is enabled.")
  enabled?: boolean;

  @doc("Compute resources for the log tail sidecar.")
  resources?: ComputeResources;

  @doc("Files and container mappings to tail.")
  @identifiers(#["fileName"])
  sources?: LogTailSource[];
}

@doc("A file and container mapping for log tailing.")
model LogTailSource {
  @doc("Path or name of the file to tail.")
  fileName: string;

  @doc("Container that owns the tailed file.")
  containerName: string;

  @doc("Exclude this source from the raw log tailer.")
  excludeLogTailer?: boolean;
}

@doc("Probe configuration for liveness, readiness, and startup health monitors.")
model WorkloadProbesConfig {
  @doc("Liveness probe configuration.")
  liveness?: ProbeConfig;

  @doc("Readiness probe configuration.")
  readiness?: ProbeConfig;

  @doc("Startup probe configuration.")
  startup?: ProbeConfig;
}

@doc("A Kubernetes probe configuration.")
@discriminator("type")
model ProbeConfig {
  @doc("Probe type.")
  type: ProbeType;

  @doc("Whether this probe is enabled.")
  enabled?: boolean;

  @doc("Number of failures before the probe is considered failed.")
  failureThreshold?: int32;

  @doc("Initial delay in seconds before probing starts.")
  initialDelaySeconds?: int32;

  @doc("Probe period in seconds.")
  periodSeconds?: int32;

  @doc("Number of successes required after failure.")
  successThreshold?: int32;

  @doc("Probe timeout in seconds.")
  timeoutSeconds?: int32;
}

@doc("Probe type.")
union ProbeType {
  string,

  @doc("Use an HTTP GET probe.")
  HttpGet: "httpGet",

  @doc("Use a TCP socket probe.")
  TcpSocket: "tcpSocket",

  @doc("Use a command execution probe.")
  Exec: "exec",
}

@doc("HTTP GET probe configuration.")
model HttpGetProbeConfig extends ProbeConfig {
  type: ProbeType.HttpGet;

  @doc("HTTP path to probe.")
  path: string;

  @doc("HTTP port to probe.")
  port: int32;

  @doc("HTTP headers to send with the probe.")
  @identifiers(#["name"])
  httpHeaders?: HttpHeader[];

  @doc("Whether to use HTTPS for the probe.")
  https?: boolean;
}

@doc("TCP socket probe configuration.")
model TcpSocketProbeConfig extends ProbeConfig {
  type: ProbeType.TcpSocket;

  @doc("TCP port to probe.")
  port: int32;
}

@doc("Exec command probe configuration.")
model ExecProbeConfig extends ProbeConfig {
  type: ProbeType.Exec;

  @doc("Command and arguments to execute.")
  command: string[];
}

@doc("HTTP header used by a probe.")
model HttpHeader {
  @doc("Header name.")
  name: string;

  @doc("Header value.")
  value: string;
}

@doc("Kubernetes Service object settings used by observability probes and ingress.")
model ObservabilityServiceConfig {
  @doc("Whether to create a Kubernetes Service object.")
  enabled?: boolean;

  @doc("Override for the generated service name.")
  serviceNameOverride?: string;

  @doc("Use the Helm fullname as the Service name.")
  useFullnameAsServiceName?: boolean;

  @doc("Single service port.")
  port?: int32;

  @doc("Multiple service ports.")
  @identifiers(#["name"])
  ports?: ObservabilityServicePort[];

  @doc("Load balancer settings.")
  loadBalancer?: ObservabilityLoadBalancerConfig;
}

@doc("Kubernetes Service port.")
model ObservabilityServicePort {
  @doc("Port name.")
  name: string;

  @doc("Port exposed by the Service.")
  port: int32;

  @doc("Target port exposed by the workload.")
  targetPort: string;

  @doc("Network protocol.")
  protocol?: string;

  @doc("Application protocol.")
  appProtocol?: string;
}

@doc("Kubernetes Service LoadBalancer settings.")
model ObservabilityLoadBalancerConfig {
  @doc("Azure public IP resource name.")
  ipName?: string;

  @doc("Azure resource group containing the public IP.")
  resourceGroup?: string;

  @doc("External traffic policy.")
  externalTrafficPolicy?: string;

  @doc("Additional LoadBalancer annotations.")
  annotations?: StringMap;
}

@doc("Telemetry routing configuration.")
model TelemetryRoutingConfig {
  @doc("Closed set of log routes.")
  @identifiers(#["name"])
  logRoutes?: TelemetryLogRoute[];

  @doc("Closed set of metric routes.")
  @identifiers(#["name"])
  metricRoutes?: TelemetryMetricRoute[];
}

@doc("A named log route.")
model TelemetryLogRoute {
  @doc("Route name.")
  name: string;

  @doc("Destination backend.")
  destination: TelemetryLogDestination;
}

@doc("A named metric route.")
model TelemetryMetricRoute {
  @doc("Route name.")
  name: string;

  @doc("Destination backend.")
  destination: TelemetryMetricDestination;
}

@doc("Supported log destinations.")
union TelemetryLogDestination {
  string,

  @doc("Send logs to Geneva MDSD.")
  GenevaMdsd: "genevaMdsd",

  @doc("Send logs to the log tail collector.")
  LogTail: "logTail",

  @doc("Send logs to Fluentd.")
  Fluentd: "fluentd",

  @doc("Send logs to Splunk.")
  Splunk: "splunk",
}

@doc("Supported metric destinations.")
union TelemetryMetricDestination {
  string,

  @doc("Send metrics to Geneva MDM.")
  GenevaMdm: "genevaMdm",

  @doc("Send metrics to Prometheus.")
  Prometheus: "prometheus",

  @doc("Send metrics using OpenTelemetry Protocol.")
  Otlp: "otlp",
}

@doc("Operator-managed observability integration flags.")
model OperatorManagedObservabilityConfig {
  @doc("Enable the operator-managed telemetry resources for this workload.")
  enabled?: boolean;

  @doc("Enable GBF/operator-managed bootstrap integration for observability sidecars.")
  gbfEnabled?: boolean;

  @doc("Let the operator manage telemetry certificates/secrets instead of requiring explicit sidecar secret names.")
  manageCertificates?: boolean;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" ""
@doc("String key/value map used for annotations and labels whose keys are user-defined.")
model StringMap is Record<string>;

@doc("Job specific configuration.")
model JobProfile {
  @doc("The number of instances to run in parallel.")
  parallelism?: int32;

  @doc("The desired number of successfully completed instances.")
  completions?: int32;

  @doc("Maximum number of retries before the job is marked failed.")
  backoffLimit?: int32;

  @doc("Seconds to retain a finished job before automatic cleanup.")
  ttlSecondsAfterFinished?: int32;

  @doc("Restart policy for the job's pods.")
  restartPolicy?: RestartPolicy;
}

@doc("A non-sensitive environment variable.")
model EnvironmentVariable {
  @doc("Environment variable name.")
  @pattern("^[A-Za-z_][A-Za-z0-9_]*$")
  name: string;

  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" ""
  @doc("Environment variable value.")
  value: string;
}

@doc("Aggregate health of a workload.")
union WorkloadHealth {
  string,
  @doc("The workload is healthy.")
  Healthy: "Healthy",
  @doc("The workload is progressing (rolling out).")
  Progressing: "Progressing",
  @doc("The workload is degraded.")
  Degraded: "Degraded",
  @doc("The workload health is unknown.")
  Unknown: "Unknown",
}

@doc("Replica counts for a Service deployment.")
model ReplicaStatus {
  @doc("Desired number of replicas.")
  desired?: int32;

  @doc("Number of ready replicas.")
  ready?: int32;

  @doc("Number of available replicas.")
  available?: int32;

  @doc("Number of updated replicas.")
  updated?: int32;

  @doc("Number of unavailable replicas.")
  unavailable?: int32;
}

@doc("A status condition observed on a workload.")
model StatusCondition {
  @doc("Condition type.")
  type?: string;

  @doc("Condition status.")
  status?: string;

  @doc("Reason for the condition.")
  reason?: string;

  @doc("Human-readable message.")
  message?: string;

  @doc("Last transition time.")
  lastTransitionTime?: utcDateTime;
}

@doc("Read-only projection of a Service's actual deployment in the cluster.")
model ServiceDeploymentStatus {
  @doc("Name of the deployment.")
  deploymentName?: string;

  @doc("Image reference currently running.")
  currentImage?: string;

  @doc("Current rollout revision.")
  revision?: int32;

  @doc("Last generation observed by the controller.")
  observedGeneration?: int64;

  @doc("Replica counts.")
  replicas?: ReplicaStatus;

  @doc("Aggregate health.")
  health?: WorkloadHealth;

  @identifiers(#[])
  @doc("Deployment conditions.")
  conditions?: StatusCondition[];
}

@doc("Read-only projection of a Job's actual execution in the cluster.")
model JobExecutionStatus {
  @doc("Name of the job execution.")
  executionName?: string;

  @doc("Start time.")
  startTime?: utcDateTime;

  @doc("Completion time.")
  completionTime?: utcDateTime;

  @doc("Number of actively running instances.")
  active?: int32;

  @doc("Number of instances that succeeded.")
  succeeded?: int32;

  @doc("Number of instances that failed.")
  failed?: int32;

  @identifiers(#[])
  @doc("Execution conditions.")
  conditions?: StatusCondition[];
}

@doc("Read-only projection of a CronJob's actual executions in the cluster.")
model CronJobExecutionStatus {
  @doc("Name of the CronJob.")
  cronJobName?: string;

  @doc("Last time the CronJob was scheduled.")
  lastScheduleTime?: utcDateTime;

  @doc("Last time a scheduled job successfully completed.")
  lastSuccessfulTime?: utcDateTime;

  @identifiers(#["executionName"])
  @doc("Job executions spawned by this CronJob.")
  executions?: JobExecutionStatus[];
}
