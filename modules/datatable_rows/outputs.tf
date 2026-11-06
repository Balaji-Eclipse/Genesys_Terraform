output "row_ids" {
  description = "Map of row label -> row ID"
  value       = { for k, r in genesyscloud_architect_datatable_row.rows : k => r.id }
}