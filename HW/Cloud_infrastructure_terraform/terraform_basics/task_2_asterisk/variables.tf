variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  default     = "b1g2lqlbrsjon6qhlsso"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  default     = "b1ghqjh9j50gl3bqspbv"
}

data "aws_ssm_parameter" "yc_token" {
  name            = "/yandex/yc-oauth-token"
  with_decryption = true
}


