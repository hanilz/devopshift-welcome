variable "vpc_id" {}

variable "public_subnets" {}

variable "instance_type" {
  	default     = "t2.micro"
}

variable "min_instances" {
  	default     = 1
}

variable "max_instances" {
  	default     = 3
}

variable "assign_public_ip" {
  	default     = true
}

data "aws_ami" "ubuntu" {
	most_recent = true
	owners      = ["099720109477"]
	filter {
		name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  	}
}

resource "aws_security_group" "sg" {
	vpc_id = var.vpc_id

	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
  	}

  	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
  	}
}

resource "aws_lb" "alb" {
	name               = "app-load-balancer"
	internal           = false
	load_balancer_type = "application"
	security_groups    = [aws_security_group.sg.id]
	subnets           = var.public_subnets
}

resource "aws_lb_target_group" "tg" {
	name     = "alb-target-group"
	port     = 80
	protocol = "HTTP"
	vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "listener" {
	load_balancer_arn = aws_lb.alb.arn
	port              = 80
	protocol          = "HTTP"

	default_action {
		type             = "forward"
		target_group_arn = aws_lb_target_group.tg.arn
  	}
}

resource "aws_launch_template" "lt" {
	name_prefix   = "hanil-app-template"
	image_id      = data.aws_ami.ubuntu.id
	instance_type = var.instance_type

	network_interfaces {
		associate_public_ip_address = var.assign_public_ip
		security_groups             = [aws_security_group.sg.id]
  	}

  	tag_specifications {
		resource_type = "instance"
		tags = { Name = "AutoScaling-Instance" }
  	}
}

resource "aws_autoscaling_group" "asg" {
	vpc_zone_identifier = var.public_subnets
	desired_capacity    = var.min_instances
	min_size           = var.min_instances
	max_size           = var.max_instances

	launch_template {
		id      = aws_launch_template.lt.id
		version = "$Latest"
  	}

  	target_group_arns = [aws_lb_target_group.tg.arn]

  	tag {
		key                 = "Name"
		value               = "ASG-Instance"
		propagate_at_launch = true
  	}
}

# Output ALB DNS Name
output "alb_dns_name" {
	description = "DNS name of the ALB"
	value       = aws_lb.alb.dns_name
}
