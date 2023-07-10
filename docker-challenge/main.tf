terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
}

resource "docker_image" "simplegoservice" {
  name = "registry.gitlab.com/alta3/simplegoservice:latest"
  keep_locally = true
}

resource "docker_container" "simplegoservice" {
  name  = var.container_name
  image = docker_image.simplegoservice.image_id
  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

