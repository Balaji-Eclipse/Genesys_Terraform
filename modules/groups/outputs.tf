output "group_ids" {
  description = "Map of group name -> group ID"
  value = { for name, r in genesyscloud_group.items : name => r.id }
}