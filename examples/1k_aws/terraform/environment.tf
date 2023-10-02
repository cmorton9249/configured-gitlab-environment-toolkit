module "gitlab_ref_arch_aws" {
  source = "../../modules/gitlab_ref_arch_aws"

  prefix         = var.prefix
  ssh_public_key = file(var.ssh_public_key_file)

  # 1k
  gitlab_rails_node_count    = 1
  gitlab_rails_instance_type = "c5.2xlarge"

  haproxy_external_node_count                = 1
  haproxy_external_instance_type             = "c5.large"
  haproxy_external_elastic_ip_allocation_ids = [var.external_ip_allocation]
}

output "gitlab_ref_arch_aws" {
  value = module.gitlab_ref_arch_aws
}
