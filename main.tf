# provider "aws" {
#   region                  = "us-east-2"
#   shared_credentials_files = ["C:/Users/MAVi/.aws/credentials"]
# }


# resource "aws_instance" "lr62" {
#   ami = "ami-02bf8ce06a8ed6092" 
#   instance_type = "t2.micro"
#   key_name = "lr45v4"
 
#   tags = {
#       Name = "lr62aws"
#     }

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install -y git python3-pip docker
#               sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#               sudo chmod +x /usr/local/bin/docker-compose
#               sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
#               sudo service docker start
#               sudo usermod -aG docker ec2-user
#               git clone https://github.com/mavi-fiot/IITLR45v3ins.git
#               cd IITLR45v3ins
#               docker build -t mavidoc/iitlr45v3ins:latest .
#               docker push mavidoc/iitlr45v3ins:latest
#               docker-compose build
#               docker-compose up -d
#               EOF


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

# AWS 63

provider "aws" {
  region  = "us-east-2"
  shared_credentials_files = ["C:/Users/MAVi/.aws/credentials"]
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


# resource "aws_security_group" "lr6_security_group" {
#   name = "lr6-security-group"

#   # Додайте правила вхідного трафіку, необхідні для вашого екземпляра
#   ingress = [
#     {
#       from_port = 22
#       to_port = 22
#       protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "Дозволити доступ SSH з будь-якого місця"
#     },
#     {
#       from_port = 80
#       to_port = 80
#       protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "Дозволити HTTP-трафік з будь-якого місця"
#       ipv6_cidr_blocks = []  # Встановіть необов'язкові атрибути на порожні списки
#       prefix_list_ids = []
#       security_groups = []
#       self = false
#     },
#     {
#       from_port = 8033
#       to_port = 8033
#       protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "Дозволити трафік на нестандартному порту 8033 з будь-якого місця"
#       ipv6_cidr_blocks = []
#       prefix_list_ids = []
#       security_groups = []
#       self = false
#     }
#   ]
# }

resource "aws_instance" "lr63aws" {
  # ... інші параметри ...

  # Замість null_resource використовуємо local-exec
  provisioner "local-exec" {
    command = <<EOF
      docker run my-docker-image /config.sh
    EOF
  }  
  ami           = "ami-02bf8ce06a8ed6092"
  instance_type = "t2.micro"
  key_name      = "lr45v4"

  tags = {
    Name = "lr63aws"
  }
  
  # Зберігаємо асоціацію з публічною IP-адресою та безпечною групою
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.lr6_security_group.id]
}



