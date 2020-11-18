locals {
  ip_address = google_compute_instance.virtual_machine.network_interface[0].access_config[0].nat_ip
}

output "informations" {
  value = {
    http   = "http://${local.ip_address}/"
    https  = "https://${local.ip_address}/"
    ip     = local.ip_address,
    prefix = var.prefix
    ssh    = "ssh -i ./ssh/key root@${local.ip_address}"
  }
}
