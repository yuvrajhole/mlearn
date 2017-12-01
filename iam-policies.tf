#Defult Profile for Instances (empty)
resource "aws_iam_role" "default_instance_role" {
    name = "${var.project}_default_instance_role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "default_iam_instance_profile" {
    name = "${var.project}_default_iam_instance_profile_${var.aws_region}"
    role = "${aws_iam_role.default_instance_role.name}"
}

data "template_file" "tpl_iamrolepolicy_ec2_cloudwatch_access" {
    template = "${file("${path.module}/resources/policies/cloudwatch-ec2-access.json")}"
}

resource "aws_iam_role_policy" "iamrolepolicy_ec2_cloudwatch_access" {
    name = "${var.environment}_ec2_cloudwatch_access"
    role = "${aws_iam_role.default_instance_role.id}"
    policy = "${data.template_file.tpl_iamrolepolicy_ec2_cloudwatch_access.rendered}"
}

#RDS enhanced monitoring role (empty)
resource "aws_iam_role" "enhanced_mon_role" {
    name = "${var.project}_rds_enhanced_mon_role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "template_file" "tpl_iamrolepolicy_rds_mon_role" {
    template = "${file("${path.module}/resources/policies/rds-enhanced-mon-role.json")}"
}

resource "aws_iam_role_policy" "iamrolepolicy_rds_mon_role" {
    name = "${var.environment}_rds_enhanced_mon_role"
    role = "${aws_iam_role.enhanced_mon_role.id}"
    policy = "${data.template_file.tpl_iamrolepolicy_rds_mon_role.rendered}"
}

