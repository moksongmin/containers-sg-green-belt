provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = element(concat(data.aws_eks_cluster_auth.eks_cluster[*].token, tolist([""])), 0)
}