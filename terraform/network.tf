resource "google_compute_network" "vpc"{
    name="${var.environment_name}-vpc"
    project= var.project_id
}

resource "google_compute_subnetwork" "subnet"{
    name="subnet"
    network =google_compute_network.vpc.self_link
    ip_cidr_range = var.subnet_CIDR
    region= var.region
    project= var.project_id
}

resource "google_compute_router" "cloud_Router"{
    name="${var.environment_name}-router"
    region=var.region
    project=var.project_id
}