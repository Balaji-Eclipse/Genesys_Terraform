resource "genesyscloud_flow" "inbound" {
  for_each = var.inbound_flows

  name = each.key

  filepath = "${var.inbound_dir_path}/${each.value.file}"

  substitutions = try(each.value.substitutions, null)

  lifecycle {
    prevent_destroy = false
  }
}