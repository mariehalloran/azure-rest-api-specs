namespace Microsoft.Migrate;

@doc("An Internet Protocol version 4 network prefix in Classless Inter-Domain Routing notation.")
@pattern("^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}/([0-9]|[12][0-9]|3[0-2])$")
scalar Ipv4CidrPrefix extends string;
