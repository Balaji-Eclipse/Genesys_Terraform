variable "flows" {
  description = "Map of flow configs keyed by flow name"
  type = map(object({
    file          = string
    division_name = optional(string)
    substitutions = optional(map(string))
  }))
}

variable "dir_path" {
  description = "Relative path to the folder containing the YAML files for this flow type"
  type        = string
}

variable "division_id_map" {
  description = "Name -> division ID map from root"
  type        = map(string)
  default     = {}
}

# Keep this to match the pattern you've already established
variable "queue_ids" {
  description = "Optional map of queue name -> queue ID for substitutions"
  type        = map(string)
  default     = {}
}