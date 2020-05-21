variable "name" { default = "" }
variable "names" {
  type = list
  default = []
}
variable "lifecycle_policy" { default = "" }
variable "repository_policy" { default = "" }
variable "scan_images" { default = false }