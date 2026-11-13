resource "genesyscloud_group_roles" "items" {
  # Create one resource per group that has role bindings
  for_each = var.group_role_assignments

  # Target the group by ID (changing group_id forces replace per provider docs)
  group_id = var.group_id_map[each.key]

  # One roles block per binding
  dynamic "roles" {
    for_each = each.value
    content {
      role_id = var.role_id_map[roles.value.role_name]

      # Optional divisions:
      # - if omitted -> null (provider treats as home division)
      # - if "*" -> all divisions
      # - else map division names to IDs
      division_ids = (
        try(roles.value.division_names, null) == null
        ? null
        : (
          contains(roles.value.division_names, "*")
          ? ["*"]
          : [for dn in roles.value.division_names : var.division_id_map[dn]]
        )
      )
    }
  }
}