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
  name = "exo2-resultats"
  sources = [
    "source.docker.ubuntu",
  ]

  provisioner "shell" {
    inline = [
      "echo exo2 manifest > exemple.txt",
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}
