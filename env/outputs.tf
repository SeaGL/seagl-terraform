output "zone_name" {
  value = aws_route53_zone.apex.name
}

output "zone_id" {
  value = aws_route53_zone.apex.id
}

output "github_domain" {
  value = var.github_domain
}
