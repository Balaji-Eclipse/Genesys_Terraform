output "asset_ids" {
  description = "Map of asset key -> asset ID"
  value       = { for k, r in genesyscloud_responsemanagement_responseasset.items : k => r.id }
}