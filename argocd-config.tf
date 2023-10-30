########################## ArgoCD Repository ##############################
resource "local_file" "argocd_repository" {
  filename = "templates/argocd-repo.yaml"
  content  = file("${path.module}/templates/argocd-repo.yaml")
}

resource "null_resource" "argocd_repository" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${local.region} --name ${local.cluster_name} ;
      kubectl apply -f ${local_file.argocd_repository.filename}
    EOT
  }
  
  depends_on = [module.eks, module.eks-blueprints-addons]
}

########################## ArgoCD App of Apps ##############################
resource "null_resource" "app_of_apps" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${local.region} --name ${local.cluster_name} ;
      helm template apps/ | kubectl apply -f -
    EOT
  }
  
  depends_on = [module.eks, module.eks-blueprints-addons]
}

########################### ArgoCD Application Set ##########################
# resource "local_file" "argocd_appset" {
#   filename = "templates/argocd-appset.yaml"
#   content  = file("${path.module}/templates/argocd-appset.yaml")
# }

# resource "null_resource" "argocd_appset" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws eks update-kubeconfig --region ${local.region} --name ${local.cluster_name} ;
#       kubectl apply -f ${local_file.argocd_appset.filename}
#       EOT
#   }

#   depends_on = [module.eks, module.eks-blueprints-addons]
# }

########################### ArgoCD application ##############################

### Uncomment if you want to deploy only the 2048 game.
# resource "local_file" "argocd_app_game" {
#   filename = "templates/argocd-apps.yaml"
#   content  = file("${path.module}/templates/argocd-apps.yaml")
# }

# resource "null_resource" "argocd_app_game" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws eks update-kubeconfig --region ${local.region} --name ${local.cluster_name} ;
#       kubectl apply -f ${local_file.argocd_app_game.filename}
#       EOT
#   }

#   depends_on = [module.eks]
