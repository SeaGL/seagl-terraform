terraform {
  backend "s3" {
    bucket = "seagl-terraform"
    key    = "rds/osem"
    region = "us-west-2"
  }
}