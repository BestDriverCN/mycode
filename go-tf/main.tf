/* main.tf */

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.22.0"
    }
  }
}

provider "docker" {}
provider "http" {}

data "http" "test" {
  url = "http://0.0.0.0:2224/spock"
  request_headers = {
    Accept = "application/json"
  }
  depends_on = [resource.docker_container.gosvr]
}
output "spocks_wisdom" {
  description = "response from /spock api"
  value       = data.http.test.response_body
}

resource "docker_image" "gosvr" {
  # the name of our go image
  name         = var.image_name
  keep_locally = true // keep image after "destroy"
}

resource "docker_container" "gosvr" {
  image = docker_image.gosvr.image_id
  name  = var.container_name
  ports {
    internal = 9876
    external = 2224
  }
}

