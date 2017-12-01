##ALB

resource "aws_alb" "frontendinternal" {
  name            = "${lower(var.project)}-${var.environment}-frontend-alb"
  internal        = true
  security_groups = ["${aws_security_group.sg_elb.id}"]
  subnets         = ["${aws_subnet.subnet_private_application1.id}", "${aws_subnet.subnet_private_application2.id}"]

  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket = "${aws_s3_bucket.elb_logging_bucket.bucket}"
    prefix = "INTERNALALB/APP"
#    interval = 5
  }
#  depends_on =        [ "{aws_s3_bucket.elb_logging_bucket.bucket}" ]
  tags {
    Group = "${var.project}"
    Environment = "${var.environment}"
    Version =               "${var.version}"
  }
}



#resource "aws_alb_target_group" "webapisecure" {
#       name = "${var.project}-${var.environment}-tg-webapisecure"
#  port = 443
#  protocol = "HTTPS"
#  vpc_id = "${aws_vpc.vpc_blaze.id}"
#  health_check {
#      healthy_threshold = 2
#      unhealthy_threshold = 2
#      timeout = 3
#      path = "/"
#      protocol = "HTTPS"
#          interval = 10
#  }
#
#
#  tags {
#    Group = "${var.project}"
#    Environment = "${var.environment}"
#  }
#}


###Target group for ALB

resource "aws_alb_target_group" "webappinternal" {
  name = "${lower(var.project)}-${var.environment}-tg-webappinternal"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.vpc_mlearn.id}"
  deregistration_delay = 180
  health_check {
      healthy_threshold = 2
      unhealthy_threshold = 3
      timeout = 5
      port = "${var.http_port}"
      path = "/v1"
          protocol = "HTTP"
          interval = 10
  }
  stickiness {
      type = "lb_cookie"
      cookie_duration = 300
      enabled = "true"
}

  tags {
    Group = "${var.project}"
    Environment = "${var.environment}"
        Version =               "${var.version}"
  }
}



resource "aws_alb_listener" "alb-https-internal" {
   load_balancer_arn = "${aws_alb.frontendinternal.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
   certificate_arn = "${var.web_ssl_certificate_id}"
default_action {
     target_group_arn = "${aws_alb_target_group.webappinternal.arn}"
     type = "forward"
   }
}


resource "aws_alb_target_group_attachment" "internal1" {
  target_group_arn = "${aws_alb_target_group.webappinternal.arn}"
  target_id        = "${aws_instance.ec2_app1.id}"
  port             = 80
}

output "internalalb_address" {
  value = "${aws_alb.frontendinternal.public_dns}"
}
output "internalalb_zone_id" {
  value = "${aws_alb.frontendinternal.zone_id}"
}


