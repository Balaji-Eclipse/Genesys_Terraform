output "response_ids" {
  value = { for n, r in genesyscloud_responsemanagement_response.items : n => r.id }
}