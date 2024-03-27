resource "aws_instance" "dokku" {
  ami           = "ami-036d46416a34a611c"
  instance_type = "t3.small"

  associate_public_ip_address = true
  key_name                    = "RC bootstrap key" # TODONE!

  vpc_security_group_ids = ["sg-0e719b49f7d4d7f08"]

  tags = {
    Name = "dokku.seagl.org"
  }
}
