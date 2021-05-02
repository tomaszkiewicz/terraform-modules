resource "tls_private_key" "local" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "local" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.local.private_key_pem

  subject {
    common_name  = "${var.cluster_name}.local"
    organization = "Invalid"
  }

  validity_period_hours = 750

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  lifecycle {
    ignore_changes = [
      ready_for_renewal,
    ]
  }
}

resource "aws_acm_certificate" "local" {
  private_key      = tls_private_key.local.private_key_pem
  certificate_body = tls_self_signed_cert.local.cert_pem
}
