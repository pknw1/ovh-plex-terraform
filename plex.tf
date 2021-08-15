module "plex" {

  source = "./modules/container"

  service = "plex"
  image_name = "linuxserver/plex:latest"
  port = "32400"
  data_dir = "/data"

}

