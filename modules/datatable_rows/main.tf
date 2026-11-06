locals {
  normalized_rows = {
    for row_key, row in var.rows :
    row_key => {
      datatable_name = row.datatable_name
      key_value      = row.key_value
      values = {
        for col, raw in row.values :
        col => (
          # TRUE normalization
          (
            try(lower(tostring(raw)), "") == "true" ||
            raw == 1 ||
            raw == "1"
          ) ? true :

          # FALSE normalization
          (
            try(lower(tostring(raw)), "") == "false" ||
            raw == 0 ||
            raw == "0"
          ) ? false :

          # Otherwise keep original
          raw
        )
      }
    }
  }
}

resource "genesyscloud_architect_datatable_row" "rows" {
  for_each = local.normalized_rows   # <-- CRITICAL FIX

  datatable_id    = var.datatable_id_map[each.value.datatable_name]
  key_value       = each.value.key_value
  properties_json = jsonencode(each.value.values)

  lifecycle {
    prevent_destroy = false
  }
}