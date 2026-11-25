terraform {
  required_providers {
     github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    kubernetes ={
      source  = "hashicorp/kubernetes"
      version = "3.5.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.10.1"
    }
  }
}

#required providers 
provider "flux"{
  kubernetes={
    host = "https://127.0.0.1:6443"
    client_certificate     = base64decode(local.config_path.users[0].user.client-certificate-data)
    client_key             = base64decode(local.config_path.users[0].user.client-key-data)
    cluster_ca_certificate = base64decode(local.config_path.clusters[0].cluster.certificate-authority-data)
  }
  git={
    url="ssh://git@github.com/rayafeilat/eval_test.git"
    ssh={
      username= "git"
      private_key= tls_private_key.private_key.private_key_openssh
    }
    }
}


provider "github" {
  owner = "rayafeilat"
  app_auth{
    id= var.app_id 
    installation_id = var.app_installation_id
    pem_file= local.app_pem
  }
}

#variables and resources
variable "app_id" {
  type= string
  description = "The GitHub App ID for authentication"
  default = "5815251"
}

variable "app_installation_id"{
    type= string
    description = "The GitHub App Installation ID for authentication"
    default = "183294639"

}

# variable "app_pem_file"{
#     type= string
#     description = "credentials-Contents of the PEM file for the GitHub App"
#     sensitive = true 
#     default= file("../../flux-x-terraform.2026-11-18.private-key") # i need to check my path 
# }
variable "cluster_path"{
    type= string 
    description = "target cluster path that fluc will communicate with"
    default = "clusters/default"
}

# variable "k8s_credentials"{
#     type= string
#     description = "credentials of authenticating with kubernetes"
#     sensitive = true
#     default = "" # get back here and fill it with credits. 
# }

locals{
    config_path= yamldecode(file("${path.module}./../.kube/config"))
    
}

locals {
    app_pem= file("/home/raya-feilat/eval_test/flux-x-terraform.2026-11-18.private-key.pem")
}
resource "flux_bootstrap_git" "flux" { 
  path = var.cluster_path
  # namespace="outline-wiki"
  #version= "v1.10.1"
  # interval="1m0s"
  # embedded_manifests="false"
}

#deploy keys

resource "tls_private_key" "private_key"{
  algorithm = "ED25519"

}
# data "tls_public_key" "public_key"{
#   private_key_pem= tls_private_key.private_key
# }

resource "github_repository_deploy_key" "deploy_keys" {
  title = "repo deploy keys"
  repository = "eval_test"
  key= tls_private_key.private_key.public_key_openssh
  read_only = false
  
}
