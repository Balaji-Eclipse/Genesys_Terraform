variable "inqueue_flows" {
  description = "Map of in-queue flow configs keyed by flow name"
  type = map(object({
    file          = string
    division_name = optional(string)
    substitutions = optional(map(string))
  }))
}

variable "queue_ids" {
  description = "Optional map of queue name -> queue ID for substitutions"
  type        = map(string)
  default     = {}
}

variable "inqueue_dir_path" {
  type = string
}

variable "division_id_map" {
  type = map(string)
}