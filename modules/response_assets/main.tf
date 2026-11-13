resource "genesyscloud_responsemanagement_responseasset" "items" {
  for_each = var.assets

  filename    = each.value.filename
  division_id = try(var.division_id_map[try(each.value.division_name, "")], null)

  # IMPORTANT: compute hash IN CODE (functions are NOT evaluated in .tfvars)
  file_content_hash = try(each.value.file_content_hash, filesha256(each.value.filename))

  lifecycle {
    prevent_destroy = true
  }
}