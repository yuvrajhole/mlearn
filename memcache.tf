#Memcached cluster Multi-AZ

resource "aws_elasticache_cluster" "mlearn_memcache" {
  cluster_id           = "${lower(var.project)}-${var.environment}-memcache"
  engine               = "memcached"
  engine_version       = "${var.memcache_engine_version}"
  node_type            = "${var.memcache_instance_type}"
  port                 = "${var.cache_port}"
  num_cache_nodes      = "${var.cache_instance_count}"
  parameter_group_name = "${aws_elasticache_parameter_group.mlearn_memcache_pg.name}"
  maintenance_window   = "${var.maintenance_window_memcache}"
  subnet_group_name    = "${aws_elasticache_subnet_group.mlearn_memcache_subnet_group.name}"
  security_group_ids   = ["${aws_security_group.sg_memcache.id}"]
  az_mode              = "cross-az"     # single-az or cross-az
  availability_zones   = ["${var.az_1}","${var.az_2}"]  
  tags {
    Name        = "${var.project}-${var.environment}-memcache"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}




resource "aws_elasticache_parameter_group" "mlearn_memcache_pg" {
  name   = "${lower(var.project)}-${var.environment}-memcache-pg"
  family = "memcached1.4"

#  parameter {
#    name  = "activerehashing"
#    value = "yes"
#  }
#
#  parameter {
#    name  = "min-slaves-to-write"
#    value = "2"
#  }
}

resource "aws_elasticache_subnet_group" "mlearn_memcache_subnet_group" {
  name       = "${lower(var.project)}-${var.environment}-memcache-sg"
  subnet_ids = ["${aws_subnet.subnet_private_mysql1.id}","${aws_subnet.subnet_private_mysql2.id}"]
}

output "memcache_configuration_endpoint" {
  value = "${aws_elasticache_cluster.mlearn_memcache.configuration_endpoint}"
}

output "memcache_cluster_address" {
  value = "${aws_elasticache_cluster.mlearn_memcache.cluster_address}"
}
