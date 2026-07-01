terraform {
  required_version = ">= 1.6"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "devops-${var.environment}"
}

module "webapp" {
  source         = "../../modules/webapp"
  app_name       = var.app_name
  environment    = var.environment
  web_replicas   = var.web_replicas
  web_port_start = var.web_port_start
  network_name   = docker_network.app_network.name
}

module "database" {
  source       = "../../modules/database"
  app_name     = var.app_name
  environment  = var.environment
  network_name = docker_network.app_network.name
  db_password  = var.db_password
  db_port      = var.db_port
}

output "ansible_inventory" {
  value = yamlencode({
    all = {
      vars = {
        ansible_connection         = "docker"
        ansible_python_interpreter = "/usr/bin/python3"
        app_name                   = var.app_name
        app_environment            = var.environment
        app_log_level              = var.app_log_level
        database_host              = module.database.ansible_host.name
        database_port              = module.database.ansible_host.port
      }
      children = {
        webservers = {
          hosts = module.webapp.ansible_hosts
        }
        databases = {
          hosts = {
            (module.database.ansible_host.name) = {}
          }
        }
      }
    }
  })
}