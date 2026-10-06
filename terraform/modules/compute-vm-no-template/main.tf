locals {
  disks = {for idx, disk in var.additional_disks : "${var.instance_name}-disk-${idx + 1}" => disk}
}

resource "google_compute_instance" "default" {
  name         = var.instance_name
  project      = var.project_id
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags
  labels       = var.labels
  can_ip_forward = var.can_ip_forward
  description  = var.description
  deletion_protection = var.deletion_protection
  enable_display = var.enable_display
  key_revocation_action_type = var.key_revocation_action_type
  
  boot_disk {
    source = var.boot_disk_source
    device_name = var.boot_disk_name != null ? var.boot_disk_name : null
    initialize_params {
      image = var.image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  dynamic "attached_disk" {
    for_each = google_compute_disk.disk
    content {
      device_name  = attached_disk.key
      mode         = local.disks[attached_disk.key].mode
      source       = attached_disk.value.id
      disk_encryption_key_raw     = local.disks[attached_disk.key].disk_encryption_key_raw
      kms_key_self_link           = local.disks[attached_disk.key].kms_key_self_link
    }
  }

  network_interface {
    network             = var.network
    subnetwork          = var.subnetwork
    network_ip          = var.network_ip
    subnetwork_project  = var.project_id
    dynamic "access_config" {
        for_each = var.access_config
        content {
          nat_ip       = access_config.value.nat_ip
          network_tier = access_config.value.network_tier
        }
      }
  }

  metadata = var.metadata
  metadata_startup_script = var.metadata_startup_script

  service_account {
    email  = var.service_account_email
    scopes = var.scopes
  }

  scheduling {
    on_host_maintenance = var.on_host_maintenance
    automatic_restart   = var.automatic_restart
  }

  shielded_instance_config {
    enable_secure_boot   = var.enable_secure_boot
    enable_vtpm          = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }
}

resource "google_compute_disk" "disk" {
  for_each = local.disks
  name                       = each.key
  project                    = var.project_id
  size                       = each.value.size
  type                       = each.value.type
  zone                       = var.zone
  image                      = each.value.image
  snapshot                   = each.value.snapshot
  labels                     = var.labels
  description                = each.value.description
  physical_block_size_bytes  = each.value.physical_block_size_bytes

  dynamic "disk_encryption_key" {
    for_each = each.value.disk_encryption_key != null ? [each.value.disk_encryption_key] : []
    content {
      raw_key           = disk_encryption_key.value.raw_key
      kms_key_self_link = disk_encryption_key.value.kms_key_self_link
    }
  }

  dynamic "source_image_encryption_key" {
    for_each = each.value.source_image_encryption_key != null ? [each.value.source_image_encryption_key] : []
    content {
      raw_key = source_image_encryption_key.value.raw_key
    }
  }

  dynamic "source_snapshot_encryption_key" {
    for_each = each.value.source_snapshot_encryption_key != null ? [each.value.source_snapshot_encryption_key] : []
    content {
      raw_key = source_snapshot_encryption_key.value.raw_key
    }
  }
}
