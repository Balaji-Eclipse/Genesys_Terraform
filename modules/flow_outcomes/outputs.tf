output "flow_outcome_ids" {
  description = "Map of flow outcome name -> ID"
  value = {
    for name, r in genesyscloud_flow_outcome.items :
    name => r.id
  }
}