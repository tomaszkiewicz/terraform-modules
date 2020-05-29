output "instance_endpoint" {
  value = module.database.this_db_instance_endpoint
}

output "host" {
  value = split(":", module.database.this_db_instance_endpoint)[0]
}

output "address" {
  value = split(":", module.database.this_db_instance_endpoint)[0]
}

output "endpoint" {
  value = module.database.this_db_instance_endpoint
}

output "arn" {
  value = module.database.this_db_instance_arn
}

output "id" {
  value = module.database.this_db_instance_id
}

output "port" {
  value = var.port
}

output "username" {
  value = var.username
}

output "password" {
  value = local.password
}