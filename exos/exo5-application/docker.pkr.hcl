packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "nodejs_api" {
  image  = "node:20-bookworm-slim"
  commit = true
  changes = [
    "WORKDIR /app",
    "EXPOSE 3000",
    "CMD [\"npm\", \"start\"]",
  ]
}

build {
  name = "exo5-application"
  sources = [
    "source.docker.nodejs_api",
  ]

  provisioner "file" {
    source      = "./ci-cd"
    destination = "/app"
  }

  provisioner "shell" {
    inline = [
      "cd /app && npm install",
    ]
  }

  post-processor "docker-tag" {
    repository = "exo5-ci-cd-api"
    tags       = ["latest"]
  }
}
