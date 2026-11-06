variable "emergency_groups" {
  description = "Map of Emergency Groups keyed by group name"
  type = map(object({
    description   = optional(string)
    division_name = optional(string)
    # NOTE: Membership (flows/IVRs) and enable/disable are UI-managed; not set here.
  }))
  default = {}
}

variable "division_id_map" {
  description = "Division name -> ID map"
  type        = map(string)
}