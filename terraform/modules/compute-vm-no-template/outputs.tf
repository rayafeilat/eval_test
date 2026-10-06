output "instance_name" {
  description = "The name of the instance"
  value       = google_compute_instance.default.name
}

output "instance_self_link" {
  description = "The self-link of the instance"
  value       = google_compute_instance.default.self_link
}

output "instance_zone" {
  description = "The zone where the instance is deployed"
  value       = google_compute_instance.default.zone
}

output "instance_status" {
  description = "The current status of the instance"
  value       = google_compute_instance.default.current_status
}

output "id" {
  description = "ID Of Instance"
  value = google_compute_instance.default.id
}

output "internal_ip" {
  description = "Internal IP Of Instance"
  value = google_compute_instance.default.network_interface.0.network_ip
}

output "attached_disks_ids" {
  description = "ID of the created disk."
  value       = [ for d in values(google_compute_disk.disk) : d.id ] 
}

output "attached_disks_self_links" {
  description = "Self-link of the created disk."
  value       = [ for d in values(google_compute_disk.disk) : d.self_link ]
}

output "attached_disks_names" {
  description = "Self-link of the created disk."
  value       = [ for d in values(google_compute_disk.disk) : basename(d.name) ]
}

