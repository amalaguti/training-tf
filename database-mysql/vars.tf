variable "location" {
  type    = string
  default = "westeurope"
}

variable "subscription_id" {
  type    = string
  default = "ba11dd43-5df0-464d-868f-fd3a7503e680"
}

variable "prefix" {
  type    = string
  default = "adrian-demo"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "private-cidr" {
  type    = string
  default = "10.0.0.0/24"
}
