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
  name = "devops-dev"
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true
}

resource "docker_container" "web" {
  count = 2
  name  = "${var.app_name}-${var.environment}-${count.index}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8080 + count.index
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "NGINX_HOST=localhost",
    "NGINX_PORT=80"
  ]
}

resource "docker_container" "db" {
  name  = "${var.app_name}-db-${var.environment}"
  image = docker_image.postgres.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "POSTGRES_PASSWORD=secret123",
    "POSTGRES_DB=devops"
  ]
}

output "web_urls" {
  value = [for c in docker_container.web : "http://localhost:${c.ports[0].external}"]
}

output "container_names" {
  value = [for c in docker_container.web : c.name]
}

locals {
  common_tags = {
    project     = var.app_name
    environment = var.environment
    managed_by  = "terraform"
  }
  container_name = "${var.app_name}-${var.environment}"
}

data "docker_network" "bridge" {
  name = "bridge"
}