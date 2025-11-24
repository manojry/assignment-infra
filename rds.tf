# Database Infrastructure

resource "aws_db_subnet_group" "main" {
  name       = "docuflow-db-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_secondary.id]
  
  tags = {
    Name = "docuflow-db-subnet-group"
  }
}

## change to modules
resource "aws_security_group" "database" {
  name        = "docuflow-database-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.api.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "docuflow-database-sg"
  }
}

resource "aws_kms_key" "rds_master" {
  description             = "KMS key for RDS secret encryption"
  deletion_window_in_days = 7

  tags = {
    Name = "docuflow-rds-master-kms-key"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "docuflow-db"

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"

  db_name  = "docuflow"
  username = var.db_admin_username

  manage_master_user_password = true
  master_user_secret_kms_key_id = aws_kms_key.rds_master.arn

  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  allocated_storage = 20
  storage_type      = "gp3"
  multi_az          = true

  publicly_accessible = false
  skip_final_snapshot = false

  tags = {
    Name = "docuflow-database"
  }
}

data "aws_secretsmanager_secret" "db_master" {
  arn = aws_db_instance.postgres.master_user_secret[0].secret_arn
}

data "aws_secretsmanager_secret_version" "db_master" {
  secret_id = data.aws_secretsmanager_secret.db_master.id
}

resource "aws_secretsmanager_secret_rotation" "db_rotation" {
  secret_id = aws_db_instance.postgres.master_user_secret[0].secret_arn
  rotation_rules {
    automatically_after_days = 90
  }
}



