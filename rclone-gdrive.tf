# https://github.com/pknw1/docker-rclone-mount


module "rclone-gdrive" {
  
  source = "./modules/container-rclone"

  service = "gdrive"
  image_name = "pknw1/rclone-mount:rcloneroot"

}

