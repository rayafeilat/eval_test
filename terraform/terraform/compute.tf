module "compute" {
  source   = "./modules/compute-vm-no-template"
  for_each = each.value.VM_specs

  instance_name         = each.value.name
  network               = google_compute_network.vpc.self_link
  project_id            = var.project_id
  zone                  = var.zone
  service_account_email = each.value.service_account_email
  machine_type          = each.value.machine_type

  image = var.ami
}

