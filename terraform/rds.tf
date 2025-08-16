resource "aws_db_subnet_group" "default" {
  name       = "main-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14.6"
  instance_class         = "db.t3.micro" # Free tier eligible
  db_name                = "kstaxdb"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
}
