########################## ArgoCD repository ##########################
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
}

########################## ArgoCD applications ##########################
resource "local_file" "argocd_app_game" {
  filename = "templates/argocd-apps.yaml"
  content  = file("${path.module}/templates/argocd-apps.yaml")
}

resource "null_resource" "argocd_app_game" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.argocd_app_game.filename}"
  }
}