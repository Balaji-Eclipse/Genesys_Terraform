variable "group_role_assignments" {
  description = <<EOT
Map keyed by group name. Each value = list of role bindings:
[
  { role_name = "Supervisor", division_names = ["*"] },            # "*" = all divisions
  { role_name = "Quality Administrator", division_names = ["Default"] }
]
EOT
  type = map(list(object({
    role_name      = string
    division_names = optional(list(string))  # allow "*"
  })))
  default = {}
}

variable "group_id_map" {
  description = "Group name -> ID (from groups module)"
  type        = map(string)
}

variable "role_id_map" {
  description = "Role name -> ID (from roles module / data sources)"
  type        = map(string)
}

variable "division_id_map" {
  description = "Division name -> ID map"
  type        = map(string)
}