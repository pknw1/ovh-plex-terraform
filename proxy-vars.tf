variable "proxy" {
  description = "map of container values"
  type        = map
  default     = {
    proxy = {
	image_name = "jwilder/nginx-proxy:latest"
        port       = 80
    },
  }
}
