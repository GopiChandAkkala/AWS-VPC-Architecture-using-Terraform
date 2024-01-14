resource "aws_security_group" "vpc-sgp" {
  name        = "VPC-Security-Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]    
  }

  ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
  
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # You might want to restrict this to a specific IP range for security
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]    
  }

  tags = {
    Name = "allow_tls_ssh"
  }
}