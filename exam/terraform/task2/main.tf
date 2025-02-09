provider "aws" {
    region = "us-east-1"
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
    vpc_id = aws_vpc.custom_vpc.id

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

resource "aws_instance" "web_server" {
    ami             = data.aws_ami.ubuntu.id
    instance_type   = "t2.micro"
    subnet_id       = aws_subnet.public_subnet.id
    security_groups = [aws_security_group.sg.name]
    associate_public_ip_address = true
}

resource "time_sleep" "wait_for_ip" {
    create_duration = "1m"
}

resource "null_resource" "validate_ip" {
    provisioner "local-exec" {
        command = <<EOT
        retries=4
        interval=30
        for i in $(seq 1 $retries); do
        if [ -z "${aws_instance.vm.public_ip}" ]; then
            echo "Attempt $i: Public IP address not assigned yet, retrying in $interval seconds..."
            sleep $interval
        else
            echo "Public IP address assigned: ${aws_instance.vm.public_ip}"
            exit 0
        fi
        done
        echo "ERROR: Public IP address was not assigned after $retries attempts." >&2
        exit 1
        EOT
    }
    depends_on = [time_sleep.wait_for_ip]
}

output "instance_public_ip" {
    description = "Public IP of the EC2 instance"
    value       = aws_instance.web_server.public_ip
}
