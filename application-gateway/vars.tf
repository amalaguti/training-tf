variable "location" {
  type    = string
  default = "southcentralus"
}

variable "subscription_id" {
  type    = string
  default = "ba11dd43-5df0-464d-868f-fd3a7503e680"
}

variable "prefix" {
  type    = string
  default = "adrian-demo"
}

variable "zones" {
  type    = list(string)
  default = []
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}
