provider "aws" {
    region = "us-east-1"
  
}


resource "aws_instance" "ambiente-dev   " {

  instance_type = "t2.micro"
  ami = "ami-052efd3df9dad4825"
  key_name = "linuxtips"
  vpc_security_group_ids = [ "sg-017faccb1e8bbdd01" ]

  tags = {
    Name = "srv-dev-01"
  }



}


variable "ambiente_vpc_id" {
  default = "vpc-0871294b2664cdcf5"
}


resource "aws_security_group" "acesso_ssh_http" {
    name = "permitir_ssh"
    description = "Permite SSH e HTTP na instancia EC2"
    vpc_id = var.ambiente_vpc_id

    ingress {
        description = "Acesso SSH "
        from_port = 22
        cidr_blocks = [ "0.0.0.0/0" ]
        to_port = 22
        protocol = "tcp"
    } 

    ingress {
        description = "Acesso HTTP "
        from_port = 8080
        cidr_blocks = [ "0.0.0.0/0" ]
        to_port = 8080
        protocol = "tcp"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "permitir_ssh_e_http"
    }



}