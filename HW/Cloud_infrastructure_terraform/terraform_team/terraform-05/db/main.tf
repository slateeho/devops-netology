resource "yandex_mdb_mysql_cluster" "my_cluster" {
  name        = var.cluster_name
  environment = var.environment
  network_id  = var.network_id
  version     = var.mysql_version
  security_group_ids = [var.security_group_id]

  resources {
    resource_preset_id = var.resource_preset_id
    disk_type_id       = var.disk_type_id
    disk_size          = var.disk_size
  }

  maintenance_window {
    type = var.maintenance_type
    day  = var.maintenance_day
    hour = var.maintenance_hour
  }

  dynamic "host" {
    for_each = var.ha ? toset([0, 1]) : toset([0])
    content {
      zone             = host.key == 0 ? "ru-central1-a" : "ru-central1-b"
      subnet_id        = var.subnet_ids[host.key]
      assign_public_ip = var.assign_public_ip
    }
  }
}

resource "yandex_mdb_mysql_database" "my_db" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = var.database_name
}

resource "yandex_mdb_mysql_user" "my_user" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = var.user_name
  password   = var.user_password

  depends_on = [yandex_mdb_mysql_database.my_db]

  dynamic "permission" {
    for_each = var.user_permissions
    content {
      database_name = permission.value.database_name
      roles         = permission.value.roles
    }
  }

  connection_limits {
    max_questions_per_hour   = var.max_questions_per_hour
    max_updates_per_hour     = var.max_updates_per_hour
    max_connections_per_hour = var.max_connections_per_hour
    max_user_connections     = var.max_user_connections
  }

  global_permissions    = var.global_permissions
  authentication_plugin = var.authentication_plugin
}
