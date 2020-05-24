#Zane Stickel Udacity Project 2

# TODO: Designate a cloud provider, region, and credentials

provider "aws" {
  access_key = "AKIATDR3YNFCRNBEXGE6"
  secret_key = "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"
  region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "UdacityT2" {
  ami = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  count="4"
  vpc_security_group_ids= ["sg-28cf907e"]
  subnet_id="subnet-4e322429"
  tags={
      Name="UdacityT2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "UdacityM4" {
  ami = "ami-0323c3dd2da7fb37d"
  count="2"
  instance_type = "m4.large"
  vpc_security_group_ids=["sg-28cf907e"]
  subnet_id="subnet-4e322429"
  tags={
      Name="UdacityM4"
  }
}