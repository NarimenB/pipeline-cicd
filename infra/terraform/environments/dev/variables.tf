variable "app_name" {
  type    = string
  default = "devops-app"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "web_replicas" {
  type    = number
  default = 2
}

variable "web_port_start" {
  type    = number
  default = 8080
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "app_log_level" {
  type    = string
  default = "info"
}