import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

namespace Microsoft.MessagingConnectors.Models.DataSource.Solace;

@doc("Configuration for SolacePubsubSource")
model SolacePubsubSourceConnectorProperties extends DataSourceProperties {
  @doc("Type of SolacePubsubSourceConnector")
  connectorType: Models.Connector.ConnectorType.SolacePubsubSource;

  @doc("Solace Pubsub+ connection URI, e.g. tcp://127.0.0.1:55555.")
  connectionUri: url;

  @doc("Solace Pubsub+ connection username. Optional when using client certificate authentication.")
  userName?: string;

  @doc("Solace Pubsub+ connection password. Optional when using client certificate authentication.")
  @secret
  password?: string;

  @doc("Client certificate authentication for Solace mTLS.")
  clientCertAuthentication?: Models.Auth.CertificateAuthentication;

  @doc("Configuration for ssl.")
  sslConfiguration?: Models.Auth.SslConfiguration;

  @doc("Solace Pubsub+ message VPN name.")
  messageVpn: string;

  @doc("Comma separated list of PubSub+ topics to subscribe to.")
  solaceTopics?: string[];

  @doc("PubSub+ queue name to consume from, must exist on event broker.")
  solaceQueue?: string;

  @doc("PubSub+ Kafka Source connector message processor. PubSub+ Kafka Source connector message processor Refer to https://github.com/SolaceProducts/pubsubplus-connector-kafka-source")
  messageProcessor?: string;

  @doc("If enabled, maps/forwards the user properties Map from Solace message to Kafka record headers.")
  mapUserProperties?: boolean;

  @doc("If enabled, maps/forwards the Solace message standard properties (e.g. correlationId, applicationMessageId, redelivered, dmqEligible, COS etc) to Kafka record headers")
  mapSolaceProperties?: boolean;

  #suppress "@azure-tools/typespec-azure-resource-manager/secret-prop" "not a secret"
  @doc("When using SolaceSampleKeyedMessageProcessor, defines which part of a PubSub+ message shall be converted to a Kafka record key")
  kafkaMessageKey?: string;

  @doc("Enable system metadata.")
  enableSystemMetadata?: boolean;
}
