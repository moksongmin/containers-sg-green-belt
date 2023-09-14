locals {
  name            = "swo-container-and-orchestration"
  cluster_version = "1.27"
  region          = var.region

  tags = merge({
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }, var.tags)
}

### Logging module locals:
locals {
  partition  = data.aws_partition.current.partition
  account_id = var.account_id == null ? data.aws_caller_identity.current.account_id : var.account_id
  #cluster_name          = var.fluentbit_cluster_info_configs["cluster.name"]
  #eks_oidc_issuer_url   = replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")
  #eks_oidc_provider_arn = "arn:${local.partition}:iam::${local.account_id}:oidc-provider/${local.eks_oidc_issuer_url}"
}