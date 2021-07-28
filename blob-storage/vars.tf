variable "location" {
  type    = string
  default = "southcentralus"
}

variable "subscription_id" {
  type    = string
  default = "ba11dd43-5df0-464d-868f-fd3a7503e680"
}

variable "failover_location" {
  type    = string
  default = "uksouth"
}

variable "prefix" {
  type    = string
  default = "demo"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "private-cidr" {
  type    = string
  default = "10.0.0.0/24"
}
