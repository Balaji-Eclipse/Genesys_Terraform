output "library_ids" {
  description = "Map: library name -> id"
  value       = { for n, r in genesyscloud_responsemanagement_library.items : n => r.id }
}