


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

}

resource "aws_default_vpc" "default" {

}

//HTTP Server -> SG
//SG -> 80 TCP, 22 TCP, CIDR []

resource "aws_security_group" "http_server_sg" {
  name = "http.server_sg"
  //vpc_id = "vpc-2a8cfd57"
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "http_server_sg"
  }


}

resource "aws_instance" "http_server" {
  #ami                    = "ami-0c2b8ca1dad447f8a"
  ami                    = data.aws_ami.aws-linux-2-latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  // subnet_id              = "subnet-d10c2d8e"
  subnet_id = tolist(data.aws_subnet_ids.default_subnets.ids)[3]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)

  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Welcome devops - ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }

}

