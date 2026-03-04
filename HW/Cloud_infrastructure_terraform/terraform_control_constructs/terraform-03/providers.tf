terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_ssm_parameter" "iam_token" {
  name            = "/yandex/helgi177-iam-token"
  with_decryption = true
}

provider "yandex" {
  token     = data.aws_ssm_parameter.iam_token.value
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}