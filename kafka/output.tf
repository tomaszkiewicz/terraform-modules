output "zookeeper_connection_string" {
  value = compact(split(",", aws_msk_cluster.kafka.zookeeper_connect_string))
}

output "bootstrap_brokers" {
  value = compact(split(",", aws_msk_cluster.kafka.bootstrap_brokers))
}

output "bootstrap_brokers_tls" {
  value = compact(split(",", aws_msk_cluster.kafka.bootstrap_brokers_tls))
}
