variable "flow_milestones" {
  description = "Map of Flow Milestones keyed by name"
  type = map(object({
    description   = optional(string)
    division_name = optional(string)
  }))
}

variable "division_id_map" {
  description = "Division name -> ID map"
  type        = map(string)
}