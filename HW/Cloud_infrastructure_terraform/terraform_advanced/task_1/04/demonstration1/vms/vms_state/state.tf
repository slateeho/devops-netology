terraform {
  backend "s3" {
    bucket = "paniqed-beaver"
    key    = "vms/terraform.tfstate"
    region = "eu-central-1"
    profile= "default"
  }
}
