output "flow_ids" {
  description = "Map of inbound flow name -> flow ID"
  value       = { for k, v in genesyscloud_flow.inbound : k => v.id }
}