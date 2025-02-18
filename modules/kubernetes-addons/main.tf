/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#-----------------AWS Managed EKS Add-ons----------------------

module "aws_vpc_cni" {
  count          = var.enable_amazon_eks_vpc_cni ? 1 : 0
  source         = "./aws-vpc-cni"
  add_on_config  = var.amazon_eks_vpc_cni_config
  eks_cluster_id = var.eks_cluster_id
  common_tags    = var.tags
}

module "aws_coredns" {
  count          = var.enable_amazon_eks_coredns ? 1 : 0
  source         = "./aws-coredns"
  add_on_config  = var.amazon_eks_coredns_config
  eks_cluster_id = var.eks_cluster_id
  common_tags    = var.tags
}

module "aws_kube_proxy" {
  count          = var.enable_amazon_eks_kube_proxy ? 1 : 0
  source         = "./aws-kube-proxy"
  add_on_config  = var.amazon_eks_kube_proxy_config
  eks_cluster_id = var.eks_cluster_id
  common_tags    = var.tags
}

module "aws_ebs_csi_driver" {
  count          = var.enable_amazon_eks_aws_ebs_csi_driver ? 1 : 0
  source         = "./aws-ebs-csi-driver"
  add_on_config  = var.amazon_eks_aws_ebs_csi_driver_config
  eks_cluster_id = var.eks_cluster_id
  common_tags    = var.tags
}

#-----------------Kubernetes Add-ons----------------------

module "agones" {
  count                        = var.enable_agones ? 1 : 0
  source                       = "./agones"
  helm_config                  = var.agones_helm_config
  eks_worker_security_group_id = var.eks_worker_security_group_id
  manage_via_gitops            = var.argocd_manage_add_ons
}

module "argocd" {
  count                      = var.enable_argocd ? 1 : 0
  source                     = "./argocd"
  helm_config                = var.argocd_helm_config
  eks_cluster_id             = var.eks_cluster_id
  applications               = var.argocd_applications
  admin_password_secret_name = var.argocd_admin_password_secret_name
  add_on_config              = { for k, v in local.argocd_add_on_config : k => v if v != null }
}

module "argo_rollouts" {
  count                         = var.enable_argo_rollouts ? 1 : 0
  source                        = "./argo-rollouts"
  eks_cluster_id                = var.eks_cluster_id
  helm_config                   = var.argo_rollouts_helm_config
  irsa_iam_permissions_boundary = var.argo_rollouts_irsa_permissions_boundary
  tags                          = var.tags
  manage_via_gitops             = var.argocd_manage_add_ons
}

module "aws_efs_csi_driver" {
  count             = var.enable_aws_efs_csi_driver ? 1 : 0
  source            = "./aws-efs-csi-driver"
  helm_config       = var.aws_efs_csi_driver_helm_config
  eks_cluster_id    = var.eks_cluster_id
  tags              = var.tags
  manage_via_gitops = var.argocd_manage_add_ons
}

module "aws_for_fluent_bit" {
  count                    = var.enable_aws_for_fluentbit ? 1 : 0
  source                   = "./aws-for-fluentbit"
  helm_config              = var.aws_for_fluentbit_helm_config
  eks_cluster_id           = var.eks_cluster_id
  irsa_policies            = var.aws_for_fluentbit_irsa_policies
  cw_log_group_name        = var.aws_for_fluentbit_cw_log_group_name
  cw_log_group_retention   = var.aws_for_fluentbit_cw_log_group_retention
  cw_log_group_kms_key_arn = var.aws_for_fluentbit_cw_log_group_kms_key_arn
  tags                     = var.tags
  manage_via_gitops        = var.argocd_manage_add_ons
}

module "aws_load_balancer_controller" {
  count                         = var.enable_aws_load_balancer_controller ? 1 : 0
  source                        = "./aws-load-balancer-controller"
  helm_config                   = var.aws_load_balancer_controller_helm_config
  eks_cluster_id                = var.eks_cluster_id
  irsa_iam_permissions_boundary = var.aws_load_balancer_controller_irsa_permissions_boundary
  tags                          = var.tags
  manage_via_gitops             = var.argocd_manage_add_ons
}

module "aws_node_termination_handler" {
  count  = var.enable_aws_node_termination_handler && length(var.auto_scaling_group_names) > 0 ? 1 : 0
  source = "./aws-node-termination-handler"

  eks_cluster_id          = var.eks_cluster_id
  helm_config             = var.aws_node_termination_handler_helm_config
  autoscaling_group_names = var.auto_scaling_group_names
  tags                    = var.tags
}

module "cert_manager" {
  count             = var.enable_cert_manager ? 1 : 0
  source            = "./cert-manager"
  helm_config       = var.cert_manager_helm_config
  manage_via_gitops = var.argocd_manage_add_ons
}

module "cluster_autoscaler" {
  count             = var.enable_cluster_autoscaler ? 1 : 0
  source            = "./cluster-autoscaler"
  helm_config       = var.cluster_autoscaler_helm_config
  eks_cluster_id    = var.eks_cluster_id
  tags              = var.tags
  manage_via_gitops = var.argocd_manage_add_ons
}

