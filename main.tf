module "conrt" {

  source = "./modules/container"

  for_each = var.requests
  service    =  each.key
  image_name =  each.value.image_name
  port       =  each.value.port

}
