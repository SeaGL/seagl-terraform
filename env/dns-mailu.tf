resource "aws_route53_record" "mailu-autoconfig-srv" {
  # grep SRV | sed -e 's/ 600 IN SRV /": "/' -e 's/^/"/' -e 's/$/",/' -e 's/ mail.mail-test.seagl.org.//' -e 's/.mail-test.seagl.org.//'
  for_each = {
    "_autodiscover._tcp" : "10 1 443",
    "_submissions._tcp" : "10 1 465",
    "_imaps._tcp" : "10 1 993",
    "_pop3s._tcp" : "10 1 995",
  }

  zone_id = aws_route53_zone.apex.id
  name    = "${each.key}.${var.zone_name}"
  type    = "SRV"
  ttl     = "600"
  records = [
    "${each.value} mail.${var.zone_name}."
  ]
}

resource "aws_route53_record" "mailu-autoconfig-srv-null" {
  # Ditto-ish (I manually edited a bit)
  for_each = toset([
    "_imap._tcp",
    "_pop3._tcp",
    "_submission._tcp",
  ])

  zone_id = aws_route53_zone.apex.id
  name    = "${each.key}.${var.zone_name}"
  type    = "SRV"
  ttl     = "600"
  records = [
    "0 0 0 ."
  ]
}

resource "aws_route53_record" "mailu-autoconfig-cname" {
  for_each = toset(["autoconfig", "autodiscover"])

  zone_id = aws_route53_zone.apex.id
  name    = "${each.key}.${var.zone_name}"
  type    = "CNAME"
  ttl     = "600"
  records = [
    "mail.${var.zone_name}."
  ]
}
