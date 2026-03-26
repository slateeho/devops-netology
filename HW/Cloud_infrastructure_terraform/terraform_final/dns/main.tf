resource "yandex_dns_zone" "main" {
  name        = var.name
  description = "DNS zone for ${var.name}"

  zone   = var.zone
  public = var.is_public

  folder_id        = var.folder_id
  private_networks = var.is_public ? null : var.private_networks

  deletion_protection = false
}

resource "yandex_dns_recordset" "root" {
  zone_id = yandex_dns_zone.main.id
  name    = "@"
  type    = "ANAME"
  ttl     = 600
  data    = ["${trim(var.zone, ".")}.website.yandexcloud.net"]
}

resource "yandex_dns_recordset" "www" {
  zone_id = yandex_dns_zone.main.id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  data    = [yandex_dns_zone.main.zone]
}

resource "yandex_dns_recordset" "api" {
  zone_id = yandex_dns_zone.main.id
  name    = "api"
  type    = "A"
  ttl     = 300
  data    = [var.web_vm_public_ip]
}

resource "yandex_dns_zone_iam_binding" "viewer" {
  dns_zone_id = yandex_dns_zone.main.id
  role        = "dns.viewer"
  members     = var.dns_members
}
