provider "aws" {
  region                  = "us-east-2"
  shared_credentials_files = ["C:/Users/MAVi/.aws/credentials"]
}

resource "aws_instance" "lr61" {
  ami             = "ami-0c55b159cbfafe1f0"  # Вкажіть відповідний AMI ID
  instance_type   = "t2.micro"
  key_name        = "lr45v4"  # Ім'я  ключа
  security_groups = ["lr6-security-group"]  # Ім'я  групи безпеки


  tags = {
      Name = "lr61.2"
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

# resource "aws_vpc" "lr6" {
#   cidr_block = "10.0.0.0/16"
# }

resource "aws_subnet" "lr6" {
  vpc_id     = aws_vpc.lr6.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "lr6_security_group" {
  name        = "lr6-security-group"
  description = "Allow inbound traffic on ports 80 and 8033"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8033
    to_port     = 8033
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# provider "aws" {
#   region                  = "us-east-2"
#   shared_credentials_files = ["C:/Users/MAVi/.aws/credentials"]
# }


# resource "aws_instance" "lr61" {
#   ami = "ami-02bf8ce06a8ed6092" 
#   instance_type = "t2.micro"
#   key_name = "lr45v4"
 
#   tags = {
#       Name = "lr61"
#     }

#     # Встановлення публічного IP-адреси
#   associate_public_ip_address = true

#     # Зв'язування з безпечною групою
#   vpc_security_group_ids = [aws_security_group.lr6_security_group.id]
# }

# # Опис мережевих ресурсів
# resource "aws_vpc" "example_vpc" {
#     cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "example_subnet" {
#     vpc_id     = aws_vpc.example_vpc.id
#     cidr_block = "10.0.1.0/24"
# }

# # Опис правил файрвола
# resource "aws_security_group" "lr6_security_group" {
#     name        = "lr6-security-group"
#     description = "Allow inbound traffic on port 80 and 8033"

#     ingress {
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     ingress {
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     ingress {
#         from_port   = 8033
#         to_port     = 8033
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }


