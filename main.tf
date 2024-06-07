provider "aws" {
  region                   = "us-east-2"
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

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

resource "aws_security_group" "lr631_security_group" {
  name        = "lr631-security-group"
  description = "Allow inbound traffic on port 80 and 8030"
  vpc_id      = aws_vpc.example_vpc.id

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

  # lifecycle {
  #     prevent_destroy = true
  # }
}

resource "aws_instance" "lr631" {
  ami           = "ami-02bf8ce06a8ed6092"
  instance_type = "t2.micro"
  key_name      = "lr45v4"

  tags = {
    Name = "lr631aws_nginx"
  }

  user_data = <<-EOF
            #!/bin/bash
            # exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
            # set -x

            # echo "Installing Docker"
            # sudo yum install -y yum-utils
            # sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            # sudo yum install -y docker-ce docker-ce-cli containerd.io
            # sudo systemctl enable docker
            # sudo systemctl start docker

            # echo "Installing Nginx"
            # sudo yum install -y epel-release
            # sudo yum install -y nginx
            # sudo systemctl enable nginx
            # sudo systemctl start nginx

            echo "Installing git and python3-pip"
            sudo yum install -y git python3-pip

            echo "Installing docker-compose"
            sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

            echo "Adding ec2-user to docker group"
            sudo usermod -aG docker ec2-user
            newgrp docker

            echo "Cloning the repository"
            git clone https://github.com/mavi-fiot/IITLR45v3ins.git || { echo 'Git clone failed'; exit 1; }
            sleep 60  # Пауза для завершення

            echo "Building Docker image"
            cd IITLR45v3ins || { echo 'cd to IITLR45v3ins failed'; exit 1; }
            sudo docker build -t mavidoc/iitlr45v3ins:latest . || { echo 'Docker build failed'; exit 1; }
            sleep 60  # Пауза для завершення Docker build

            echo "Pushing Docker image"
            sudo docker push mavidoc/iitlr45v3ins:latest || { echo 'Docker push failed'; exit 1; }

            echo "Building and running Docker Compose"
            sudo docker-compose build || { echo 'Docker-compose build failed'; exit 1; }
            sleep 30  # Пауза для завершення Docker-compose build
            sudo docker-compose up -d || { echo 'Docker-compose up failed'; exit 1; }

            echo "Script completed successfully"
            EOF

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lr631_security_group.id]
}



# provider "aws" {
#   region                  = "us-east-2"
#   shared_credentials_files = ["C:/Users/MAVi/.aws/credentials"]
# }

# # Опис мережевих ресурсів
# resource "aws_vpc" "example_vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "example_subnet" {
#   vpc_id     = aws_vpc.example_vpc.id
#   cidr_block = "10.0.1.0/24"
# }

# # Опис правил файрвола
# resource "aws_security_group" "lr6_security_group" {
#   name        = "lr6-security-group-${random_id.random.hex}"  # Використання унікального імені
#   description = "Allow inbound traffic on ports 22, 80, 443, 8030, and 1433"

#   vpc_id = aws_vpc.example_vpc.id  # Зв'язок з VPC

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 8030
#     to_port     = 8030
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 1433
#     to_port     = 1433
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = -1
#     to_port     = -1
#     protocol    = "icmp"
#     cidr_blocks = ["192.168.0.107/32"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "random_id" "random" {
#   byte_length = 4
# }

# resource "aws_instance" "lr623" {
#   ami             = "ami-02bf8ce06a8ed6092"
#   instance_type   = "t2.micro"
#   key_name        = "lr45v4"
#   subnet_id       = aws_subnet.example_subnet.id

#   tags = {
#     Name = "lr623tf"
#   }

#   user_data = <<-EOF
#             #!/bin/bash
#             exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#             set -x

#             echo "Updating system"
#             sudo yum update -y
#             sleep 30  # Додаткова пауза для завершення оновлення

#             echo "Installing nginx"
#             sudo amazon-linux-extras install -y nginx1

#             echo "Installing git, python3-pip, and docker"
#             sudo yum install -y git python3-pip docker

#             echo "Pausing for installations to complete"
#             sleep 130  # Пауза для завершення установки

#             echo "Enabling and starting docker"
#             sudo systemctl enable docker
#             sudo systemctl start docker

#             echo "Installing docker-compose"
#             sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#             sudo chmod +x /usr/local/bin/docker-compose
#             sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#             echo "Adding ec2-user to docker group"
#             sudo usermod -aG docker ec2-user
#             newgrp docker

#             echo "Cloning the repository"
#             git clone https://github.com/mavi-fiot/IITLR45v3ins.git || { echo 'Git clone failed'; exit 1; }
#             sleep 60  # Пауза для завершення

#             echo "Building Docker image"
#             cd IITLR45v3ins || { echo 'cd to IITLR45v3ins failed'; exit 1; }
#             sudo docker build -t mavidoc/iitlr45v3ins:latest . || { echo 'Docker build failed'; exit 1; }
#             sleep 60  # Пауза для завершення Docker build

#             echo "Pushing Docker image"
#             sudo docker push mavidoc/iitlr45v3ins:latest || { echo 'Docker push failed'; exit 1; }

#             echo "Building and running Docker Compose"
#             sudo docker-compose build || { echo 'Docker-compose build failed'; exit 1; }
#             sleep 30  # Пауза для завершення Docker-compose build
#             sudo docker-compose up -d || { echo 'Docker-compose up failed'; exit 1; }

#             echo "Script completed successfully"
#             EOF

#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.lr6_security_group.id]
# }

# resource "aws_key_pair" "deployer_key" {
#   key_name   = "deployer-key"
#   public_key = file("C:/Users/MAVi/OneDrive/ФІОТ-матеріали/6_СЕМЕСТР/ІІТ/ЛР/ЛР45/lr45v4.pub")
# }
