output "datatable_ids" {
  description = "Map of table name -> ID"
  value = {
    for name, r in genesyscloud_architect_datatable.tables :
    name => r.id
  }
}