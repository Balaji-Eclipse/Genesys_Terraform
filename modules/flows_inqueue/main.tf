resource "genesyscloud_flow" "inqueue" {
  for_each = var.inqueue_flows

  name = each.key

  filepath = "${var.inqueue_dir_path}/${each.value.file}"

  substitutions = try(each.value.substitutions, null)

  lifecycle {
    prevent_destroy = true
  }
}