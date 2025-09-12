provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "docker_app" {
  ami           = "ami-02d26659fd82cf299" # Ubuntu 22.04 LTS
  instance_type = "t2.micro"
  key_name      = "practice"              # your key pair name
  vpc_security_group_ids = ["sg-0907581ea8223e15b"] # must allow 22,80

  tags = {
    Name = "jenkins"
  }

  # Run all setup steps synchronously
  provisioner "remote-exec" {
    inline = [
      # Update & install dependencies
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io git",

      # Start and enable Docker
      "sudo systemctl start docker",
      "sudo systemctl enable docker",

      # Clone GitHub repo (branch man)
      "git clone -b man https://github.com/Malleswari-padigapati/myproject.git /home/ubuntu/myproject || true",

      
      "cd /home/ubuntu/myproject && sudo docker build -t myapp:latest .",

      
      "sudo docker run -d -p 80:5000 myapp:latest",

      
      "sudo docker ps"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("practice.pem") # path to your PEM file
      host        = self.public_ip
    }
  }
}

# Outputs
output "public_ip" {
  value = aws_instance.docker_app.public_ip
}

output "app_url" {
  value = "http://${aws_instance.docker_app.public_ip}"
}
