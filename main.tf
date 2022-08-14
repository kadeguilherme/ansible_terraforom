provider "aws" {
    region = "us-east-1"

}


resource "aws_instance" "ambiente-ansible" {

  instance_type = "t2.micro"
  ami = "ami-052efd3df9dad4825"
  key_name = "linuxtips"
  vpc_security_group_ids = [aws_security_group.acesso_ssh_http.id ]
  associate_public_ip_address = true
  
  tags = {
    Name = "srv-ansible"
  }

  provisioner "remote-exec" {

    connection {
      host = aws_instance.ambiente-ansible.public_dns
      type = "ssh"
      user = "ubuntu"
  
    }

    inline = [
      "sudo apt update",
      "sudo apt install ansible -y",
    ]
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