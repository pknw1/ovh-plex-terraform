module "static_site" {

  source = "./modules/site"

  # for_each = toset( ["ca.pknw1.co.uk", "pknw1.gitlab.io"] )
  for_each = toset(var.www)

 # name     = each.key
  repo = each.key
  #for_each = var.site
  #service    =  each.
  #repo       =  each.value.repo

}
