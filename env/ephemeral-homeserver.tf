module "matrix-2026" {
  source   = "../ephemeral_homeserver"
  year     = "2026"
  dns_zone = aws_route53_zone.apex
}
