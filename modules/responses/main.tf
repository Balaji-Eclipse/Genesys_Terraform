resource "genesyscloud_responsemanagement_response" "items" {
  for_each = var.responses

  name        = each.key
  library_ids = [for ln in each.value.library_names : var.library_id_map[ln]]

  dynamic "texts" {
    for_each = each.value.texts
    content {
      content      = texts.value.content
      content_type = texts.value.content_type
    }
  }

  # Optional: attach assets by name if provided
  asset_ids = try([for an in each.value.asset_names : var.asset_id_map[an]], null)

  # Optional: response_type passthrough
  response_type = try(each.value.response_type, null)

  lifecycle { prevent_destroy = true }
}