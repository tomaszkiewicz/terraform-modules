variable "type"{
    default = "SecureString"
    type = string
}
variable "tenant"{
    type = string
}
variable "product"{
    type = string
}
variable "keys"{
    type = list(string)
}
variable "key_id"{
    type = string
}