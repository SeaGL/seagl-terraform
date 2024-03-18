module "production_env" {
  source    = "./env"
  zone_name = "seagl.org"
  additional_root_txts = [
    "google-site-verification=9Hrl69xXhSeoBOVlnmpOYOSS6fYeiuGehZjHlyPZx3g"
  ]
}
