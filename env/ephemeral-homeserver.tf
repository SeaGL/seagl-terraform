module "matrix-2025" {
  source   = "../ephemeral_homeserver"
  year     = "2025"
  dns_zone = aws_route53_zone.apex
}
