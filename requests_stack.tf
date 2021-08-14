module "radarr" {

  source = "./modules/container"

  service = "radarr"
  image_name = "linuxserver/radarr:latest"
  port = "7878"

}

module "sonarr" {

  source = "./modules/container"

  service = "sonarr"
  image_name = "linuxserver/sonarr:latest"
  port = "8989"

}

module "overseerr" {

  source = "./modules/container"

  service = "overseerr"
  image_name = "linuxserver/overseerr:latest"
  port = "5055"

}


module "jackett" {

  source = "./modules/container"

  service = "jackett"
  image_name = "linuxserver/jackett:latest"
  port = "9117"

}

module "utorrent" {

  source = "./modules/container"

  service = "utorrent"
  image_name = "linuxserver/qbittorrent:latest"
  port = "8080"

}
