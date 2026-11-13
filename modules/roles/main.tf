resource "genesyscloud_auth_role" "items" {
  for_each    = var.roles
  name        = each.key
  description = try(each.value.description, null)
  permissions = try(each.value.permissions, null)

  dynamic "permission_policies" {
    for_each = try(each.value.permission_policies, [])
    content {
      domain      = permission_policies.value.domain
      entity_name = permission_policies.value.entity_name
      action_set  = permission_policies.value.action_set

      # Render conditions only when present AND has at least one terms entry
      dynamic "conditions" {
        for_each = (
          permission_policies.value.conditions != null
          && length(try(permission_policies.value.conditions.terms, [])) > 0
        ) ? [permission_policies.value.conditions] : []

        content {
          conjunction = conditions.value.conjunction

          dynamic "terms" {
            for_each = conditions.value.terms
            content {
              variable_name = terms.value.variable_name
              operator      = terms.value.operator

              dynamic "operands" {
                for_each = terms.value.operands
                content {
                  type     = operands.value.type
                  queue_id = try(operands.value.queue_id, null)
                  user_id  = try(operands.value.user_id, null)
                  value    = try(operands.value.value, null)
                }
              }
            }
          }
        }
      }
    }
  }

  lifecycle { prevent_destroy = true }
}