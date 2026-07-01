variable "app_name" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "web_replicas" {
  type    = number
  default = 2
}

variable "web_port_start" {
  type    = number
  default = 8080
}

variable "network_name" {
  type    = string
}