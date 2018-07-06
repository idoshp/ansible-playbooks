#ansible.tf
#vars - values define in terraform.tfvars
###########################################
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AMI" {}
variable "KEY_NAME" {}
variable "INSTANCE_NAME" {}
variable "PRIVATE_KEY_PATH" {}
###########################################

provider "aws" {
access_key = "${var.AWS_ACCESS_KEY}"
secret_key = "${var.AWS_SECRET_KEY}"
region = "us-east-1"
}


resource "aws_instance" "web_server" {
ami = "${var.AMI}"
instance_type = "t2.micro"
key_name = "${var.KEY_NAME}"
count = 1
security_groups = ["access-http-ssh"]

tags {
Name = "${var.INSTANCE_NAME}"
}
provisioner "local-exec" {
    command = "echo ${aws_instance.web_server.public_dns} >> public_dns.txt"
}

provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --force",
      "sudo yum -y install ansible",
    ]
    connection {
      type     = "ssh"
      private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
      user     = "ec2-user"
      timeout  = "2m"
    }
  }

}

resource "aws_security_group" "sgweb" {
  name = "access-http-ssh"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "NODE_DNS" {
  value = "${aws_instance.web_server.public_dns}"
}

