terraform {
  required_version = ">=1.6.0" # Versão do Terraform

  # Provedores Utilizados
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0" # Versão do AWS no Terraform
    }
  }
}

provider "aws" {
 region = "us-east-1"
 shared_config_files      = ["C:/Users/46683590842/.aws/config"]
 shared_credentials_files = ["C:/Users/46683590842/.aws/credentials"]
}

# Criar Grupo de Segurança Windows
resource "aws_security_group" "Grupo_de_Seguranca_Windows" {
 name        = "grupowindows"
 description = "Allow rdp inbound traffic"

 ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
}

# Criar EC2 Windows
resource "aws_instance" "windows" {
 ami           = "ami-03cd80cfebcbb4481" # Windows Server 2022 Base
 instance_type = "t3.large"
 key_name      = "vockey" # Não esqueca de gerar a chave  pública e privada para este nome!
 vpc_security_group_ids = [aws_security_group.Grupo_de_Seguranca_Windows.id]
 associate_public_ip_address = true

 tags = {
    Name = "Windows_Instance"
 }
}
