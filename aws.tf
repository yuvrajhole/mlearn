provider "aws" {
#    access_key = "${var.aws_access_key}"
#    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    version = "1.2"
}

output "AWS INFO" {
    value = ">>>>>>>>>>>>>>>>>> ${var.environment}: ${var.aws_account_name} <<<<<<<<<<<<<<<<<<"
}
