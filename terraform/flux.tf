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

# variable "k8s_credentials"{
#     type= string
#     description = "credentials of authenticating with kubernetes"
#     sensitive = true
#     default = "" # get back here and fill it with credits. 
# }

locals{
    config_path= yamldecode(file("${path.module}/~/.kube/conefig"))
    sensitive="true"
}

resource "flux_bootstrap_git" "flux" { #reqistry used "this" instead
  path = "clusters/default"
}

