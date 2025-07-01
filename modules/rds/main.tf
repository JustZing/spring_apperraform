data "aws_availability_zones" "available_zones" {}

data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = "arn:aws:secretsmanager:us-east-1:354918380509:secret:springapp/rds/credentials/v1-s5dhsD"
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)
}

# Create security group for the RDS database
resource "aws_security_group" "database_security_group" {
  name        = "rds-security-group"
  description = "Allow MySQL access from EKS node group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow MySQL from EKS nodes"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

# Create subnet group for RDS
resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "db-secure-subnets"
  subnet_ids = [
    var.secure_subnet_az1_id,
    var.secure_subnet_az2_id
  ]
  description = "Subnet group for RDS in secure/private subnets"

  tags = {
    Name = "db-secure-subnets"
  }
}

# Create RDS instance
resource "aws_db_instance" "db_instance" {
  identifier              = "petclinic"
  engine                  = "mysql"
  engine_version          = "8.0.35"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = local.db_credentials.mysql_user
  password                = local.db_credentials.mysql_password
  db_name                 = "petclinic"
  publicly_accessible     = false
  multi_az                = false
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  skip_final_snapshot     = true

  tags = {
    Name = "petclinic-rds"
  }
}

