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
