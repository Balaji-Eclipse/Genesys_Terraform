output "emergency_group_ids" {
  description = "Map of Emergency Group name -> ID"
  value = { for name, r in genesyscloud_architect_emergencygroup.items : name => r.id }
}