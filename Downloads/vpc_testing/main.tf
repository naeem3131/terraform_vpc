# aws vpc sample demo
# Create vpc, subnets, igw, route table, etc....

provider "aws" {
  region     = "us-east-1"
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}

# VPC Creation

resource "aws_vpc" "test_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true

  tags = {
    Name = "testing"
  }
}

# Create aws subnet and add to vpc
resource "aws_subnet" "test_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "testing-subnet"
  }
}

# Add internte gateway and attach to vpc
resource "aws_internet_gateway" "test_gw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "testing-gateway"
  }
}

resource "aws_route_table" "test_rtb" {
  vpc_id = aws_vpc.test_vpc.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gw.id
  }

  tags = {
    Name = "testing-rtb"
  }
}

resource "aws_route_table_association" "test-rtb-association" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_rtb.id
}

# Create aws security group
# Add inbound and outbond rules

resource "aws_security_group" "test_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]    
     }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "testing_sg"
  }
}