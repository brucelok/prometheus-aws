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

resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus_security_group"
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
    Name = "prometheus-sg"
  }
}

resource "aws_instance" "prometheus_instance" {
  ami           = "ami-076fe60835f136dc9"
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]

  user_data = file("${path.module}/userdata.tpl")

  tags = {
    Name = "Prometheus-Server"
  }

  key_name = var.key_name
  associate_public_ip_address = true
  subnet_id = var.subnet_id
}