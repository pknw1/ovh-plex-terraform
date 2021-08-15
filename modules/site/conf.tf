data "template_file" "www_site" {
  template = <<EOF
server {
        server_name ${var.repo}; # This is just an invalid value which will never trigger on a real hostname.
        listen 80;
        access_log /var/log/nginx/access.log vhost;
        root /var/www/${var.repo};


        location /error {
                internal;
                root /host/content;
}

        location / {
      #          add_before_body /.hidden/before.txt;
      #          add_after_body /.hidden/after.txt;
      #          autoindex on;
        }


}
EOF
}

  data "template_cloudinit_config" "www_site" {
    gzip          = false
    base64_encode = false

    part {
      filename     = "output.pk"
      content_type = "text/cloud-config"
      content      = "${data.template_file.www_site.rendered}"
    }
  }


resource "docker-utils_exec" "conf" {
  container_name = "config-proxy"
  commands = ["/bin/bash","-c","echo \"${data.template_file.www_site.rendered}\" > /config/conf.d/${var.repo}.conf"]
  environment = ["REPO=${var.repo}"]
}

  resource "null_resource" "www_site" {
    triggers = {
      template = "${data.template_file.www_site.rendered}"
    }


}
