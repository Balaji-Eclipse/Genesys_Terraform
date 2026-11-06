output "action_ids" {
  description = "Map of Data Action name -> ID (published or draft)."
  value = merge(
    { for k, r in genesyscloud_integration_action.published : k => r.id },
    { for k, r in genesyscloud_integration_action.draft     : k => r.id }
  )
}