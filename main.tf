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

              # Clone GitHub repo (branch man)
              git clone -b man https://github.com/Malleswari-padigapati/myproject.git /home/ubuntu/myproject

              # Build Docker image
              cd /home/ubuntu/myproject
              docker build -t myapp:latest .

              # Run container on port 80
              docker run -d -p 80:5000 myapp:latest
              EOF

  tags = {
    Name = "jenkins"
  }

  # Run docker ps after creation
  provisioner "remote-exec" {
    inline = [
      "docker ps"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("practice.pem")
      host        = self.public_ip
    }
  }
}

output "public_ip" {
  value = aws_instance.docker_app.public_ip
}
