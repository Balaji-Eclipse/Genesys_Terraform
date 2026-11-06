variable "flow_outcomes" {
  description = "Map of Flow Outcomes keyed by name"
  type = map(object({
    name          = optional(string)
    description   = optional(string)
    division_name = optional(string) # will be resolved to division_id via division_id_map
  }))
}

variable "division_id_map" {
  description = "Division name -> ID map"
  type        = map(string)
}