locals {
  passwords = ["random_string", "wordpress_password"]
}

resource "random_password" "pw" {
  for_each    = toset(local.passwords)
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = false
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.repo_digest != "" ? docker_image.mysql.repo_digest : "mysql:8"
  name  = "mysql-container"

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.pw["random_string"].result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.pw["wordpress_password"].result}",
    "MYSQL_ROOT_HOST=%"
  ]

  ports {
    internal = 3306
    external = 3306
  }
}

output "mysql_root_password" {
  value     = random_password.pw["random_string"].result
  sensitive = true
}

output "mysql_wordpress_password" {
  value     = random_password.pw["wordpress_password"].result
  sensitive = true
}

resource "aws_ssm_parameter" "mysql_root_password" {
  name  = "/mysql/root_password"
  type  = "SecureString"
  value = random_password.pw["random_string"].result
}

resource "aws_ssm_parameter" "mysql_wordpress_password" {
  name  = "/mysql/wordpress_password"
  type  = "SecureString"
  value = random_password.pw["wordpress_password"].result
}
