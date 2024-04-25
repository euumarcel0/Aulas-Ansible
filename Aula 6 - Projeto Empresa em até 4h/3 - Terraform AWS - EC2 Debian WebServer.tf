//_____________________________________________________________________________________________
# Grupo de Segurança para Debian
resource "aws_security_group" "DebianPicPay_sg" {
  name        = "DebianPicPay-sla"
  description = "Allow SSH, HTTP, HTTPD, HTTPS and Ping"
  vpc_id      = aws_vpc.VPC-PicPay.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPD"
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPD"
  }

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPD"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ping"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//_____________________________________________________________________________________________

# Instância Debian com Docker
resource "aws_instance" "Debian_Server" {
  ami                         = "ami-058bd2d568351da34" # Substitua pelo ID da AMI do Debian
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.Subnet_Publica.id # Altere conforme necessário
  key_name                    = "vockey"               # Altere conforme necessário
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.DebianPicPay_sg.id]

  user_data = <<-EOF
              #!/bin/bash
               # Atualiza a lista de pacotes
               apt-get update

               # Define o nome do host
               hostnamectl set-hostname hospedeiropicpay1
               #Atualizar nome 
               bash

               # Adiciona a linha ao arquivo /etc/apt/sources.list
               echo "deb http://deb.debian.org/debian/ bullseye main" >> /etc/apt/sources.list

               # Atualiza a lista de pacotes novamente
               apt update -y

               #Mudar senha do root
               echo -e "Info@134134\nInfo@134134" | passwd root

               # Descomenta e define PermitRootLogin como yes
               sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

               # Define PasswordAuthentication como yes
               sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

               # Reinicia o serviço SSH para aplicar as alterações
               systemctl restart ssh
              EOF

  tags = {
    Name = "hospedeiropicpay1"
  }
}

// _____________________________________________________________________________________________

# Instância Debian com Docker
resource "aws_instance" "Debian_Server2" {
  ami                         = "ami-058bd2d568351da34" # Substitua pelo ID da AMI do Debian
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.Subnet_Publica.id # Altere conforme necessário
  key_name                    = "vockey"               # Altere conforme necessário
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.DebianPicPay_sg.id]

  user_data = <<-EOF
              #!/bin/bash
               # Atualiza a lista de pacotes
               apt-get update

               # Define o nome do host
               hostnamectl set-hostname hospedeiropicpay2
               #Atualizar nome 
               bash

               # Adiciona a linha ao arquivo /etc/apt/sources.list
               echo "deb http://deb.debian.org/debian/ bullseye main" >> /etc/apt/sources.list

               # Atualiza a lista de pacotes novamente
               apt update -y

               #Mudar senha do root
               echo -e "Info@134134\nInfo@134134" | passwd root

               # Descomenta e define PermitRootLogin como yes
               sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

               # Define PasswordAuthentication como yes
               sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

               # Reinicia o serviço SSH para aplicar as alterações
               systemctl restart ssh
              EOF

  tags = {
    Name = "hospedeiropicpay2"
  }
}

//_____________________________________________________________________________________________

output "debian_hospedeiro1_instance_public_ip" {
  description = "IP Publico da Instancia EC2 HospedeiroPicPay1"
  value       = aws_instance.Debian_Server.public_ip
}

output "debian_hospedeiro2_instance_public_ip" {
  description = "IP Publico da Instancia EC2 HospedeiroPicPay2"
  value       = aws_instance.Debian_Server2.public_ip
}
