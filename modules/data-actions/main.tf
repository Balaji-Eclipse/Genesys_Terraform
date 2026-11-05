# Load all exports up-front
locals {
  exports = {
    for name, cfg in var.data_actions_files :
    name => jsondecode(file(cfg.export_json_path))
  }

  # infer publish_mode per action from export if present (not typical), else default
  publish_mode = {
    for name, o in local.exports :
    name => var.default_publish_mode
  }

  # integrationType from export (e.g., "purecloud-data-actions", "custom-rest-actions", "function-data-actions")
  integration_type = {
    for name, o in local.exports :
    name => try(o.integrationType, null)
  }

  # Map integrationType -> category string expected by provider
  # Provider examples & docs use strings like "Genesys Cloud Data Action" (and others for custom REST).
  # We derive category automatically so tfvars don't need to specify it.
  provider_category = {
    for name, t in local.integration_type :
    name => (
      t == "purecloud-data-actions" ? "Genesys Cloud Data Action" :
      t == "custom-rest-actions"    ? "Custom Web Services Data Actions" :
      t == "function-data-actions"  ? "Function Data Actions" :
      "Genesys Cloud Data Action"
    )
  }

  # Contracts / Request / Response pulled straight from export JSON
  contract_input  = { for n, o in local.exports : n => jsonencode(try(o.contract.input.inputSchema, {"type":"object"})) }
  contract_output = { for n, o in local.exports : n => jsonencode(try(o.contract.output.successSchema, {"type":"object"})) }

  request_url_template = { for n, o in local.exports : n => try(o.config.request.requestUrlTemplate, "") }
  request_type         = { for n, o in local.exports : n => try(o.config.request.requestType, "GET") }
  request_template     = { for n, o in local.exports : n => try(o.config.request.requestTemplate, "") }
  headers              = { for n, o in local.exports : n => try(o.config.request.headers, {}) }

  translation_map      = { for n, o in local.exports : n => try(o.config.response.translationMap, {}) }
  translation_defaults = { for n, o in local.exports : n => try(o.config.response.translationMapDefaults, {}) }
  success_template     = { for n, o in local.exports : n => try(o.config.response.successTemplate, "$${rawResult}") }
}

# Resolve Integration NAME to ID by integrationType -> integration_name_by_type -> data source
locals {
  integration_names = toset(compact([
    for name, t in local.integration_type :
    try(var.integration_name_by_type[t], null)
  ]))
}

data "genesyscloud_integration" "by_name" {
  for_each = { for n in local.integration_names : n => n }
  name     = each.key
}

locals {
  integration_id = {
    for name, t in local.integration_type :
    name => (
      contains(keys(var.integration_name_by_type), t)
      ? data.genesyscloud_integration.by_name[var.integration_name_by_type[t]].id
      : null
    )
  }
}

# ---- PUBLISHED actions ----
resource "genesyscloud_integration_action" "published" {
  for_each = {
    for name, mode in local.publish_mode : name => mode
    if lower(mode) == "published"
  }

  name           = each.key
  category       = local.provider_category[each.key]
  integration_id = local.integration_id[each.key]

  contract_input  = local.contract_input[each.key]
  contract_output = local.contract_output[each.key]

  config_request {
    request_url_template = local.request_url_template[each.key]
    request_type         = local.request_type[each.key]
    request_template     = local.request_template[each.key]
    headers              = local.headers[each.key]
  }

  config_response {
    translation_map          = local.translation_map[each.key]
    translation_map_defaults = local.translation_defaults[each.key]
    success_template         = local.success_template[each.key]
  }

  lifecycle { prevent_destroy = true }
}

# ---- DRAFT actions ----
resource "genesyscloud_integration_action" "draft" {
  for_each = {
    for name, mode in local.publish_mode : name => mode
    if lower(mode) == "draft"
  }

  name           = each.key
  category       = local.provider_category[each.key]
  integration_id = local.integration_id[each.key]

  contract_input  = local.contract_input[each.key]
  contract_output = local.contract_output[each.key]

  config_request {
    request_url_template = local.request_url_template[each.key]
    request_type         = local.request_type[each.key]
    request_template     = local.request_template[each.key]
    headers              = local.headers[each.key]
  }

  config_response {
    translation_map          = local.translation_map[each.key]
    translation_map_defaults = local.translation_defaults[each.key]
    success_template         = local.success_template[each.key]
  }

  lifecycle { prevent_destroy = true }
}