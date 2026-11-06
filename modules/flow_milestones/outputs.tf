output "flow_milestone_ids" {
  description = "Map of flow milestone name -> ID"
  value = {
    for name, r in genesyscloud_flow_milestone.items :
    name => r.id
  }
}