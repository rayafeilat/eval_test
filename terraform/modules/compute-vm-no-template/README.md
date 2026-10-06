# Terraform Module: Google Compute Instance

This Terraform module creates a **Google Compute Instance** with customizable configurations for machine type, boot and attached disks, network settings, metadata, and more.

---

## Usage

```hcl
module "compute_instance" {
  source = "./terraform-google-compute-instance"

  instance_name = "example-instance"
  project_id    = "my-project-id"
  machine_type  = "n1-standard-1"
  zone          = "us-central1-a"

  tags         = ["web", "dev"]
  labels       = { environment = "dev" }
  description  = "Example instance"
  can_ip_forward = false

  boot_disk_source      = null
  boot_disk_device_name = null
  image_project         = "debian-cloud"
  image                 = "debian-11-bullseye-v20230206"
  boot_disk_size        = 20
  boot_disk_type        = "pd-ssd"

  additional_disks = [
    {
      source            = "example-disk"
      device_name       = "data-disk"
      mode              = "READ_WRITE"
      kms_key_self_link = null
    }
  ]

  network    = "default"
  subnetwork = "default"

  access_config = [
    {
      nat_ip       = null
      network_tier = "PREMIUM"
    }
  ]

  metadata = {
    ssh-keys = "user:ssh-rsa AAAA..."
  }

  service_account_email = "default"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]

  on_host_maintenance   = "MIGRATE"
  automatic_restart     = true

  enable_secure_boot          = false
  enable_vtpm                 = false
  enable_integrity_monitoring = true

  deletion_protection = true
  enable_display      = false
}
```

---

## Inputs

| **Name**                      | **Description**                                                   | **Type**                                                     | **Default**                         | **Required** |
|-------------------------------|-------------------------------------------------------------------|-------------------------------------------------------------|-------------------------------------|--------------|
| `instance_name`               | The name of the instance.                                        | `string`                                                    | n/a                                 | yes          |
| `project_id`                  | ID of the project to create the VM in.                          | `string`                                                    | n/a                                 | yes          |
| `machine_type`                | The machine type to use for the instance.                       | `string`                                                    | n/a                                 | yes          |
| `zone`                        | The zone to create the instance in.                             | `string`                                                    | n/a                                 | yes          |
| `tags`                        | Tags to apply to the instance.                                  | `list(string)`                                              | `[]`                                | no           |
| `labels`                      | Labels to apply to the instance.                                | `map(string)`                                               | `{}`                                | no           |
| `can_ip_forward`              | Whether the instance can forward IP packets.                    | `bool`                                                      | `false`                             | no           |
| `description`                 | The description of the instance.                                | `string`                                                    | `""`                               | no           |
| `boot_disk_source`            | The name or self-link of the disk attached to this instance.     | `string`                                                    | `null`                              | no           |
| `boot_disk_device_name`       | The device name of the boot disk.                               | `string`                                                    | `null`                              | no           |
| `image_project`               | The project where the image is stored.                          | `string`                                                    | n/a                                 | yes          |
| `image`                       | The image to use for the instance.                              | `string`                                                    | n/a                                 | yes          |
| `boot_disk_size`              | Size of the boot disk in GB.                                     | `number`                                                    | `10`                                | no           |
| `boot_disk_type`              | Type of the boot disk (`pd-standard`, `pd-ssd`, etc.).           | `string`                                                    | `"pd-ssd"`                        | no           |
| `additional_disks`            | Additional disks to attach to the instance.                     | `list(object({ ... }))`                                      | `[]`                                | no           |
| `network`                     | The network to attach the instance to.                          | `string`                                                    | n/a                                 | yes          |
| `subnetwork`                  | The subnetwork to attach the instance to.                       | `string`                                                    | `""`                               | no           |
| `access_config`               | The external IP address to assign.                              | `list(object({ nat_ip, network_tier }))`                    | `[]`                                | no           |
| `metadata`                    | Metadata to assign to the instance.                             | `map(string)`                                               | `{}`                                | no           |
| `metadata_startup_script`     | Startup script to execute when the instance starts.             | `string`                                                    | `""`                               | no           |
| `service_account_email`       | The service account email for the instance.                     | `string`                                                    | n/a                                 | yes          |
| `scopes`                      | Scopes for the service account.                                 | `list(string)`                                              | `["https://www.googleapis.com/auth/cloud-platform"]` | no |
| `on_host_maintenance`         | What to do if the instance is hosted on maintenance.            | `string`                                                    | `"MIGRATE"`                       | no           |
| `automatic_restart`           | Whether the instance should be restarted if it crashes.         | `bool`                                                      | `true`                              | no           |
| `enable_secure_boot`          | Enable secure boot for the instance.                            | `bool`                                                      | `false`                             | no           |
| `enable_vtpm`                 | Enable vTPM for the instance.                                   | `bool`                                                      | `false`                             | no           |
| `enable_integrity_monitoring` | Enable integrity monitoring for the instance.                   | `bool`                                                      | `false`                             | no           |
| `deletion_protection`         | Whether this VM should be protected against deletion.           | `bool`                                                      | `false`                             | no           |
| `enable_display`              | Whether to enable a display for this VM.                        | `bool`                                                      | `false`                             | no           |
| `key_revocation_action_type`  | Action to take when encryption key is revoked (`STOP` or `NONE`).| `string`                                                    | `null`                              | no           |

---

## Outputs

| **Name**                | **Description**                                      |
|-------------------------|----------------------------------------------------|
| `instance_name`         | The name of the created instance.                  |
| `instance_self_link`    | The self-link of the created instance.             |
| `instance_network_ips`  | The network IPs assigned to the instance.          |
| `instance_tags`         | The tags assigned to the instance.                 |

---

## Requirements

| **Name**      | **Version**   |
|---------------|---------------|
| Terraform     | >= 1.0.0      |
| Google Cloud  | >= 4.0.0      |

---

## Resources Created

- `google_compute_instance`

---

## License

This module is licensed under the Apache 2.0 License.
