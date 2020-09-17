output "zookeeper_connection_string" {
  value = compact(split(",", join("", aws_msk_cluster.kafka.*.zookeeper_connect_string)))
}

output "bootstrap_brokers" {
  value = sort(compact(split(",", join("", aws_msk_cluster.kafka.*.bootstrap_brokers))))
}

output "bootstrap_brokers_tls" {
  value = sort(compact(split(",", join("", aws_msk_cluster.kafka.*.bootstrap_brokers_tls))))
}
