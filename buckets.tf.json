##ELB Logging Bucket

resource "aws_s3_bucket" "elb_logging_bucket" {
    acl =               "log-delivery-write"
    bucket =            "${var.aws_region}-${lower(var.project)}-elb-logging-bucket"
    force_destroy =     true
    policy =            "${data.template_file.tpl_s3_elb_logging_policy.rendered}"

    depends_on =        [ "data.template_file.tpl_s3_elb_logging_policy" ]

    tags {
        Environment =   "${var.environment}"
        Name =          "elb_logging_bucket_${var.project}"
    }
}


# ELB Logging Access to S3

data "template_file" "tpl_s3_elb_logging_policy" {
    template = "${file("${path.module}/resources/policies/s3-elb-logging-policy.json")}"
    vars {
        aws_account_number =    "${var.aws_account_number}"
        elb_logging_bucket =    "${var.aws_region}-${lower(var.project)}-elb-logging-bucket"
        elb_account_number =    "${lookup(var.elb_account_number, var.aws_region)}"
    }
}


resource "aws_s3_bucket" "rds_mysql_logs_bucket" {
  bucket = "${var.aws_region}-${lower(var.project)}-rds-mysql-logs-bucket"
  acl    = "private"
  force_destroy =     true
  tags {
        Environment =   "${var.environment}"
        Name =          "rds-mysql-logs-bucket_${var.project}"
    }
}
