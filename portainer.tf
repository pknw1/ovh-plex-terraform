module "portainer" {

  source = "./modules/container"

  service = "portainer-module"
  image_name = "portainer/portainer:latest"
  port = "9000"
  data_dir = "/data"

}

