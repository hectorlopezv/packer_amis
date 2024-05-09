packer {
  required_plugins {
    amazon = {
      version = "~> 1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "jenkins-worker" {
  ami_name      = "jenkins-basic-worker"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-07caf09b362be10b8"
  ssh_username  = "ec2-user"
  tags = {
    Name = "jenkins-basic-worker"
  }
}

build {
  sources = ["source.amazon-ebs.jenkins-worker"]

  provisioner "shell" {
    inline = [
      "sudo dnf install java-17-amazon-corretto -y",
      "sudo dnf install git-all -y",
      "sudo dnf install docker -y",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ec2-user"
    ]

  }
}