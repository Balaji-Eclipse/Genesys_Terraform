output "oauth_client_ids" {
  value = { for n, r in genesyscloud_oauth_client.items : n => r.id }
}