data "template_file" "site" {
  template = <<EOF
server {
        server_name ${var.server_name}
        listen 80;
        access_log /var/log/nginx/access.log vhost;
        root ${var.root};


        location /error {
                internal;
                root /host/content;
}

        location / {
                add_before_body /.hidden/before.txt;
                add_after_body /.hidden/after.txt;
                autoindex ${var.autoindex};
        }


}

EOF
}

  data "template_cloudinit_config" "site" {
    gzip          = false
    base64_encode = false

    part {
      filename     = "output.pk"
      content_type = "text/cloud-config"
      content      = "${data.template_file.site.rendered}"
    }
  }

  resource "null_resource" "site" {
    triggers = {
      template = "${data.template_file.site.rendered}"
    }
 

    provisioner "local-exec" {
      command = "echo \"${data.template_file.site.rendered}\" > ./docker-stack/${var.service}.conf"
    }

}

