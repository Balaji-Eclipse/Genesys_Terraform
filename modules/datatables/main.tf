resource "genesyscloud_architect_datatable" "tables" {
  for_each = var.datatables

  name        = each.key
  description = try(each.value.description, null)

  # Omit if no division_name provided => provider uses Home division
  division_id = try(var.division_id_map[try(each.value.division_name, "")], null)

  dynamic "properties" {
    for_each = each.value.properties
    content {
      name    = properties.value.name
      type    = properties.value.type
      title   = try(properties.value.title, null)
      default = try(properties.value.default, null)
    }
  }

  lifecycle {
    prevent_destroy = true

    # Imported/existing Architect data tables may contain extra fields not present in tfvars.
    # Ignoring schema diffs prevents API update failures when provider submits an incomplete schema.
    ignore_changes = [
      properties
    ]
  }
}