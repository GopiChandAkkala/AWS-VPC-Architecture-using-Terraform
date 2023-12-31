resource "aws_launch_template" "ec2-lt" {
  name = "EC2-launch-template"  
  image_id = "ami-079db87dc4c10ac91"  
  instance_type = "t2.micro"
  key_name = "my-keypair"  

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.vpc-sgp.id]
  } 

  user_data = filebase64("ec2-apache.sh")
}