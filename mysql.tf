#MYSQL RDS Multi-AZ

resource "aws_db_instance" "mysql" {
  allocated_storage          = "${var.allocated_storage}"
  engine                     = "mysql"
  engine_version             = "${var.engine_version}"
  identifier                 = "${var.database_identifier}"
  snapshot_identifier        = "${var.snapshot_identifier}"
  instance_class             = "${var.dbinstance_type}"
  storage_type               = "${var.storage_type}"
  name                       = "${var.database_name}"
  password                   = "${var.database_password}"
  username                   = "${var.database_username}"
  backup_retention_period    = "${var.backup_retention_period}"
  backup_window              = "${var.backup_window}"
  maintenance_window         = "${var.maintenance_window}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  final_snapshot_identifier  = "${var.final_snapshot_identifier}"
  skip_final_snapshot        = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot      = "${var.copy_tags_to_snapshot}"
  multi_az                   = "${var.multi_availability_zone}"
  port                       = "${var.database_port}"
  vpc_security_group_ids     = ["${aws_security_group.sg_mysql.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.mysql_sg.name}"
  parameter_group_name       = "${aws_db_parameter_group.mysql_pg.name}"
  option_group_name          = "${aws_db_option_group.mysql_og.name}"
  storage_encrypted          = "${var.storage_encrypted}"
  monitoring_role_arn        = "${aws_iam_role.enhanced_mon_role.arn}"
  monitoring_interval        = "60"

  tags {
    Name        = "${var.project}-mysql"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}


resource "aws_db_subnet_group" "mysql_sg" {
  name       = "mysqlmainsg"
  subnet_ids = ["${aws_subnet.subnet_private_mysql1.id}", "${aws_subnet.subnet_private_mysql2.id}"]

  tags {
    Name = "soroco-pg-subnetgroup"
  }
}

resource "aws_db_parameter_group" "mysql_pg" {
  name   = "mysql-pg"
  description = "mysql-pg5.6"
  family = "mysql5.6"
  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  parameter {
    name  = "general_log"
    value = "1"
  }
  parameter {
    name  = "long_query_time"
    value = "10"
  }
  parameter {
    name  = "log_output"
    value = "FILE"
  }

}

resource "aws_db_option_group" "mysql_og" {
  name                     = "${var.project}-mysql-og"
  option_group_description = "${var.project}-mysql5.6-og"
  engine_name              = "mysql"
  major_engine_version     = "5.6"
}


output "dbendpoint" {
  value = "${aws_db_instance.mysql.endpoint}"
}

