variable "divisions" {
  description = "Map of divisions keyed by name"
  type = map(object({
    description = optional(string)
  }))
  default = {}
}