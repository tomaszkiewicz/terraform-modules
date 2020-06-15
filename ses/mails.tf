resource "aws_ses_email_identity" "mail" {
  for_each = toset(var.mails)

  email = each.value
}
