variable "name" {
  description = "Name of the instance and matching security group"
  type        = string
}

variable "network" {
  description = "OSUOSL network to create the instance in"
  type        = string
}

variable "instance_type" {
  description = "OpenStack instance type"
  type        = string
}

variable "ports" {
  description = "Ports that are open for inbound traffic"
  type        = list(number)
}

variable "port_ranges" {
  description = "Port ranges that are open for inbound traffic"
  type        = list(list(number))
  default     = []
}

variable "image_uuid" {
  description = "UUID of the disk image"
  type        = string
  default     = "9883486d-86b1-493c-9bc8-57f9ef78c8c4" # Ubuntu 24.04
}

variable "disk_size" {
  description = "Size of the VM's root volume"
  type        = number
}

variable "dns_zone" {
  description = "Route 53 zone object to provision records in"
  type = object({
    zone_id = string
    name    = string
  })
}

variable "user_data" {
  description = "User data to attach to the VM. Consumed by cloud-init on many Linux distributions."
  type        = string
  default     = ""
}
