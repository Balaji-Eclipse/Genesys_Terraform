output "group_roles_counts" {
  description = "Number of role bindings managed per group"
  value       = { for gname, r in genesyscloud_group_roles.items : gname => length(r.roles) }
}