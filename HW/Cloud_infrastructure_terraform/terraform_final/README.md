## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.7.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | ~> 0.191 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.7.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.194.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | ./db | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ./dns | n/a |
| <a name="module_vpc_dev"></a> [vpc\_dev](#module\_vpc\_dev) | ./vpc_dev | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.docker_compose_file](https://registry.terraform.io/providers/hashicorp/local/2.7.0/docs/resources/file) | resource |
| [local_file.hosts_ini](https://registry.terraform.io/providers/hashicorp/local/2.7.0/docs/resources/file) | resource |
| [null_resource.ansible_ping](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.cloud_init_wait](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.upload_and_run_docker_compose](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [yandex_compute_instance.web](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |
| [yandex_iam_service_account.sa_tf](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.sa_tf_static_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_lockbox_secret.db_credentials](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lockbox_secret) | resource |
| [yandex_lockbox_secret_version.db_credentials](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lockbox_secret_version) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_lockbox_viewer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_tf_admin_s3](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [aws_ssm_parameter.iam_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [yandex_iam_service_account.sa_lockbox](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/iam_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | Yandex Cloud ID | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Database name | `string` | `"app_db"` | no |
| <a name="input_db_image_id"></a> [db\_image\_id](#input\_db\_image\_id) | Image ID for DB VM | `string` | `"fd8e9t6fpgi13oh7q39f"` | no |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | Default zone | `string` | `"ru-central1-a"` | no |
| <a name="input_dns_members"></a> [dns\_members](#input\_dns\_members) | IAM members allowed to view/manage DNS zone | `list(string)` | `[]` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | n/a | `string` | `"@"` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | n/a | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Yandex Folder ID | `string` | n/a | yes |
| <a name="input_lockbox_secret_name"></a> [lockbox\_secret\_name](#input\_lockbox\_secret\_name) | Lockbox secret name | `string` | `"db-credentials"` | no |
| <a name="input_os_distro"></a> [os\_distro](#input\_os\_distro) | OS distribution for Docker repo | `string` | `"debian"` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Service account ID for Lockbox and S3 remote state access | `string` | `"ajev6no0d04buotbn43i"` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | Database user name | `string` | `"app_user"` | no |
| <a name="input_vm_user"></a> [vm\_user](#input\_vm\_user) | SSH user for VM | `string` | `"debian"` | no |
| <a name="input_yc_token"></a> [yc\_token](#input\_yc\_token) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | Access key ID for S3 backend |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | S3 bucket name for Terraform state |
| <a name="output_cert_paths"></a> [cert\_paths](#output\_cert\_paths) | n/a |
| <a name="output_db_primary_ip"></a> [db\_primary\_ip](#output\_db\_primary\_ip) | n/a |
| <a name="output_db_primary_public_ip"></a> [db\_primary\_public\_ip](#output\_db\_primary\_public\_ip) | n/a |
| <a name="output_db_vm_ids"></a> [db\_vm\_ids](#output\_db\_vm\_ids) | n/a |
| <a name="output_db_vm_internal_ips"></a> [db\_vm\_internal\_ips](#output\_db\_vm\_internal\_ips) | n/a |
| <a name="output_db_vm_names"></a> [db\_vm\_names](#output\_db\_vm\_names) | n/a |
| <a name="output_db_vm_public_ips"></a> [db\_vm\_public\_ips](#output\_db\_vm\_public\_ips) | n/a |
| <a name="output_dns_urls"></a> [dns\_urls](#output\_dns\_urls) | DNS endpoints |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | n/a |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | n/a |
| <a name="output_secret_key"></a> [secret\_key](#output\_secret\_key) | Secret key for S3 backend |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
| <a name="output_subnet_v4_cidr_blocks"></a> [subnet\_v4\_cidr\_blocks](#output\_subnet\_v4\_cidr\_blocks) | n/a |
| <a name="output_subnet_zone"></a> [subnet\_zone](#output\_subnet\_zone) | n/a |
| <a name="output_web_vm_internal_ip"></a> [web\_vm\_internal\_ip](#output\_web\_vm\_internal\_ip) | n/a |
| <a name="output_web_vm_public_ip"></a> [web\_vm\_public\_ip](#output\_web\_vm\_public\_ip) | n/a |
