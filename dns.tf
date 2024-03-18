resource "aws_route53_record" "route_53_cloud_txt" {
  zone_id = module.production_env.zone_id
  name    = "cloud.seagl.org"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:_spf.osuosl.org ~all"
  ]
}

resource "aws_route53_record" "email_dkim_hubspot_records" {
  for_each = {
    "hs1-40081384" : "seagl-org.hs12a.dkim.hubspotemail.net",
    "hs2-40081384" : "seagl-org.hs12b.dkim.hubspotemail.net"
  }
  zone_id = module.production_env.zone_id
  name    = "${each.key}._domainkey.${var.email_domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    each.value
  ]
}

# TODO remove this; we should (do?) do DNS-based verification instead.
resource "aws_ses_domain_identity" "email_domain_identity" {
  domain = var.email_domain_name
}

# TODO remove this. It's unnecessary because the domain is verified.
# It's still here only to make a refactoring `plan` clean.
resource "aws_ses_email_identity" "email" {
  email = "sre@seagl.org"
}

resource "aws_route53_record" "cloud-a" {
  zone_id = module.production_env.zone_id
  name    = "cloud.seagl.org"
  type    = "A"
  ttl     = "300"
  records = [
    "140.211.9.53"
  ]
}

resource "aws_route53_record" "cloud-aaaa" {
  zone_id = module.production_env.zone_id
  name    = "cloud.seagl.org"
  type    = "AAAA"
  ttl     = "300"
  records = [
    "2605:bc80:3010:104::8cd3:935"
  ]
}
