terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "zonytest1234"
    key    = "app/terraform.tfstate" #Speicherort des Keys im Bucket
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  # access_key = ""
  # secret_key = ""
}

resource "aws_security_group" "ssh" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "zonykeyterraform02"
  public_key = "zonykeyterraform02"
}

resource "aws_instance" "demo" {
  ami           = "ami-0b6c6ebed2801a5cb" #ubuntu
  instance_type = "t2.micro"
  tags = {
    Name = "zony-testserver01"
  }
  key_name               = "zonykeyterraform02"
  vpc_security_group_ids = [aws_security_group.ssh.id]
}

output "instance_id" {
  value = aws_instance.demo.id
}

output "public_ip" {
  value = aws_instance.demo.public_ip
}