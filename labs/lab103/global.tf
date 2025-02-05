provider "aws" {
 region = var.region
}

variable "region" {
 default = "us-east-1"
}



#variable "ami" {
# default = yaniv_ami.image_id
#}

variable "vm_name" {
 default = "vm-hanil"
}

variable "admin_username" {
 default = "admin-user"
}

variable "admin_password" {
 default = "Password123!"
}

variable "vm_size" {
 default = "t2.micro"
}
