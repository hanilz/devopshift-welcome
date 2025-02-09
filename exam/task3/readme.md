# Task 3 Modules Explanation
## vpc_ec2
### Explanation
Creates a vpc network and an EC2 machine of your desired size that is inside that VPC. 
### Created Resources
- VPC.
- Internet Gateway.
- Public and private Subnets.
- Public and private Routing Tables.
- Security Group with ports 22 and 80 open.
- An AWS EC2 instance that uses the latest Ubuntu 22.04 AMI.
### Location
`modules/vpc_ec2/main.tf`

Source it with:

`source = "./modules/vpc_ec2"`
### Usage
In order to use this module, you need to specify the following variables:

Variable | Type | Explaination
--- | --- | --- 
vpc_cidr | string | Cidr block of the VPC 
subnet_count | int | Desired subnet count
instance_type | string | EC2 instance's type
assign_public_ip | boolean | Wether or not to assign a public IP for the EC2 instance 
### Output
You can see the public IP of the created EC2 instance by using:

```
output "ec2_public_ip" {
  value = module.vpc_ec2.instance_public_ip
}
```