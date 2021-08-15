variable "requests" {
  description = "map of container values"
  type        = map
  default     = {
    sonarr = {
	image_name = "linuxserver/sonarr:latest"
        port       = 7979
    },
    radarr = {
        image_name = "linuxserver/radarr:latest"
        port       = 8989
    },
    jackett = {
        image_name = "linuxserver/jackett:latest"
        port       = 9117
    },
    overseerr = {
        image_name = "linuxserver/overseerr:latest"
        port       = 5055
    },
    utorrent = {
        image_name = "linuxserver/qbittorrent:latest"
        port       = 8080
    }
  }
}
