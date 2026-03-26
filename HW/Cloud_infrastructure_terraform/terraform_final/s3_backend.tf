terraform {
  backend "s3" {
    bucket         = "paniqed-beaver"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

resource "yandex_iam_service_account" "sa_tf" {
  name        = "tfstate-sa"
  description = "Service account for Terraform remote state"
  folder_id   = var.folder_id
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

data "yandex_iam_service_account" "sa_lockbox" {
  service_account_id = "ajek4jtrb20qukeql59k"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_lockbox_viewer" {
  folder_id = var.folder_id
  role      = "lockbox.payloadViewer"
  member    = "serviceAccount:${data.yandex_iam_service_account.sa_lockbox.id}"
}

output "bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = "lao-ush244oz"
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
