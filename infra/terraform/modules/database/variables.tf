variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "network_name" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = number
  default = 5432
}