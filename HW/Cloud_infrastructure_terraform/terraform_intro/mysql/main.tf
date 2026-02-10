pariable "vm_id" {
  type = string
}

variable "docker_host" {
  type = string
}

variable "docker_ssh_opts" {
  type = list(string)
}

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric =\\ 1
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = false
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.id
  name  = "mysql-container"

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.random_string.result}"
  ]

  ports {
    internal = 3306
    external = 3306
  }
}

output "mysql_password" {
  value     = random_password.random_string.result
  sensitive = true
}

