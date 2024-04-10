# Note: we intentionally do not create NS and SOA records and just let Route 53 create them automatically.
# This is Probably Fine(tm) because these records are basically never updated.

resource "aws_route53_zone" "apex" {
  name = var.zone_name
}

resource "aws_route53_record" "delegation-ns" {
  count   = var.attach_to_zone != null ? 1 : 0
  zone_id = var.attach_to_zone.zone_id
  name    = aws_route53_zone.apex.name
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.apex.name_servers
}

resource "aws_ses_domain_identity" "main" {
  domain = var.zone_name
}

# SPF
resource "aws_route53_record" "route_53_root_txt" {
  zone_id = aws_route53_zone.apex.id
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = concat([
    "v=spf1 include:_spf.google.com include:amazonses.com include:40081384.spf02.hubspotemail.net include:_spf.osuosl.org ~all",
  ], var.additional_root_txts)
}

# DKIM
# TODO DKIM verification seems to need to be manually initiated in the console
resource "aws_ses_domain_dkim" "email_dkim" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_route53_record" "email_dkim_records" {
  count   = 3
  zone_id = aws_route53_zone.apex.id
  name    = "${element(aws_ses_domain_dkim.email_dkim.dkim_tokens, count.index)}._domainkey.${var.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "${element(aws_ses_domain_dkim.email_dkim.dkim_tokens, count.index)}.dkim.amazonses.com",
  ]
}

resource "aws_route53_record" "route_53_dmarc_txt" {
  zone_id = aws_route53_zone.apex.id
  name    = "_dmarc.${var.zone_name}"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=DMARC1;p=quarantine;rua=mailto:dmarc-rpt@${var.zone_name}"
  ]
}

resource "aws_route53_record" "dokku_wildcard" {
  zone_id = aws_route53_zone.apex.id
  name    = "*.${var.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "dokku.${var.zone_name}"
  ]
}

resource "aws_route53_record" "mailu-test-a" {
  zone_id = aws_route53_zone.apex.id
  name    = "mail.mail-test.${var.zone_name}"
  type    = "A"
  # TODO increase all these Mailu TTLs
  ttl = "300"
  records = [
    "140.211.167.146"
  ]
}

resource "aws_route53_record" "mailu-test-mx" {
  zone_id = aws_route53_zone.apex.id
  name    = "mail-test.${var.zone_name}"
  type    = "MX"
  ttl     = "300"
  records = [
    "10 mail.mail-test.${var.zone_name}."
  ]
}

resource "aws_route53_record" "mailu-test-spf" {
  zone_id = aws_route53_zone.apex.id
  name    = "mail-test.${var.zone_name}"
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
  zone_id = aws_route53_zone.apex.id
  name    = "${each.key}.mail-test.${var.zone_name}"
  type    = "SRV"
  ttl     = "300"
  records = [
    "${each.value} mail.mail-test.${var.zone_name}."
  ]
}

resource "aws_route53_record" "mailu-test-autoconfig-cname" {
  zone_id = aws_route53_zone.apex.id
  name    = "autoconfig.mail-test.${var.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "mail.mail-test.${var.zone_name}."
  ]
}

resource "aws_route53_record" "mailu-test-dkim" {
  zone_id = aws_route53_zone.apex.id
  name    = "dkim._domainkey.mail-test.${var.zone_name}"
  type    = "TXT"
  ttl     = "300"
  records = [
    # TODO parameterize this
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1Jw/diiAFRmarcHsr/KkGvfr22CVA5xTJTWRInvKi2My7PbWjhLSGNx7XcJw1DCcfOGb1cdArjNmYDmmG6VRRTQjCr2RWBSihIRLodnc+KPeS2Xnipi0JdNg7CTCNVQfA+znlKoWqalTT0nKrlDf87vhLmltU4wOYnrmvtZvtHkdwd9GA7hxMdHu4LnW\"\"X2VK0itMcPCBqIUvyOSIHJ8c7i8VPmcV+G6VDquepNsmFN0zcvNXAosqaWOHCnzCGzvQiwm6Lbq4vMxUsU6BLUv1JiPq3zXtqQ4tp6VynpLIy5VaF4XI5fyibsKTPuzI0d58tuiCrgCCMy5T9BmkCnQAzQIDAQAB"
  ]
}

resource "aws_route53_record" "mailu-test-dmarc" {
  zone_id = aws_route53_zone.apex.id
  name    = "_dmarc.mail-test.${var.zone_name}"
  type    = "TXT"
  ttl     = "300"
  records = [
    # TODO this email doesn't seem to be created automatically
    "v=DMARC1; p=reject; rua=mailto:dmarc@mail-test.${var.zone_name}; ruf=mailto:dmarc@mail-test.${var.zone_name}; adkim=s; aspf=s"
  ]
}

resource "aws_route53_record" "mailu-server" {
  zone_id = aws_route53_zone.apex.id
  name    = "mail.${var.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "mailu.host.${var.zone_name}"
  ]
}
