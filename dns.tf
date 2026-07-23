resource "aws_route53_record" "github_a_alias" {
  zone_id = module.production_env.zone_id
  name    = ""
  type    = "A"
  ttl     = 300
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

resource "aws_route53_record" "github_aaaa_alias" {
  zone_id = module.production_env.zone_id
  name    = ""
  type    = "AAAA"
  ttl     = 300
  records = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153"
  ]
}

resource "aws_route53_record" "route_53_cloud_txt" {
  zone_id = module.production_env.zone_id
  name    = "cloud.${module.production_env.zone_name}"
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

resource "aws_route53_record" "cloud-a" {
  zone_id = module.production_env.zone_id
  name    = "cloud.${module.production_env.zone_name}"
  type    = "A"
  ttl     = "300"
  records = [
    "140.211.9.53"
  ]
}

resource "aws_route53_record" "cloud-aaaa" {
  zone_id = module.production_env.zone_id
  name    = "cloud.${module.production_env.zone_name}"
  type    = "AAAA"
  ttl     = "300"
  records = [
    "2605:bc80:3010:104::8cd3:935"
  ]
}

resource "aws_route53_record" "bsky-verification-txt" {
  zone_id = module.production_env.zone_id
  name    = "_atproto.${module.production_env.zone_name}"
  type    = "TXT"
  ttl     = "300"
  records = [
    "did=did:plc:hogmnov6mwgz6mhw2h7763gm"
  ]
}

resource "aws_route53_record" "birdhouse-cname" {
  zone_id = module.production_env.zone_id
  name    = "birdhouse.${module.production_env.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "${module.production_env.github_domain}."
  ]
}

resource "aws_route53_record" "attend-cname" {
  zone_id = module.production_env.zone_id
  name    = "attend.${module.production_env.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "${module.production_env.github_domain}."
  ]
}

resource "aws_route53_record" "osem-cname" {
  zone_id = module.production_env.zone_id
  name    = "osem-static.seagl.org" # TODO: Remove `-static` after review
  type    = "CNAME"
  ttl     = "300"
  records = [
    "seagl.github.io."
  ]
}

resource "aws_route53_record" "sponsor-cname" {
  zone_id = module.production_env.zone_id
  name    = "sponsor.${module.production_env.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "${module.production_env.github_domain}."
  ]
}
