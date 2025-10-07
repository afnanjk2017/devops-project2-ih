output "agw_ips" {
  value = module.appgw.agw_ip
}

output "websites_fqdns" {
  value = [module.appservice.fe_app_fqdn, module.appservice.be_app_fqdn]
}
