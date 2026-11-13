variable "libraries" {
  description = "Map of Response Libraries keyed by name"
  type = map(object({
    # Only 'name' is required by the resource; we key by name
    # keeping object in case you extend later (e.g., description)
    description = optional(string)
  }))
}