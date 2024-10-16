variable "year" {
  description = "Year the ephemeral homeserver is being provisioned for"
  type        = string
}

variable "dns_zone" {
  description = "Route 53 zone object to provision records in"
  type = object({
    zone_id = string
    name    = string
    id      = string
  })
}
