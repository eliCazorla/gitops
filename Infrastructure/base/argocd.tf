locals {
    argocd_name_sufix    = "argocd"
    argocd_namespace     = "tools"
    argo_public_name     = "elias.example.com"
    username             = "eliCazorla"
    clientId             = "clientId"
    clientSecret         = "clientSecret"
    githubAppPrivateKey  = "githubAppPrivateKey"
}

# data "aws_secretsmanager_secret" "argocd_client_id" {
#     name = "${var.environment}/${local.argocd_name_sufix}/clientId"
# }
# data "aws_secretsmanager_secret" "argocd_client_secret" {
#     name = "${var.environment}/${local.argocd_name_sufix}/clientSecret"
# }
# data "aws_secretsmanager_secret" "argocd_gh_app_private_key" {
#     name = "${var.environment}/${local.argocd_name_sufix}/githubAppPrivateKey"
# }
# data "aws_secretsmanager_secret_version" "argocd_client_id" {
#     secret_id = data.aws_secretsmanager_secret.argocd_client_id.name
# }
# data "aws_secretsmanager_secret_version" "argocd_client_secret" {
#     secret_id = data.aws_secretsmanager_secret.argocd_client_secret.name
# }
# data "aws_secretsmanager_secret_version" "argocd_gh_app_private_key" {
#     secret_id = data.aws_secretsmanager_secret.argocd_gh_app_private_key.name
# }

resource "helm_release" "argo_cd" {
    name             = local.argocd_name_sufix
    chart            = local.argocd_name_sufix
    namespace        = local.argocd_namespace
    version          = "5.36.2"
    repository       = "https://argoproj.github.io/argo-helm"
    create_namespace = false
    values = [
        templatefile("${path.module}/values/${local.argocd_name_sufix}.yaml", {
        targetRevision      = "main"
        # envShort            = var.environment
        username            = local.username
        argocdHostList      = jsonencode(["${local.argo_public_name}"])
        argocdHost          = local.argo_public_name
        argocdPaths         = jsonencode(["/"])
        healthCheckPath     = "/healthz"
        ingressEnabled      = true
        ingressClass        = "alb"
        ingressType         = "ip"
        ingressScheme       = "internet-facing"
        clientId            = local.clientId
        clientSecret        = local.clientSecret
        })
    ]

    set {
        name  = "fullnameOverride"
        value = local.argocd_name_sufix
    }
}