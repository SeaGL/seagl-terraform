module "matrix-2026" {
  source   = "../ephemeral_homeserver"
  year     = "2026-test"
  dns_zone = aws_route53_zone.apex
}
