variable "log_group_name" {}
variable "metric_namespace" { default = "LogMetrics" }
variable "notifications_sns_topic_arn" { default = "" }

locals {
  metrics = [
    {
      name    = "unauthorized-api-calls"
      pattern = <<EOF
{($.errorCode="*UnauthorizedOperation") || ($.errorCode="AccessDenied*")}
EOF
    },
    {
      name    = "console-signin-without-mfa"
      pattern = <<EOF
{($.eventName="ConsoleLogin") && ($.additionalEventData.MFAUsed !="Yes")}
EOF
    },
    {
      name    = "root-account-usage"
      pattern = <<EOF
{$.userIdentity.type="Root" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !="AwsServiceEvent"}
EOF
    },
    {
      name    = "iam-policy-changes"
      pattern = <<EOF
{($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}
EOF
    },
    {
      name    = "cloud-trail-changes"
      pattern = <<EOF
{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}
EOF
    },
    {
      name    = "console-authentication-failed"
      pattern = <<EOF
{($.eventName=ConsoleLogin) && ($.errorMessage="Failed authentication")}
EOF
    },
    {
      name    = "disable-or-delete-cmk"
      pattern = <<EOF
{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}
EOF
    },
    {
      name    = "s3-bucket-policy-changes"
      pattern = <<EOF
{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}
EOF
    },
    {
      name    = "aws-config-changes"
      pattern = <<EOF
{($.eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}
EOF
    },
    {
      name    = "security-group-changes"
      pattern = <<EOF
{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEgress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}
EOF
    },
    {
      name    = "network-acl-changes"
      pattern = <<EOF
{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}
EOF
    },
    {
      name    = "network-gateway-changes"
      pattern = <<EOF
{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}
EOF
    },
    {
      name    = "route-table-changes"
      pattern = <<EOF
{($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable)}
EOF
    },
    {
      name    = "vpc-changes"
      pattern = <<EOF
{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}
EOF
    },
    #     {
    #       name    = ""
    #       pattern = <<EOF
    # EOF
    #     },
  ]
}

module "metric" {
  for_each = { for x in local.metrics : x.name => x }
  source   = "../log-metric-alert"

  name                        = x.name
  metric_name                 = x.name
  pattern                     = x.pattern
  log_group_name              = var.log_group_name
  metric_namespace            = var.metric_namespace
  notifications_sns_topic_arn = var.notifications_sns_topic_arn
}
