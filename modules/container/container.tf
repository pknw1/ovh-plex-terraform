data "template_file" "docker_compose" {
  template = <<EOF
version: '3'
services:
  ${var.service}:
    image: ${var.image_name}
    container_name: ${var.service}
    restart: always
    hostname: ${var.service}
    networks:
      - proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/ssl:/etc/ssl:ro
      - /etc/localtime:/etc/localtime:ro
      - /tmp:/tmp
      - ./config/${var.service}:${var.data_dir}
      - /shared:/shared
    environment:
      - TZ="Europe/London"
      - VIRTUAL_HOST=${var.service}.pknw1.co.uk
      - VIRTUAL_PORT=${var.port}
      - PUID=666
      - PGID=666


networks:
  proxy:
    external:
      name: proxy
EOF
}

  data "template_cloudinit_config" "docker_compose" {
    gzip          = false
    base64_encode = false

    part {
      filename     = "output.pk"
      content_type = "text/cloud-config"
      content      = "${data.template_file.docker_compose.rendered}"
    }
  }

  resource "null_resource" "docker_compose" {
    triggers = {
      template = "${data.template_file.docker_compose.rendered}"
    }
 
    provisioner "local-exec" {
      command = "mkdir -p ./docker-stack/${var.service}"
    }

    provisioner "local-exec" {
      command = "echo \"${data.template_file.docker_compose.rendered}\" > ./docker-stack/${var.service}/docker-compose.yml"
    }

}

