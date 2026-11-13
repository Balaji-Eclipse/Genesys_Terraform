output "role_ids" {
  value = { for name, r in genesyscloud_auth_role.items : name => r.id }
}