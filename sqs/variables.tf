variable "name" {}
variable "fifo" { default = false }
variable "max_message_size" { default = 262144 }
variable "delay_seconds" { default = 0 }
variable "message_retention_seconds" { default = 120 }
variable "receive_wait_time_seconds" { default = 0 }
variable "visibility_timeout_seconds" { default = 30 }
variable "max_receive_count" { default = 3 }
variable "notifications_sns_topic_arn" { default = "" }
variable "dead_letter_delay_seconds" { default = 0 }
variable "dead_letter_message_retention_seconds" { default = 262144 }
variable "dead_letter_receive_wait_time_seconds" { default = 0 }
variable "dead_letter_visibility_timeout_seconds" { default = 30 }