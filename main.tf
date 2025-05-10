data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

// AWS EC2 instance resource
resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [module.blog_sg.security_group_id]
  tags = {
    Name = "Learning Terraform"
  }
}
resource "aws_security_group" "blog" {
  name        = "blog"
  description = "Allow HTTP and HTTPS inbound traffic, and all outbound traffic"
  
  vpc_id      = data.aws_vpc.default.id

}

module "blog_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4.13.0"
  name       = "blog_new"

  vpc_id              = data.aws_vpc.default.id
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "blog_http_in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"

  cidr_blocks        = ["0.0.0.0/0"]
  // Security group for the instance
  security_group_id = aws_security_group.blog.id
}
resource "aws_security_group_rule" "blog_https_in" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"

  cidr_blocks        = ["0.0.0.0/0"]
  // Security group for the instance
  security_group_id = aws_security_group.blog.id
}
resource "aws_security_group_rule" "blog_everything_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  // -1 allows all protocols
  protocol          = -1

  cidr_blocks        = ["0.0.0.0/0"]
  // Security group for the instance
  security_group_id = aws_security_group.blog.id
}