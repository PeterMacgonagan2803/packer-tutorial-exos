packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:focal"
  commit = true
}

build {
  name = "exo3-provisionnement"
  sources = [
    "source.docker.ubuntu",
  ]

  provisioner "file" {
    source      = "welcome.txt"
    destination = "/home/welcome.txt"
  }
}
