variable "oauth_clients" {
  description = "Map keyed by OAuth client name"
  type = map(object({
    description                   = optional(string)
    authorized_grant_type         = string # "CODE"|"TOKEN"|"SAML2-BEARER"|"PASSWORD"|"CLIENT-CREDENTIALS"
    scopes                        = optional(set(string))
    registered_redirect_uris      = optional(set(string))
    state                         = optional(string) # "active"|"inactive"
    access_token_validity_seconds = optional(number)
    expose_client_secret          = optional(bool, false)

    # Optional: assign roles when grant = CLIENT-CREDENTIALS
    roles = optional(list(object({
      role_name     = string
      division_name = optional(string)
    })))
  }))
}

variable "role_id_map" {
  description = "Role name -> id (from roles module)"
  type        = map(string)
  default     = {}
}

variable "division_id_map" {
  description = "Division name -> id"
  type        = map(string)
  default     = {}
}