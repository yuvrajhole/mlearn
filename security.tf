### Security Groups

# Alphabetical order, please...


# ALB
resource "aws_security_group" "sg_elb" {
    description =       "Allows HTTPS traffic to the elb"
    name =              "${var.project}_sg_elb"
    vpc_id =            "${aws_vpc.vpc_mlearn.id}"

        #HTTPS
        ingress {
        from_port =     443
        to_port =       443
        protocol =      "tcp"
        cidr_blocks =   ["0.0.0.0/0"]
    }
        #HTTP
#        ingress {
#        from_port =     80
#        to_port =       80
#        protocol =      "tcp"
#        cidr_blocks =   ["0.0.0.0/0"]
#    }


    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_elb"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}

# APPLICATION SERVER SG
resource "aws_security_group" "sg_application" {
    description =       "Allows HTTP/HTTPS traffic to the APP from ELB"
    name =              "${var.project}_sg_app"
    vpc_id =            "${aws_vpc.vpc_mlearn.id}"

        #HTTP
    ingress {
        from_port =     80
        to_port =       80
        protocol =      "tcp"
        security_groups = ["${aws_security_group.sg_elb.id}"]
    }
        #HTTPS
    ingress {
        from_port =     443
        to_port =       443
        protocol =      "tcp"
        security_groups = ["${aws_security_group.sg_elb.id}"]
    }
        # SSH
    ingress {
        from_port =     22
        to_port =       22
        protocol =      "tcp"
	security_groups =	["${aws_security_group.sg_bastion.id}"]
    }



    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_app"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
   }
}

resource "aws_security_group" "sg_mysql" {
    description =       "Allows DB connection to the App"
    name =              "${var.project}_sg_mysql"
    vpc_id =            "${aws_vpc.vpc_mlearn.id}"


    #mysql
    ingress {
        from_port =     3306
        to_port =       3306
        protocol =      "tcp"
        security_groups = ["${aws_security_group.sg_application.id}"]
    }


    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_mysql"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}


# Bastion
resource "aws_security_group" "sg_bastion" {
    description =       "Allows SSH traffic to the Bastion"
    name =              "${var.environment}_sg_bastion"
    vpc_id =            "${aws_vpc.vpc_mlearn.id}"

    ingress {
        from_port =     22
        to_port =       22
        protocol =      "tcp"
        cidr_blocks =   ["42.107.0.0/16"]
    }

    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_bastion"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}



# script_server
resource "aws_security_group" "sg_script_server" {
    description =       "Allows SSH traffic from the Bastion"
    name =              "${var.environment}_sg_script_server"
    vpc_id =            "${aws_vpc.vpc_mlearn.id}"

    ingress {
        from_port =     22
        to_port =       22
        protocol =      "tcp"
        security_groups =   ["${aws_security_group.sg_bastion.id}"]
    }

    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }
    tags {
        Name =          "${var.project}_sg_script_server"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}


# Ops_server
resource "aws_security_group" "sg_ops_server" {
    description =       "Allows SSH traffic from the Bastion"
    name =              "${var.environment}_sg_ops_server"
    vpc_id =            "${aws_vpc.vpc_mlearn.id}"

    ingress {
        from_port =     22
        to_port =       22
        protocol =      "tcp"
        security_groups =   ["${aws_security_group.sg_bastion.id}"]
    }

    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }
    tags {
        Name =          "${var.project}_sg_ops_server"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}

# Memcache SG
resource "aws_security_group" "sg_memcache" {
    description =       "Allows memcache access"
    name =              "${var.environment}_sg_memcache"
    vpc_id =            "${aws_vpc.vpc_mlearn.id}"

    ingress {
        from_port =     11211
        to_port =       11211
        protocol =      "tcp"
        security_groups =   ["${aws_security_group.sg_application.id}","${aws_security_group.sg_mysql.id}"]
    }

    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }
    tags {
        Name =          "${var.project}_sg_memcache"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}

