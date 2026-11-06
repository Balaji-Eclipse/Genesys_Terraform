variable "inbound_flows" {
  description = "Map of inbound flow configs keyed by flow name"
  type = map(object({
    file          = string
    division_name = optional(string)
    substitutions = optional(map(string))
  }))
}

# Make queue_ids optional so module doesn't fail when not passed
variable "queue_ids" {
  description = "Optional map of queue name -> queue ID for substitutions"
  type        = map(string)
  default     = {}
}

variable "inbound_dir_path" {
  type = string
}

variable "division_id_map" {
  type = map(string)
}