locals {
  debian_instances = yandex_compute_instance.debian

  ssh_public_key  = trimspace(file("${path.module}/id_ed25519.pub"))
  ssh_private_key = file("${path.module}/id_ed25519")
  private_key = abspath("${path.module}/id_ed25519")
}
