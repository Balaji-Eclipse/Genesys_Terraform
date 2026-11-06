output "flow_ids" {
  description = "Map of flow name -> flow ID"
  value       = { for k, v in genesyscloud_flow.flows : k => v.id }
}