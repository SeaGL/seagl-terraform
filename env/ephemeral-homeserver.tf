module "matrix-2024" {
  source   = "../ephemeral_homeserver"
  year     = "2024"
  dns_zone = aws_route53_zone.apex
}
