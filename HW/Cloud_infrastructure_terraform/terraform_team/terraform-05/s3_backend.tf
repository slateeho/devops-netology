output "s3_access_key" {
  value       = local.s3_keys.access_key.key_id
  depends_on  = [local.s3_keys]
}

output "s3_secret_key" {
  value       = local.s3_keys.secret
  sensitive   = true
  depends_on  = [local.s3_keys]
}
