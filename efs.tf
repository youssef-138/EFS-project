# Create an EFS File System
resource "aws_efs_file_system" "example" {
  creation_token = "example-efs"
  encrypted      = true

  tags = {
    Name = "example-efs"
  }
}
# Security Group for EFS Mount Targets
resource "aws_security_group" "efs_sg" {
  name   = "efs-sg"
  vpc_id = aws_vpc.main.id

  # Allow inbound NFS traffic from private subnet instances
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.private_1-subnet-cidr, var.private_2-subnet-cidr]  # Adjust CIDR blocks for your private subnets
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}

# Mount Target for Private Subnet 1
resource "aws_efs_mount_target" "private_1" {
  file_system_id  = aws_efs_file_system.example.id
  subnet_id       = aws_subnet.private_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

# Mount Target for Private Subnet 2
resource "aws_efs_mount_target" "private_2" {
  file_system_id  = aws_efs_file_system.example.id
  subnet_id       = aws_subnet.private_2.id
  security_groups = [aws_security_group.efs_sg.id]
}
