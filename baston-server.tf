resource "aws_instance" "cicd-ec2" {
  ami           = "ami-079db87dc4c10ac91"
  instance_type = "t2.micro"
  key_name      = "my-keypair"
  vpc_security_group_ids = [aws_security_group.vpc-sgp.id]
  subnet_id = aws_subnet.public-subnets[0].id
  associate_public_ip_address = true

  tags = {
    Name = "jump-server"
  }
}
