variable "rows" {
  description = "Map of rows keyed by logical label"
  type = map(object({
    datatable_name = string
    key_value      = string
    values         = map(any)
  }))
}

variable "datatable_id_map" {
  description = "Map of table name -> table ID (from tables module)"
  type        = map(string)
}