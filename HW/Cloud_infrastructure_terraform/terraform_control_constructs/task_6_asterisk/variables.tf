###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYRQVEVi8TZhPhUMSx8kFj1fB61D9xgJ7ODB4UtZFX9Xns1rou7N8p3aC+6OmzTWPefvOob7elNadCLGm/PR68w5T0oeGQ2BcDZnJhA3bi4dDYQFG7tuURDYjvdJpnmsAEcjl99bUgSD7p0NRsbbsOX5wp+Xsujj3ah3wWEmCSS7r5nWpvRxQe3O0aHI9g/q6xG9j5zls8ZxBpqzaPu9F5XKZthkYNzweF7KVQZTjwJ1QDPL9OxE9UhFEATBWHCeqidv2izuqAgNk2/Iq//yMBqB+8veQaXidecn4pDnjin3JBGb9AOOnNtT0P2ZY5xOFStQ3jpKuzyxX1JDb0XKrMGpE8604Xf1EGTxJkHDpQAeQfcjgm7axCCg+c9gh92LaCjQcHkO4gGHzTElZQkaQ/molTjvE6B26YjTfzLltalHnjRMZ2RkstDA9MtuQKFR3fNdK17lFeKq5ddPRq3mE1Xc7bNjPMGw9UTEg0Y/8XYEDkyEdr9yHsGAUyp2s+bVjq4uf08Xbnm23Mn+pRTI75IUZwdbhP+LPbSQ5dDt1cBiDl+h6qYESGg8voaiYTuq5M2LPVdtaxMBnW++WVm6+JVWXnEIOSX9osCyqHPOx686hdl73c9A7hg6zl1466KfbSfrHQvhWljiCeUOMzCnnvWLko81nKS/nxrUdNzXOR1Q== a@aser"
}


