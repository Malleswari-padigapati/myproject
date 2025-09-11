provider "aws" {
  region = "ap-south-1"   # change to your AWS region
}

resource "aws_instance" "web" {
  ami           = "ami-02d26659fd82cf299"  
  instance_type = "t2.micro"
  key_name      = "practice"               

  vpc_security_group_ids = ["sg-0907581ea8223e15b"] # security group (allow 22 + 80)

  tags = {
    Name = "jenkins-docker-app"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
