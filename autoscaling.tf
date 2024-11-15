
# Launch Template for Auto Scaling Group Instances
resource "aws_launch_template" "asg_lt" {
  name_prefix   = "asg-lt-"
  image_id      = var.ami  # Replace with a valid AMI ID for eu-central-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.NTI_key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]  # Replace with the security group for private instances
  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update
              dnf install nginx
              systemctl start nginx
              systemctl enable nginx
              EOF  
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  target_group_arns    = [aws_lb_target_group.asg_tg.arn]  # Ensure this target group exists if using with a load balancer

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}

# Output for reference
output "autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}
output "efs_id" {
  value = aws_efs_file_system.example.id
  description = "The ID of the EFS file system"
}

