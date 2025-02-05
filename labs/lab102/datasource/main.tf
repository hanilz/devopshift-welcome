provider "aws" {
  region = var.region
}

variable "region" {
  default = "us-east-1"
}

data "aws_instance" "yanivvm" {
  tags = {"Name":"yaniv-vm"}
  instance_id = "i-09df7e0ed385f871b"
}

output "public_ip_address" {
  value = data.aws_instance.yanivvm.public_ip
}