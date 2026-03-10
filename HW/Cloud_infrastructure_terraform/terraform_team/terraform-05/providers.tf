terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.191"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
  required_version = "~>1.12.0"
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_ssm_parameter" "iam_token" {
  name            = "/yandex/yc-iam-token"
  with_decryption = true
}

data "aws_ssm_parameter" "db_password" {
  name            = "/terraform/db-password"
  with_decryption = true
}

provider "yandex" {
  token    = data.aws_ssm_parameter.iam_token.value
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  zone     = var.default_zone
}
