provider "aws" {
  region                  = "us-east-2"
  shared_credentials_files = ["C:/Users/MAVi/.aws/credentials"]
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "lr6_security_group" {
  name        = "lr6-security-group"
  description = "Allow inbound traffic on ports 22, 80, and 8030"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8030
    to_port     = 8030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "lr624" {
  ami                         = "ami-02bf8ce06a8ed6092"
  instance_type               = "t2.micro"
  key_name                    = "lr45v4"
  subnet_id                   = aws_subnet.example_subnet.id
  vpc_security_group_ids      = [aws_security_group.lr6_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "lr624"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y git python3-pip docker
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
              sudo service docker start
              sudo usermod -aG docker ec2-user
              git clone https://github.com/mavi-fiot/IITLR45v3ins.git
              cd IITLR45v3ins
              docker build -t mavidoc/iitlr45v3ins:latest .
              docker push mavidoc/iitlr45v3ins:latest
              docker-compose build
              docker-compose up -d
              EOF
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key"
  public_key = file("C:/Users/MAVi/OneDrive/ФІОТ-матеріали/6_СЕМЕСТР/ІІТ/ЛР/ЛР45/lr45v4.pub")
}
