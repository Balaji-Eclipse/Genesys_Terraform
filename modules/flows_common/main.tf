resource "genesyscloud_flow" "flows" {
  for_each = var.flows

  name     = each.key
  filepath = "${var.dir_path}/${each.value.file}"

  substitutions = try(each.value.substitutions, null)

  lifecycle {
    prevent_destroy = false
  }
}