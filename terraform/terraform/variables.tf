variable "environment_name" {
}

variable "project_id" {
  type = string
}

variable "region" {
  type        = string
  description = "the region that the vm will be hosted in"
}

variable "zone" {
  type        = string
  description = "zone within the indicated regions"
}

variable "VM_specs" {
  type = map(object({
    name                  = string
    network_ip            = string
    machine_type          = string
    Disk                  = string
    tags                  = string
    service_account_email = string
  }))
}

variable "subnet_CIDR" {
  type        = string
  description = " subnet CIDR address of the target subnet network "
}

variable "FW_Rules" {
  description = "allow and deny firewall rules "
  type = map(object({
    allow = optional(map(object({
      protocol = string
      ports    = list(string)
    })))
    deny = optional(map(object({
      protocol = string
      ports    = list(string)
    })))
  }))
}

variable "ami" {
  type        = string
  description = "the image that the instance will be build through"
  default     = "ubuntu"
}

