variable "zone_name" {
  description = "FQDN that will be suffixed to all hosts in the environment"
  type        = string
}

variable "dns_zone" {
  description = "Route 53 zone object to attach (via NS record) the environment's zone to"
  default     = null
  type = object({
    zone_id = string
  })
}

variable "additional_root_txts" {
  description = "Additional TXT records to publish at the root of the zone"
  type        = list(string)
}
