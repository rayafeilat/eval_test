
resource "google_compute_firewall" "firewall_rules" {
  name     = "${var.environment_name}-firewall"
  for_each = var.FW_Rules
  network  = google_compute_network.vpc.self_link


  dynamic "allow" {
    for_each = each.value.allow != null ? each.value.allow : {}

    content {
      protocol = allow.protocol
      ports    = allow.ports
    }
  }
  dynamic "deny" {
    for_each = each.value.deny != null ? each.value.deny : {}

    content {
      protocol = deny.protocol
      ports    = deny.ports
    }
  }
}
