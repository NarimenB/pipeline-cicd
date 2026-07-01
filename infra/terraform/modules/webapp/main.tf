terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "app" {
  count = var.web_replicas
  name  = "${var.app_name}-${var.environment}-${count.index}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.web_port_start + count.index
  }

  networks_advanced {
    name = var.network_name
  }

  env = [
    "NGINX_HOST=localhost",
    "NGINX_PORT=80"
  ]
}