terraform {
  required_providers {
     github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    kubernetes ={
      source  = "hashicorp/kubernetes"
      version = "~> 1.0.0"
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
    
    client_certificate     = base64decode(locals.config_path.client-certificate-data)
    client_key             = base64decode(locals.config_path.client-client-key-data)
    cluster_ca_certificate = base64decode(locals.config_path.certificate-authority-data)
  }
  git={
    url="https://github.com/rayafeilat/eval_test.git"

  }
}

provider "github" {
  owner = "integrations"
  app_auth{
    id= var.app_id 
    installation_id = var.app_installation_id
    pem_file= var.app_pem_file
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

variable "app_pem_file"{
    type= string
    description = "credentials-Contents of the PEM file for the GitHub App"
    sensitive = true 
    default= file("../") # i need to check my path 
}
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
    config_path= yamldecode(file("${path.module}/~/.kube/config"))
    
}

resource "flux_bootstrap_git" "flux" { 
  path = var.cluster_path
  #more att. here
  namespace="outline-wiki"
  version= "1.10.1"
  interval="1m0s"
  embedded_manifests="false"
}

