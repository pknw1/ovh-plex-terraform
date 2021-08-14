data "template_file" "docker_compose" {
  template = <<EOF
version: '3'
services:
  rclone-${var.service}:
    image: pknw1/rclone-mount:rcloneroot
    container_name: rclone-mount-${var.service}
    security_opt:
      - apparmor:unconfined
    cap_add:
      - SYS_ADMIN
    devices:
      - "/dev/fuse:/dev/fuse"
    environment:
      - PUID=666
      - PGID=666
      - PUMASK=0000
      - TZ=Europe/London
      - RCLONE_REMOTE_MOUNT=${var.service}:/
    volumes:
      - /mnt/rclone-${var.service}:/data-${var.service}:shared
      - /home/docker/.config/rclone:/rclone
      - /tmp:/tmp
      - /etc/localtime:/etc/localtime:ro

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
      command = "mkdir -p ./docker-stack/${var.service}/config"
    }
    
    provisioner "local-exec" {
      command = "cp ~/.config/rclone/rclone.conf ./docker-stack/${var.service}/config/rclone.conf"
    }

    provisioner "local-exec" {
      command = "echo \"${data.template_file.docker_compose.rendered}\" > ./docker-stack/${var.service}/docker-compose.yml"
    }

}

