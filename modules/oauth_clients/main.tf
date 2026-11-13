resource "genesyscloud_oauth_client" "items" {
  for_each = var.oauth_clients

  name                          = each.key
  description                   = try(each.value.description, null)
  authorized_grant_type         = each.value.authorized_grant_type
  scopes                        = try(each.value.scopes, null)
  registered_redirect_uris      = try(each.value.registered_redirect_uris, null)
  state                         = try(each.value.state, null)
  access_token_validity_seconds = try(each.value.access_token_validity_seconds, null)
  expose_client_secret          = try(each.value.expose_client_secret, false)

  dynamic "roles" {
    for_each = try(each.value.roles, [])
    content {
      role_id     = var.role_id_map[roles.value.role_name]
      division_id = try(var.division_id_map[try(roles.value.division_name, "")], null)
    }
  }

  lifecycle { prevent_destroy = true }
}