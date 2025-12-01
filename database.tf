resource "aws_db_subnet_group" "main" {
  name       = var.name
  subnet_ids = aws_subnet.private[*].id

  tags = local.tags
}

resource "aws_rds_cluster" "main" {
  cluster_identifier          = var.name
  engine                      = "aurora-mysql"
  engine_version              = var.db_engine_version
  database_name               = var.db_name
  master_username             = var.db_username
  manage_master_user_password = true
  backup_retention_period     = 1
  preferred_backup_window     = "07:00-09:00"
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  skip_final_snapshot         = var.environment == "dev" ? true : false
  deletion_protection         = var.environment == "prod" ? true : false
  storage_encrypted           = true

  tags = local.tags
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "${var.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version

  tags = local.tags
}