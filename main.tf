terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66.0"
    }
  }
  required_version = "~> 1.2"
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "promo_sg" {
  name        = "promo_sg"
  description = "Allow inbound traffic for Prometheus"

  ingress {
    from_port   = 9090
    to_port     = 9090
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "promo-sg"
  }
}

resource "aws_eip" "promo_eip" {
  domain   = "vpc"
  instance = aws_instance.promo_server.id
}

resource "aws_instance" "promo_server" {
  ami           = "ami-0892a9c01908fafd1"
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.promo_sg.id]

  # user_data = file("${path.module}/userdata.tpl")

  tags = {
    Name = "Prometheus-Server"
  }

  key_name = var.key_name
  # associate_public_ip_address = true
  subnet_id = var.subnet_id
}

output "public_ip" {
  value = aws_instance.promo_server.public_ip
}