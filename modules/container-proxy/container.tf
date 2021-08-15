data "template_file" "docker_compose2" {
  template = <<EOF
version: '3'

volumes:
  config-${var.service}:

services:
  ${var.service}-config:
    image: pknw1/config:latest
    pull_policy: always
    container_name: config-${var.service}
    hostname: config-${var.service}
    restart: always 
    networks:
      - proxy
    volumes:
      - /etc/ssl:/etc/ssl:ro
      - /root/.ssh:/root/.ssh:ro
      - /etc/localtime:/etc/localtime:ro
      - config-${var.service}:${var.data_dir}
    environment:
      - TZ="Europe/London"
      - PUID=666
      - PGID=666
      - REPO=config-${var.service}

  ${var.service}:
    image: ${var.image_name}
    container_name: ${var.service}
    restart: always
    hostname: ${var.service}
    depends_on:
      - ${var.service}-config
    dns:
      - "8.8.8.8"
    networks:
      - proxy
    ports:
      - 0.0.0.0:8080:80
    volumes:
     - /var/run/docker.sock:/tmp/docker.sock:ro
      - /var/run/php-fpm.sock:/var/run/php-fpm.sock
      - /etc/ssl:/etc/ssl
      - /etc/localtime:/etc/localtime
      - /tmp:/tmp
      - config-docker-proxy/nginx:/etc/nginx
      - config-docker-proxy/www:/var/www
      - config-docker-proxy/logs:/var/log
      - /download:/host/mnt/download:ro
      - /content:/media:ro
      - /shared:/shared
      - /:/host
      - config-${var.service}/etc/nginx:/etc/nginx
      - config-${var.service}/www:/var/www
      - config-${var.service}/logs:/var/log
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
      content      = "${data.template_file.docker_compose2.rendered}"
    }
  }

  resource "null_resource" "docker_compose" {
    triggers = {
      template = "${data.template_file.docker_compose2.rendered}"
    }
 
    provisioner "local-exec" {
      command = "mkdir -p ./docker-stack/${var.service}"
    }

    provisioner "local-exec" {
      command = "echo \"${data.template_file.docker_compose2.rendered}\" > ./docker-stack/${var.service}/docker-compose.yml"
    }

}

