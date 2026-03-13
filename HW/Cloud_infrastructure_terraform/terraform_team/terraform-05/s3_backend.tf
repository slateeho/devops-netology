terraform {
  backend "s3" {
    bucket  = "lao-ush244oz"
    key     = "terraform.tfstate"
    region  = "ru-central1"

    use_lockfile = true

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}


resource "yandex_iam_service_account" "sa_tf" {
  name        = "tfstate-sa"
  description = "Service account for Terraform remote state"
}


resource "yandex_resourcemanager_folder_iam_member" "sa_tf_admin_s3" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_iam_service_account_static_access_key" "sa_tf_static_key" {
  service_account_id = yandex_iam_service_account.sa_tf.id
  description        = "Static access key for tfstate bucket"
}


output "bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = var.s3_backend["bucket"]
}

output "access_key_id" {
  description = "Access key ID for S3 backend"
  value       = yandex_iam_service_account_static_access_key.sa_tf_static_key.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Secret key for S3 backend"
  value       = yandex_iam_service_account_static_access_key.sa_tf_static_key.secret_key
  sensitive   = true
}

output "backend_config" {
  description = "Backend configuration as map"
  value = merge(var.s3_backend, {
    access_key = yandex_iam_service_account_static_access_key.sa_tf_static_key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa_tf_static_key.secret_key
  })
  sensitive = true
}
