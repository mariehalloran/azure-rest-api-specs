import "@typespec/versioning";

using TypeSpec.Versioning;

namespace Microsoft.SecurityContext;

/** Severity assigned to a security observation. */
@added(Versions.v2026_07_13_preview)
union FindingSeverity {
  /** Critical severity. */
  Critical: "Critical",

  /** High severity. */
  High: "High",

  /** Medium severity. */
  Medium: "Medium",

  /** Low severity. */
  Low: "Low",

  /** Informational severity. */
  Informational: "Informational",

  /** The source did not assign a known severity. */
  Unknown: "Unknown",

  string,
}

/** Lifecycle status of a security observation. */
@added(Versions.v2026_07_13_preview)
union FindingStatus {
  /** The observation is active. */
  Active: "Active",

  /** The observation has been resolved. */
  Resolved: "Resolved",

  /** The observation has been suppressed. */
  Suppressed: "Suppressed",

  /** The source did not assign a known status. */
  Unknown: "Unknown",

  string,
}

/** Scope on which a software vulnerability was observed. */
@added(Versions.v2026_07_13_preview)
union VulnerabilityScope {
  /** A vulnerability observed on a host. */
  Host: "Host",

  /** A vulnerability observed in a container image or workload. */
  Container: "Container",

  string,
}

/** Exploitability status reported for a vulnerability. */
@added(Versions.v2026_07_13_preview)
union ExploitStatus {
  /** Exploitation is known to occur in the wild. */
  KnownExploited: "KnownExploited",

  /** Exploit code is publicly available. */
  ExploitAvailable: "ExploitAvailable",

  /** No exploit is known to the reporting source. */
  NoKnownExploit: "NoKnownExploit",

  /** Exploitability is unknown. */
  Unknown: "Unknown",

  string,
}

/** Transport protocol associated with an internet exposure. */
@added(Versions.v2026_07_13_preview)
union TransportProtocol {
  /** Transmission Control Protocol. */
  Tcp: "TCP",

  /** User Datagram Protocol. */
  Udp: "UDP",

  string,
}

/** Properties common to SecurityContext observation resources. */
@added(Versions.v2026_07_13_preview)
model ObservationProperties {
  /** The registered lowercase slug of the system that produced the observation. */
  @visibility(Lifecycle.Read)
  @minLength(1)
  @maxLength(64)
  @pattern("^[a-z0-9]+(?:-[a-z0-9]+)*$")
  sourceSystem: string;

  /** The stable lowercase slug, unique for this record within its source system and tenant. */
  @visibility(Lifecycle.Read)
  @minLength(1)
  @maxLength(190)
  @pattern("^[a-z0-9]+(?:-[a-z0-9]+)*$")
  sourceRecordId: string;

  /** A human-readable name for the observation. */
  @visibility(Lifecycle.Read)
  @maxLength(256)
  displayName?: string;

  /** The severity assigned to the observation. */
  @visibility(Lifecycle.Read)
  severity: FindingSeverity;

  /** The lifecycle status of the observation. */
  @visibility(Lifecycle.Read)
  status: FindingStatus;

  /** The most recent time the published observation changed. */
  @visibility(Lifecycle.Read)
  lastUpdatedAt: utcDateTime;

  /** The Service Tree service identifier associated with the observation. */
  @visibility(Lifecycle.Read)
  @maxLength(128)
  serviceTreeId?: string;
}
