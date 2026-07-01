output "ansible_host" {
  value = {
    name = docker_container.db.name
    port = var.db_port
  }
}