resource "genesyscloud_group" "items" {
  for_each = var.groups

  name          = each.key
  description   = try(each.value.description, null)
  type          = try(each.value.type, "official")
  visibility    = try(each.value.visibility, "public")
  rules_visible = try(each.value.rules_visible, true)
  roles_enabled = try(each.value.roles_enabled, true)

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [
      member_ids,     # UI-managed membership
      owner_ids,      # UI-managed owners
      addresses,      # UI-managed group phone/extension
      calls_enabled,  # UI toggle
      include_owners, # UI toggle
    ]
  }
}