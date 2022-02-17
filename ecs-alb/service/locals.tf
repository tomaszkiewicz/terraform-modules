locals {
  sg_ports = concat([var.service_port,var.health_check_port,var.nfs], var.sg_ports)

  singlePort = [
          {
            hostPort : var.service_port
            protocol : "tcp"
            containerPort : var.service_port
          }
        ]
}