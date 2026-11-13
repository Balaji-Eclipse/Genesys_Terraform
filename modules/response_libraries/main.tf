resource "genesyscloud_responsemanagement_library" "items" {
  for_each = var.libraries
  name     = each.key

  lifecycle {
    prevent_destroy = true
  }
}