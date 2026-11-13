variable "groups" {
  description = "Map of user groups keyed by group name"
  type = map(object({
    description   = optional(string)
    # The below are structural. Keep them minimal; UI manages the rest.
    type          = optional(string) # "official" | "social" (default "official")
    visibility    = optional(string) # "public" | "owners" | "members" (default "public")
    rules_visible = optional(bool)   # default true
    roles_enabled = optional(bool)   # default true
  }))
  default = {}
}