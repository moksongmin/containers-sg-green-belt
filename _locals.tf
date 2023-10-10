locals {
  vpc_name   = "containers-group-vpc"
  region     = var.region
  account_id = var.account_id == null ? data.aws_caller_identity.current.account_id : var.account_id
  # partition  = data.aws_partition.current.partition

  tags = merge({
    ClusterName    = local.cluster_name
  }, var.tags)
}

locals {
  cluster_name    = "gbcluster"
  cluster_version = "1.27"
  # eks_oidc_issuer_url   = replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")
  # eks_oidc_provider_arn = "arn:${local.partition}:iam::${local.account_id}:oidc-provider/${local.eks_oidc_issuer_url}"
}