module "crossplane" {
  count             = var.enable_crossplane ? 1 : 0
  source            = "./crossplane"
  helm_config       = var.crossplane_helm_config
  eks_cluster_id    = var.eks_cluster_id
  manage_via_gitops = var.argocd_manage_add_ons
  aws_provider      = var.crossplane_aws_provider
  jet_aws_provider  = var.crossplane_jet_aws_provider
  account_id        = data.aws_caller_identity.current.account_id
  aws_partition     = data.aws_partition.current.id
  tags              = var.tags
}

module "fargate_fluentbit" {
  count          = var.enable_fargate_fluentbit ? 1 : 0
  source         = "./fargate-fluentbit"
  eks_cluster_id = var.eks_cluster_id
  addon_config   = var.fargate_fluentbit_addon_config
  region         = data.aws_region.current.id
}

module "ingress_nginx" {
  count                         = var.enable_ingress_nginx ? 1 : 0
  source                        = "./ingress-nginx"
  helm_config                   = var.ingress_nginx_helm_config
  manage_via_gitops             = var.argocd_manage_add_ons
  eks_cluster_id                = var.eks_cluster_id
  irsa_policies                 = var.nginx_irsa_policies
  irsa_iam_permissions_boundary = var.nginx_ingress_controller_irsa_permissions_boundary
}

module "karpenter" {
  count                     = var.enable_karpenter ? 1 : 0
  source                    = "./karpenter"
  helm_config               = var.karpenter_helm_config
  eks_cluster_id            = var.eks_cluster_id
  irsa_policies             = var.karpenter_irsa_policies
  node_iam_instance_profile = var.karpenter_node_iam_instance_profile
  tags                      = var.tags
  manage_via_gitops         = var.argocd_manage_add_ons
}

module "keda" {
  count             = var.enable_keda ? 1 : 0
  source            = "./keda"
  helm_config       = var.keda_helm_config
  eks_cluster_id    = var.eks_cluster_id
  create_irsa       = var.keda_create_irsa
  irsa_policies     = var.keda_irsa_policies
  tags              = var.tags
  manage_via_gitops = var.argocd_manage_add_ons
}

module "metrics_server" {
  count             = var.enable_metrics_server ? 1 : 0
  source            = "./metrics-server"
  helm_config       = var.metrics_server_helm_config
  manage_via_gitops = var.argocd_manage_add_ons
}

module "prometheus" {
  count          = var.enable_prometheus ? 1 : 0
  source         = "./prometheus"
  eks_cluster_id = var.eks_cluster_id
  helm_config    = var.prometheus_helm_config
  #AWS Managed Prometheus Workspace
  enable_amazon_prometheus             = var.enable_amazon_prometheus
  amazon_prometheus_workspace_endpoint = var.amazon_prometheus_workspace_endpoint
  manage_via_gitops                    = var.argocd_manage_add_ons
  tags                                 = var.tags
}

module "spark_k8s_operator" {
  count             = var.enable_spark_k8s_operator ? 1 : 0
  source            = "./spark-k8s-operator"
  helm_config       = var.spark_k8s_operator_helm_config
  manage_via_gitops = var.argocd_manage_add_ons
}

module "traefik" {
  count             = var.enable_traefik ? 1 : 0
  source            = "./traefik"
  helm_config       = var.traefik_helm_config
  manage_via_gitops = var.argocd_manage_add_ons
}

module "vpa" {
  count             = var.enable_vpa ? 1 : 0
  source            = "./vpa"
  helm_config       = var.vpa_helm_config
  manage_via_gitops = var.argocd_manage_add_ons
}

module "yunikorn" {
  count                     = var.enable_yunikorn ? 1 : 0
  source                    = "./yunikorn"
  eks_cluster_id            = var.eks_cluster_id
  helm_config               = var.yunikorn_helm_config
  irsa_policies             = var.yunikorn_irsa_policies
  irsa_permissions_boundary = var.yunikorn_irsa_permissions_boundary
  tags                      = var.tags
  manage_via_gitops         = var.argocd_manage_add_ons
}

module "kube_state_metrics" {
  count                     = var.enable_kube_state_metrics ? 1 : 0
  source                    = "askulkarni2/kube-state-metrics-addon/eksblueprints"
  version                   = "0.0.2"
  eks_cluster_id            = var.eks_cluster_id
  helm_config               = var.kube_state_metrics_helm_config
  irsa_policies             = var.kube_state_metrics_irsa_policies
  irsa_permissions_boundary = var.kube_state_metrics_irsa_permissions_boundary
  tags                      = var.tags
  manage_via_gitops         = var.argocd_manage_add_ons
}

module "kubernetes_dashboard" {
  count                     = var.enable_kubernetes_dashboard ? 1 : 0
  source                    = "./kubernetes-dashboard"
  eks_cluster_id            = var.eks_cluster_id
  helm_config               = var.kubernetes_dashboard_helm_config
  irsa_policies             = var.kubernetes_dashboard_irsa_policies
  irsa_permissions_boundary = var.kubernetes_dashboard_irsa_permissions_boundary
  tags                      = var.tags
  manage_via_gitops         = var.argocd_manage_add_ons
}
