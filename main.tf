provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "docker_app" {
  ami           = "ami-02d26659fd82cf299" 
  instance_type = "t2.micro"
  key_name      = "practice"              

  vpc_security_group_ids = ["sg-0907581ea8223e15b"] 

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io git

              # Start Docker
              systemctl start docker
              systemctl enable docker

              # Clone GitHub repo
              git clone https://github.com/Malleswari-padigapati/myproject.git /home/ubuntu/myproject

              # Build Docker image
              cd /home/ubuntu/myproject
              docker build -t myapp:latest .

              
              docker run -d -p 8089:5000 myapp:latest
              EOF

  tags = {
    Name = "jenkins-terraform-docker"
  }
}

output "public_ip" {
  value = aws_instance.docker_app.public_ip
}
