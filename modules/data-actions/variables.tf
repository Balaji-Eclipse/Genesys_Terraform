variable "data_actions_files" {
  description = <<EOT
Map keyed by Data Action NAME -> object with only the UI export file path.
Example:
{
  "Update_wrapupcode TF" = { export_json_path = "data-actions/GenesysCloudDataAction/Updatewrapupcode-TFImport.custom.json" }
}
EOT
  type = map(object({
    export_json_path = string
  }))
}

variable "integration_name_by_type" {
  description = <<EOT
Map integrationType -> Integration NAME in your Org (UI-managed).
Common keys:
  purecloud-data-actions   -> "Genesys Cloud Data Actions"
  custom-rest-actions      -> "<your REST integration name>"
  function-data-actions    -> "<your Function Data Actions integration name>"
EOT
  type = map(string)
}

variable "default_publish_mode" {
  description = "Default publication mode for all actions: published | draft"
  type        = string
  default     = "published"
}