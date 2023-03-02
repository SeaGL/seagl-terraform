module "prod_db" {
  source   = "./osem_rds"
  vpc_id   = data.aws_vpc.vpc.id
  vpc_cidr = data.aws_vpc.vpc.cidr_block
}
