
locals {
  default_helm_config = {
    name                       = "spark-operator"
    chart                      = "spark-operator"
    repository                 = "https://googlecloudplatform.github.io/spark-on-k8s-operator"
    version                    = "1.1.19"
    namespace                  = "spark-k8s-operator"
    timeout                    = "1200"
    create_namespace           = true
    values                     = null
    set                        = []
    set_sensitive              = null
    lint                       = false
    verify                     = false
    keyring                    = ""
    repository_key_file        = ""
    repository_cert_file       = ""
    repository_ca_file         = ""
    repository_username        = ""
    repository_password        = ""
    disable_webhooks           = false
    reuse_values               = false
    reset_values               = false
    force_update               = false
    recreate_pods              = false
    cleanup_on_fail            = false
    max_history                = 0
    atomic                     = false
    skip_crds                  = false
    render_subchart_notes      = true
    disable_openapi_validation = false
    wait                       = true
    wait_for_jobs              = false
    dependency_update          = false
    replace                    = false
    description                = "The spark_k8s_operator HelmChart Ingress Controller deployment configuration"
    postrender                 = ""
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  argocd_gitops_config = {
    enable = true
  }
}
