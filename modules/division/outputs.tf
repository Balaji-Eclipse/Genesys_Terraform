output "division_id_map" {
  description = "Division name -> ID map"
  value       = local.division_id_map
}

output "division_ids" {
  description = "Map of division name -> ID"
  value       = { for k, r in genesyscloud_auth_division.divisions : k => r.id }
}