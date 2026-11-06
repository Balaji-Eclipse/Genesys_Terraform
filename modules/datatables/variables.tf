variable "datatables" {
  description = "Map of Architect Data Tables keyed by name"
  type = map(object({
    description   = optional(string)
    division_name = optional(string)
    properties    = list(object({
      name    = string
      type    = string
      title   = optional(string)
      default = optional(string)
    }))
  }))
}

variable "division_id_map" {
  description = "Division name -> ID map"
  type        = map(string)
}