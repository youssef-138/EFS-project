resource "aws_instance" "public_instance" {
  ami           = var.ami # Example Amazon Linux AMI; use a region-appropriate AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.NTI_key.key_name
  security_groups = [aws_security_group.public_sg.id]

  tags = {
    Name = "public-ec2-instance"
  }
}

