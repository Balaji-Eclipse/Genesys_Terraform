resource "genesyscloud_architect_emergencygroup" "items" {
  for_each = var.emergency_groups

  name        = each.key
  description = try(each.value.description, null)
  division_id = try(var.division_id_map[try(each.value.division_name, "")], null)

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      enabled,              # UI toggles on/off
      emergency_call_flows, # UI manages flow/IVR links
    ]
  }
}