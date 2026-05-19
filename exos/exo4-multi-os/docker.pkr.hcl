packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu2204" {
  image  = "ubuntu:jammy"
  commit = true
}

source "docker" "alpine319" {
  image  = "alpine:3.19"
  commit = true
}

build {
  name = "exo4-multi-os"
  sources = [
    "source.docker.ubuntu2204",
    "source.docker.alpine319",
  ]

  provisioner "shell" {
    only = ["docker.ubuntu2204"]
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update -qq",
      "apt-get install -y curl wget",
      "uname -a > /system-info.txt",
      "cat /etc/os-release >> /system-info.txt",
      "printf '%s\\n' '#!/bin/sh' 'echo \"=== system-info.txt ===\"' 'cat /system-info.txt' 'echo \"=== live ===\"' 'uname -a' > /usr/local/bin/show-info.sh",
      "chmod +x /usr/local/bin/show-info.sh",
    ]
  }

  provisioner "shell" {
    only = ["docker.alpine319"]
    inline = [
      "# apk via https peut planter selon le poste (cert ssl)",
      "sed -i 's/https/http/g' /etc/apk/repositories",
      "apk update --no-cache",
      "apk add --no-cache curl wget ca-certificates",
      "uname -a > /system-info.txt",
      "cat /etc/os-release >> /system-info.txt",
      "printf '%s\\n' '#!/bin/sh' 'echo \"=== system-info.txt ===\"' 'cat /system-info.txt' 'echo \"=== live ===\"' 'uname -a' > /usr/local/bin/show-info.sh",
      "chmod +x /usr/local/bin/show-info.sh",
    ]
  }

  post-processor "docker-tag" {
    repository = "multi-os-ubuntu"
    tags       = ["latest"]
    only       = ["docker.ubuntu2204"]
  }

  post-processor "docker-tag" {
    repository = "multi-os-alpine"
    tags       = ["latest"]
    only       = ["docker.alpine319"]
  }
}
