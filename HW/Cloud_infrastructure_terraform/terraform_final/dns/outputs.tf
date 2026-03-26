output "zone_id" {
  description = "ID of the DNS zone"
  value       = yandex_dns_zone.main.id
}

output "domain_fqdn" {
  description = "DNS zone name with trailing dot"
  value       = yandex_dns_zone.main.zone
}

output "domain" {
  description = "DNS zone name without trailing dot"
  value       = trimsuffix(yandex_dns_zone.main.zone, ".")
}
