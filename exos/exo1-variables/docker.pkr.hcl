packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = var.nom_image_docker
  commit = true
}

build {
  name = "exo1-variables"
  sources = [
    "source.docker.ubuntu",
  ]

  provisioner "shell" {
    environment_vars = [
      "TXT=${var.contenu_exemple_txt}",
    ]
    inline = [
      "echo \"$TXT\" > exemple.txt",
    ]
  }

  post-processor "docker-tag" {
    repository = "exo1-variables"
    tags       = var.tags_image
  }
}
