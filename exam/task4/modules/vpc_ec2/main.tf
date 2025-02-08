provider "aws" {
  	region = "us-east-1"
}

variable "vpc_cidr" {}
variable "subnet_count" {}
variable "instance_type" {}
variable "assign_public_ip" {}

resource "aws_vpc" "vpc" {
  	cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "igw" {
  	vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnet" {
	count             = var.subnet_count
	vpc_id           = aws_vpc.vpc.id
	cidr_block       = cidrsubnet(var.vpc_cidr, 8, count.index)
	map_public_ip_on_launch = true
	availability_zone = "us-east-1a"
	tags = { Name = "hanil-exam-public-subnet-${count.index}" }
}

resource "aws_subnet" "private_subnet" {
	count       = var.subnet_count
	vpc_id      = aws_vpc.vpc.id
	cidr_block  = cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)
	availability_zone = "us-east-1b"
	tags = { Name = "hanil-exam-private-subnet-${count.index}" }
}

resource "aws_route_table" "public_rt" {
	vpc_id = aws_vpc.vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
  	}
}

resource "aws_route_table_association" "public_assoc" {
	count          = var.subnet_count
	subnet_id      = aws_subnet.public_subnet[count.index].id
	route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  	vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "private_assoc" {
	count          = var.subnet_count
	subnet_id      = aws_subnet.private_subnet[count.index].id
	route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "sg" {
	vpc_id = aws_vpc.vpc.id
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
  	}
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

data "aws_ami" "ubuntu" {
	most_recent = true
	owners      = ["099720109477"]
	filter {
		name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
	}
}

resource "aws_instance" "vm" {
	ami                         = data.aws_ami.ubuntu.id
	instance_type               = var.instance_type
	subnet_id                   = aws_subnet.public_subnet[0].id
	security_groups             = [aws_security_group.sg.name]
	associate_public_ip_address = var.assign_public_ip
}

output "instance_public_ip" {
	description = "Public IP of the EC2 instance"
	value       = aws_instance.vm.public_ip
}
