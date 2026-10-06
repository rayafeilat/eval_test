variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "project_id" {
  description = "ID of The Project To Create the VM In"
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the instance"
  type        = string
}

variable "zone" {
  description = "The zone to create the instance in"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the instance"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels to apply to the instance"
  type        = map(string)
  default     = {}
}

variable "can_ip_forward" {
  description = "Whether the instance can forward IP packets"
  type        = bool
  default     = false
}

variable "description" {
  description = "The description of the instance"
  type        = string
  default     = ""
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Type of the boot disk (pd-standard, pd-ssd)"
  type        = string
  default     = "pd-ssd"
}

variable "boot_disk_name" {
  description = "name of the boot disk"
  type        = string
  default     = null
}

variable "image" {
  description = "The image to use for the instance"
  type        = string
}

variable "additional_disks" {
  description = "Additional disks to attach to the instance"
  type = list(object({
    description                     = optional(string)
    type                            = string
    size                            = number
    disk_encryption_key_raw         = optional(string)
    image                           = optional(string)
    snapshot                        = optional(string)
    physical_block_size_bytes       = optional(number)
    kms_key_self_link               = optional(string)
    mode                            = optional(string, "READ_WRITE")
    disk_encryption_key             = optional(object({
      raw_key           = string
      kms_key_self_link = optional(string)
    }))
    source_image_encryption_key     = optional(object({
      raw_key = string
    }))
    source_snapshot_encryption_key  = optional(object({
      raw_key = string
    }))
  }))
  default     = []
}

variable "network" {
  description = "The network to attach the instance to"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to attach the instance to"
  type        = string
  default     = null
}

variable "access_config" {
  description = "The external IP address to assign"
  type        = list(object({
    nat_ip                  = optional(string)
    network_tier            = optional(string)
  }))
  default     = []
}

variable "network_ip" {
  description = "Internal Network IP"
  type        = string
  default     = null
}

variable "metadata" {
  description = "Metadata to assign to the instance"
  type        = map(string)
  default     = {}
}

variable "metadata_startup_script" {
  description = "Startup script to execute when the instance starts"
  type        = string
  default     = ""
}

variable "service_account_email" {
  description = "The service account email for the instance"
  type        = string
}

variable "scopes" {
  description = "Scopes for the service account"
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "on_host_maintenance" {
  description = "What to do if the instance is hosted on maintenance"
  type        = string
  default     = "MIGRATE"
}

variable "automatic_restart" {
  description = "Whether the instance should be restarted if it crashes"
  type        = bool
  default     = true
}

variable "enable_secure_boot" {
  description = "Enable secure boot for the instance"
  type        = bool
  default     = false
}

variable "enable_vtpm" {
  description = "Enable vTPM for the instance"
  type        = bool
  default     = false
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring for the instance"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Wether This VM should be protected against deletion or not"
  type = bool
  default = false
}

variable "enable_display" {
  description = "Wether to enable a display for this VM or not"
  type = bool
  default = false
}

variable "key_revocation_action_type" {
  description = "Action to be taken when a customer's encryption key is revoked. Supports 'STOP' and 'NONE', with 'NONE' being the default."
  type = string
  default = null
}

variable "boot_disk_source" {
  description = "The name or self_link of the disk attached to this instance."
  type = string
  default = null
}