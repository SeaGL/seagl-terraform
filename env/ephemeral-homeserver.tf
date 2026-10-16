module "matrix-2026" {
  source   = "../ephemeral_homeserver"
  year     = "2026-test"
  dns_zone = aws_route53_zone.apex
}

module "matrix-2026-prod" {
  source   = "../ephemeral_homeserver"
  year     = "2026"
  dns_zone = aws_route53_zone.apex
}
