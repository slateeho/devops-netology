variable "lockbox_secret_name" {
  description = "Lockbox secret name"
  type        = string
  default     = "db-credentials"
}

resource "yandex_lockbox_secret" "db_credentials" {
  name      = var.lockbox_secret_name
  folder_id = var.folder_id
}

resource "yandex_lockbox_secret_version" "db_credentials" {
  secret_id = yandex_lockbox_secret.db_credentials.id


  entries {
    key        = "db_primary_ip"
    text_value = module.db.db_primary_ip
  }

  entries {
    key        = "db_user_password"
    text_value = random_password.db_password.result
  }

  entries {
    key        = "db_user_name"
    text_value = var.user_name
  }

  entries {
    key        = "db_database_name"
    text_value = var.database_name
  }

  entries {
    key        = "ssh_private_key"
    text_value = file("${path.module}/id_ed25519")
  }
}
