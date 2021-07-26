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

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "ip-config" {
  default = [
    {
      name       = "instance1-ip1"
      allocation = "Dynamic"
      primary    = true
    },
    {
      name       = "instance1-ip2"
      allocation = "Dynamic"
      primary    = false
    },
  ]
}

variable "project_tags" {
  type          = map(string)
  default       = {
    component   = "Frontend"
    environment = "Production"
  }
}
