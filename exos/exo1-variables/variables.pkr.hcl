variable "nom_image_docker" {
  type    = string
  default = "ubuntu:focal"
}

variable "contenu_exemple_txt" {
  type    = string
  default = "ligne ecrite dans exemple.txt"
}

variable "tags_image" {
  type    = list(string)
  default = ["ubuntu-focal", "exo1"]
}
