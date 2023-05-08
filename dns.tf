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
    "v=spf1 include:_spf.google.com include:amazonses.com ~all",
    "google-site-verification=9Hrl69xXhSeoBOVlnmpOYOSS6fYeiuGehZjHlyPZx3g"
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

resource "aws_route53_record" "status" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "status.seagl.org"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "dokku.seagl.org"
  ]
}
