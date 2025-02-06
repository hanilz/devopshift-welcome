module "main" {
    source = "./modules"
    ami = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"
    name = "hanil-vm"
}

output "printingmpduleinfo" {
    value = module.main
  
}