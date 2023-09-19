provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

################################################################################
# EKS Add-ons Module
################################################################################
module "eks-blueprints-addons" {

  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.8.0"

  cluster_name      = local.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # EKS Blueprints Add-ons:
  # Cluster Auto-scaler
  enable_cluster_autoscaler = true

  # AWS LB Controller
  enable_aws_load_balancer_controller = true

  # ArgoCD
  enable_argocd = true

  depends_on = [module.eks]
}
