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

@doc("Compute resources.")
model ComputeResources {
  @doc("CPU requests and limits.")
  cpu?: ResourceRequestsLimits;

  @doc("Memory requests and limits.")
  memory?: ResourceRequestsLimits;
}

@doc("Resource requests and limits.")
model ResourceRequestsLimits {
  @doc("Kubernetes resource quantity requested by the workload, such as `500m` CPU or `512Mi` memory.")
  request?: string;

  @doc("Kubernetes resource quantity limit for the workload, such as `1` CPU or `1Gi` memory.")
  limit?: string;
}

@doc("Shared observability settings used as cluster defaults, namespace overrides, and workload overrides.")
model ObservabilityDefaults {
  @doc("Metrics collection configuration.")
  metrics?: WorkloadMetricsConfig;

  @doc("Log collection configuration.")
  logs?: WorkloadLogsConfig;

  @doc("Audit log collection configuration.")
  auditLogs?: WorkloadAuditLogsConfig;

  @doc("Geneva Metrics (MDM) sidecar configuration.")
  mdm?: MdmConfig;

  @doc("Additional Geneva Metrics (MDM) sidecars when more than one metrics pipeline is needed.")
  @identifiers(#["name"])
  extraMdms?: NamedMdmConfig[];

  @doc("File log tailing sidecar configuration.")
  logTail?: LogTailConfig;

  @doc("Path mounted into telemetry sidecars for application log files.")
  logsMountPath?: string;

  @doc("High throughput telemetry pipeline configuration.")
  highThroughput?: HighThroughputConfig;

  @doc("Additional Geneva Monitoring Agent (MDSD) log collector sidecars when the high-throughput logs pipeline needs more than one collector.")
  @identifiers(#["name"])
  extraMdsds?: NamedMdsdConfig[];

  @doc("Container probe configuration for liveness, readiness, and startup health monitoring.")
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

  @doc("Whether personally identifiable information (PII) filtering is enabled before emitting metrics dimensions.")
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

  @doc("Whether personally identifiable information (PII) filtering is enabled before logs are routed to telemetry backends.")
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

  @doc("Geneva Metrics (MDM) namespace for high-throughput metrics.")
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

  @doc("Geneva Monitoring Agent (MDSD) collector used by the high-throughput logs pipeline.")
  mdsd?: MdsdConfig;
}

@doc("Geneva Metrics (MDM) sidecar configuration.")
model MdmConfig {
  @doc("Whether the MDM sidecar is enabled.")
  enabled?: boolean;

  @doc("Compute resources for the MDM sidecar.")
  resources?: ComputeResources;

  @doc("Certificate secret name. The platform maps the secret through the configured secret / Container Storage Interface (CSI) mechanism. This is a reference to a secret in the configured store, not the secret value itself.")
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

  @doc("Azure Container Registry (ACR) URL used for the Geneva Metrics (MDM) image when the shared chart cannot infer it.")
  azureContainerRegistryUrl?: url;

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
  MetricKey: "metric_key",
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

@doc("Built-in Geneva Metrics (MDM) transform functions.")
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

  @doc("OpenTelemetry Protocol (OTLP) receiver port.")
  otlpPort?: int32;

  @doc("Maximum OTLP receive message size in MB.")
  @encodedName("application/json", "maxReceiveMessageSizeMBytes")
  maxReceiveMessageSizeMbytes?: int32;
}

@doc("Geneva Monitoring Agent (MDSD) collector configuration.")
model MdsdConfig {
  @doc("Geneva Monitoring Agent (MDSD) certificate secret name. The platform maps the secret through the configured secret / Container Storage Interface (CSI) mechanism. This is a reference to a secret in the configured store, not the secret value itself.")
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

  @doc("Target port exposed by the workload, specified as a decimal numeric string or a named Kubernetes container port.")
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

  @doc("Enable Geneva Bit Forwarder (GBF)/operator-managed bootstrap integration for observability sidecars.")
  gbfEnabled?: boolean;

  @doc("Let the operator manage telemetry certificates/secrets instead of requiring explicit sidecar secret names.")
  manageCertificates?: boolean;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "StringMap models user-defined Kubernetes labels and annotations whose keys are not knowable in advance, so an open string-to-string map is required."
@doc("String key/value map used for annotations and labels whose keys are user-defined.")
model StringMap is Record<string>;
