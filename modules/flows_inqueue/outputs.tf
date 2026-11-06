output "flow_ids" {
  description = "Map of in-queue flow name -> flow ID"
  value       = { for k, v in genesyscloud_flow.inqueue : k => v.id }
}