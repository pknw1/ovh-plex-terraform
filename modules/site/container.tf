#  resource "null_resource" "compose" {
# 
#    provisioner "local-exec" {
#     command = "docker exec -it config-proxy /sync-www.sh ${var.repo}"
#     #command = "docker restart proxy"
#    }
#
#
#}


terraform {
  required_providers {
    docker-utils = {
      source = "Kaginari/docker-utils"
      version = "0.0.4"
    }
  }
}


resource "docker-utils_exec" "exec" {
  container_name = "config-proxy"    
  commands = ["/bin/bash","-c","/sync-www.sh $REPO"] 
  environment = ["REPO=${var.repo}"] 
}
