resource "genesyscloud_flow_milestone" "items" {
  for_each = var.flow_milestones

  name        = each.key
  description = try(each.value.description, null)

  # Omit if no division_name provided => provider uses Home division
  division_id = try(var.division_id_map[try(each.value.division_name, "")], null)
  lifecycle {
    prevent_destroy = true
  }
}