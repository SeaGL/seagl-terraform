resource "aws_ses_domain_identity" "seagl" {
  domain = "seagl.org"
}

# SPF
resource "aws_route53_record" "route_53_root_txt" {
  # this Zone needs to be imported still
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:_spf.google.com include:amazonses.com include:40081384.spf02.hubspotemail.net include:_spf.osuosl.org ~all",
    "google-site-verification=9Hrl69xXhSeoBOVlnmpOYOSS6fYeiuGehZjHlyPZx3g"
  ]
}

resource "aws_route53_record" "route_53_cloud_txt" {
  # this Zone needs to be imported still
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "cloud.seagl.org"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:_spf.osuosl.org ~all"
  ]
}

# DKIM
resource "aws_ses_domain_identity" "email_domain_identity" {
  domain = var.email_domain_name
}

resource "aws_ses_domain_dkim" "email_dkim" {
  domain = aws_ses_domain_identity.email_domain_identity.domain
}

resource "aws_route53_record" "email_dkim_records" {
  count = 3
  # this Zone needs to be imported still
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "${element(aws_ses_domain_dkim.email_dkim.dkim_tokens, count.index)}._domainkey.${var.email_domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "${element(aws_ses_domain_dkim.email_dkim.dkim_tokens, count.index)}.dkim.amazonses.com",
  ]
}

resource "aws_route53_record" "email_dkim_hubspot_records" {
  for_each = {
    "hs1-40081384" : "seagl-org.hs12a.dkim.hubspotemail.net",
    "hs2-40081384" : "seagl-org.hs12b.dkim.hubspotemail.net"
  }
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "${each.key}._domainkey.${var.email_domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    each.value
  ]
}

resource "aws_route53_record" "route_53_dmarc_txt" {
  # this Zone needs to be imported still
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "_dmarc.${var.email_domain_name}"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=DMARC1;p=quarantine;rua=mailto:dmarc-rpt@seagl.org"
  ]
}

resource "aws_ses_email_identity" "email" {
  email = "sre@seagl.org"
}

# setup alias for Matrix room aliasing
resource "aws_route53_record" "alias" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "alias.seagl.org"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "dokku.seagl.org"
  ]
}

resource "aws_route53_record" "cloud-a" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "cloud.seagl.org"
  type    = "A"
  ttl     = "300"
  records = [
    "140.211.9.53"
  ]
}

resource "aws_route53_record" "cloud-aaaa" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "cloud.seagl.org"
  type    = "AAAA"
  ttl     = "300"
  records = [
    "2605:bc80:3010:104::8cd3:935"
  ]
}

resource "aws_route53_record" "mailu-test-a" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "mail.mail-test.seagl.org"
  type    = "A"
  # TODO increase all these Mailu TTLs
  ttl = "300"
  records = [
    "140.211.167.146"
  ]
}

resource "aws_route53_record" "mailu-test-mx" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "mail-test.seagl.org"
  type    = "MX"
  ttl     = "300"
  records = [
    "10 mail.mail-test.seagl.org."
  ]
}

resource "aws_route53_record" "mailu-test-spf" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "mail-test.seagl.org"
  type    = "TXT"
  ttl     = "300"
  records = [
    # This diverges from Mailu's rec: they wanted to include a:mail.mail-test.seagl.org too
    "v=spf1 mx ~all"
  ]
}

resource "aws_route53_record" "mailu-test-autoconfig-srv" {
  # grep SRV | sed -e 's/ 600 IN SRV /": "/' -e 's/^/"/' -e 's/$/",/' -e 's/ mail.mail-test.seagl.org.//' -e 's/.mail-test.seagl.org.//'
  for_each = {
    "_imap._tcp" : "20 1 143",
    "_pop3._tcp" : "20 1 110",
    "_submission._tcp" : "20 1 587",
    "_autodiscover._tcp" : "10 1 443",
    "_submissions._tcp" : "10 1 465",
    "_imaps._tcp" : "10 1 993",
    "_pop3s._tcp" : "10 1 995"
  }
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "${each.key}.mail-test.seagl.org"
  type    = "SRV"
  ttl     = "300"
  records = [
    "${each.value} mail.mail-test.seagl.org."
  ]
}

resource "aws_route53_record" "mailu-test-autoconfig-cname" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "autoconfig.mail-test.seagl.org"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "mail.mail-test.seagl.org."
  ]
}

resource "aws_route53_record" "mailu-test-dkim" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "dkim._domainkey.mail-test.seagl.org"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1Jw/diiAFRmarcHsr/KkGvfr22CVA5xTJTWRInvKi2My7PbWjhLSGNx7XcJw1DCcfOGb1cdArjNmYDmmG6VRRTQjCr2RWBSihIRLodnc+KPeS2Xnipi0JdNg7CTCNVQfA+znlKoWqalTT0nKrlDf87vhLmltU4wOYnrmvtZvtHkdwd9GA7hxMdHu4LnW\"\"X2VK0itMcPCBqIUvyOSIHJ8c7i8VPmcV+G6VDquepNsmFN0zcvNXAosqaWOHCnzCGzvQiwm6Lbq4vMxUsU6BLUv1JiPq3zXtqQ4tp6VynpLIy5VaF4XI5fyibsKTPuzI0d58tuiCrgCCMy5T9BmkCnQAzQIDAQAB"
  ]
}

resource "aws_route53_record" "mailu-test-dmarc" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "_dmarc.mail-test.seagl.org"
  type    = "TXT"
  ttl     = "300"
  records = [
    # TODO this email doesn't seem to be created automatically
    "v=DMARC1; p=reject; rua=mailto:dmarc@mail-test.seagl.org; ruf=mailto:dmarc@mail-test.seagl.org; adkim=s; aspf=s"
  ]
}

# 2023 ephemeral Matrix homeserver

locals {
  matrix_2023_server_ip = "140.211.167.238"
}

resource "aws_route53_record" "matrix-2023-ephemeral-a" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "matrix.2023.seagl.org"
  type    = "A"
  ttl     = "300"
  records = [
    local.matrix_2023_server_ip
  ]
}

resource "aws_route53_record" "matrix-2023-ephemeral-delegation-a" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "2023.seagl.org"
  type    = "A"
  alias {
    name                   = "d34bgs5yccfcw9.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
  }
}
