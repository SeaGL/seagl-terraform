resource "aws_ses_domain_identity" "seagl" {
  domain = "seagl.org"
}

resource "aws_route53_record" "seagl_amazonses_verification_record" {
  zone_id = "Z0173878287JIU5M4KB8R"
  name    = "_amazonses.seagl.org"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.seagl.verification_token]
}