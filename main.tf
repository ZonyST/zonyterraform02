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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCaH1iEB3hBw47HDxGn0j7kefc8cTFeg8/I1Yp8mcpbP2/Idvm1hT4GLv0umwKHFdqcSqEMvQ4Z+eNHZZlhdOkn7YIxFpRRgHhsWHOpAv4giS+krcaECTBFih1XQRjAX09IAfQzebhuYF15xCOvHLaQ5ftlWLV6bjtYHd+wyNK3uQL9qFYhb+1pJzNQE3xuNqDsrB2FUK//e/vAEVvSWEzjPSiMAcNK/O3nuLApRPUcvE4M+EfwRmsSXkFCtGc2v82X/NWz5hUKw/9n9PJA4S9uHfqsXDC5rZxm1LqtajBYX2bvIBQAoer//m8Y2J10EuO6U7uRSkjtKOT7yyuMIspPy+2JVG2TT/2sHEG3LF2wlXnL6jMGgJosRKJdGIvRE4A6JXqAKXSAWamGnIBvrdsXkE2wXzasy6SAJK/cGujMgJHMDJZbUVTE3louN+pjM4JKgxC/Dm0vkFVWsrRTdwu2LQiPdGIaxIThiYUWyWXqYkDPcm8iV7Z7MVAPECxtuxMHBMmbwA0VL+8aqqqVI5XJ9F8vGX8BtoLGC3ZZLqJoekgJ/+PyjMVaxzKLEpL++xn4k/m/sSfpHEST3BZDT73NPa8BNoc6gdzyYKIQbdW/ebRHTWcs6CQMstgI103eF7xGEzeI62r4nsVmC5R2v5bvMlnzYs3jt1sptsqlGSZujw== st@Ubuntu01"
}

resource "aws_instance" "demo" {
  ami           = "ami-0b6c6ebed2801a5cb" #ubuntu
  instance_type = "t2.micro"
  tags = {
    Name = "zony-testserver01"
  }
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]
}

output "instance_id" {
  value = aws_instance.demo.id
}

output "public_ip" {
  value = aws_instance.demo.public_ip
}