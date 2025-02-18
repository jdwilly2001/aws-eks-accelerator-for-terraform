# Crossplane
Crossplane is an open source Kubernetes add-on that enables platform teams to assemble infrastructure from multiple vendors, and expose higher level self-service APIs for application teams to consume, without having to write any code.

 - Crossplane is a control plane
 - Allow engineers to model their infrastructure as declarative configuration
 - Support managing a myriad of diverse infrastructure using "provider" plugins
 - It's an open source tool with strong communities

Please find more details from [Crossplane](https://crossplane.io/)

## Usage
Crossplane Add-on can be deployed as follows

```hcl
  enable_crossplane = true
```

This module allows you to deploy the following AWS providers for Crossplane. These providers disabled by default.

 - [AWS Provider](https://github.com/crossplane/provider-aws)
 - [Provider Jet AWS](https://github.com/crossplane-contrib/provider-jet-aws)

Refer to [docs](../../../docs/add-ons/crossplane.md) on how to deploy AWS Providers.

___
<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.13.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.13.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_provider_irsa"></a> [aws\_provider\_irsa](#module\_aws\_provider\_irsa) | ../../../modules/irsa | n/a |
| <a name="module_helm_addon"></a> [helm\_addon](#module\_helm\_addon) | ../helm-addon | n/a |
| <a name="module_jet_aws_provider_irsa"></a> [jet\_aws\_provider\_irsa](#module\_jet\_aws\_provider\_irsa) | ../../../modules/irsa | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.jet_aws_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubectl_manifest.aws_controller_config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.aws_provider](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.aws_provider_config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.jet_aws_controller_config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.jet_aws_provider](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.jet_aws_provider_config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.crossplane](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Current AWS Account ID | `string` | n/a | yes |
| <a name="input_aws_partition"></a> [aws\_partition](#input\_aws\_partition) | AWS Identifier of the current partition e.g., aws or aws-cn | `string` | n/a | yes |
| <a name="input_aws_provider"></a> [aws\_provider](#input\_aws\_provider) | AWS Provider config for Crossplane | <pre>object({<br>    enable                   = bool<br>    provider_aws_version     = string<br>    additional_irsa_policies = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS cluster Id | `string` | n/a | yes |
| <a name="input_helm_config"></a> [helm\_config](#input\_helm\_config) | Helm provider config for the Argo Rollouts | `any` | `{}` | no |
| <a name="input_jet_aws_provider"></a> [jet\_aws\_provider](#input\_jet\_aws\_provider) | AWS Provider Jet AWS config for Crossplane | <pre>object({<br>    enable                   = bool<br>    provider_aws_version     = string<br>    additional_irsa_policies = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_manage_via_gitops"></a> [manage\_via\_gitops](#input\_manage\_via\_gitops) | Determines if the add-on should be managed via GitOps. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common Tags for AWS resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_gitops_config"></a> [argocd\_gitops\_config](#output\_argocd\_gitops\_config) | Configuration used for managing the add-on with ArgoCD |

<!--- END_TF_DOCS --->
