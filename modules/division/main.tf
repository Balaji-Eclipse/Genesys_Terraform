##################################################
# Divisions (Root-level) - Hardened
##################################################

resource "genesyscloud_auth_division" "divisions" {
  for_each = var.divisions

  name        = each.key
  description = try(each.value.description, null)

  # UAT safety: never allow deletion via Terraform
  lifecycle {
    prevent_destroy = true
  }
}

locals {
  # Name -> ID mapping for downstream modules
  division_id_map = {
    for name, r in genesyscloud_auth_division.divisions :
    name => r.id
  }
}