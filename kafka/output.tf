output "zookeeper_connect_string" {
  value = aws_msk_cluster.kafka.zookeeper_connect_string
}

output "bootstrap_brokers" {
  value = aws_msk_cluster.kafka.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  value = aws_msk_cluster.kafka.bootstrap_brokers_tls
}
