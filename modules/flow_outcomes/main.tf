resource "genesyscloud_flow_outcome" "items" {
  for_each = var.flow_outcomes

  name        = coalesce(try(each.value.name, null), each.key)
  description = try(each.value.description, null)

  # Omit if no division_name provided => provider uses Home division
  division_id = try(var.division_id_map[try(each.value.division_name, "")], null)

  lifecycle {
    # Safer default for shared objects; flip only when you truly want to delete
    prevent_destroy = true
  }
}