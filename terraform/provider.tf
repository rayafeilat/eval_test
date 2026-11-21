terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.0"
    }
     github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    kubernetes ={
      source  = "hashicorp/kubernetes"
      version = "~> 1.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "flux"{
  kubernetes={
    #config_path="~/.kube/conefig"
    # host = "https://cluster-api-hostname:port" as i understood i shall use wither

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


