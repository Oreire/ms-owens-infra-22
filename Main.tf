terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69.0"
    }
  }
  required_version = ">= 1.9.5"
}

provider "aws" {
  region = "eu-west-2"
  # AWS Credentials used to run terraform apply command and IMMEDIATELY DELETED

}

#Create Security Group for Frontend Node 1 & Frontend Node 2 EC2 Instances

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  # ... other configuration ...
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#Create Security Group for Backend 1 & Backend 2 EC2 Instances

resource "aws_security_group" "allow_http" {
  name = "allow_http"
  # ... other configuration ...
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#Create Security Group for MySQL Database (EC2 Database Server)

resource "aws_security_group" "allow_MySQL" {
  name = "allow_MySQL"
  # ... other configuration ...

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#create Security Group for AWS RDS Database 

resource "aws_security_group" "allow_RDS" {
  name = "allow_RDS"

  # ... other configuration ...
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#Create AWS EC2 Instance (Frontend Node 1)

resource "aws_instance" "Frontend_server" {
  ami                    = "ami-0b45ae66668865cd6"
  instance_type          = "t2.micro"
  key_name               = "DevOpsKeys"
  user_data              = file("./Frontend_install.sh")
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "Frontend Node 1"
  }
}

#Create AWS EC2 Instance (Frontend Node 2)

resource "aws_instance" "Frontend_server2" {
  ami                    = "ami-0b45ae66668865cd6"
  instance_type          = "t2.micro"
  key_name               = "DevOpsKeys"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data              = file("./Frontend_install.sh")
  subnet_id              = "subnet-08f39ef073ea39bcd" #newline for different AZ
  tags = {
    Name = "Frontend Node 2"
  }
}

#Create Backend EC2 Instances 

#Create Backend 1 in AZ eu-west-2a

resource "aws_instance" "Backend_server" {
  ami                    = "ami-0b45ae66668865cd6"
  instance_type          = "t2.micro"
  key_name               = "DevOpsKeys"
  user_data              = file("./Backend_install.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "Backend 1"
  }
}

#Create Backend 2 in AZ eu-west-2b

resource "aws_instance" "Backend_server2" {
  ami                    = "ami-0b45ae66668865cd6"
  instance_type          = "t2.micro"
  key_name               = "DevOpsKeys"
  user_data              = file("./Backend_install.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  subnet_id              = "subnet-08f39ef073ea39bcd" #newline for different AZ
  tags = {
    Name = "Backend 2"
  }
}

#Create MySQL Database EC2 Instance in AZ eu-west-2a 

resource "aws_instance" "Database_server" {
  ami                    = "ami-0b45ae66668865cd6"
  instance_type          = "t2.micro"
  key_name               = "DevOpsKeys"
  user_data              = file("./Database_install.sh")
  vpc_security_group_ids = [aws_security_group.allow_MySQL.id]
  tags = {
    Name = "MYSQL Database"
  }
}

#Create AWS RDS Database Resource in AZ eu-west-2b (IAM permission enabled in AWS console to create RDS)
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_Admin # "Lancer"
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  availability_zone      = "eu-west-2b"
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.allow_RDS.id]
}
