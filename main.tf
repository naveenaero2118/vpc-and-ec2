resource "aws_instance" "http" {
    ami = "ami-04db49c0fb2215364"
    instance_type = "t2.large"
    key_name = "${var.key_name}"
    user_data = file("${path.module}/install.sh")
    security_groups = ["${aws_security_group.http-sg.name}"]
    tags = {
        Name = "${var.name}"
    }
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-lwp-bucket-2021"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_security_group" "http-sg" {
  name        = "http-sg"
  description = "Allow traffic for http"
  vpc_id      = "${var.vpc_name}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
