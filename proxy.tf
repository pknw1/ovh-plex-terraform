module "proxy" {

  source = "./modules/container-proxy"

  for_each = var.proxy
  service    =  each.key
  image_name =  each.value.image_name
  port       =  each.value.port

}
