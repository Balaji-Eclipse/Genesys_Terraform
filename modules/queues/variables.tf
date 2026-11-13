# ==========================================
# modules/queues/variables.tf  (corrected)
# ==========================================

variable "queues" {
  description = "Map of queues to create/manage"
  type = map(object({
    description   = optional(string)
    division_name = string

    # Terraform-managed routing settings
    acw_wrapup_prompt       = optional(string) # "MANDATORY" | "OPTIONAL" | "MANDATORY_TIMEOUT" | "MANDATORY_FORCED_TIMEOUT"
    acw_timeout_ms          = optional(number)
    auto_answer_only        = optional(bool)

    # LAR mode
    last_agent_routing_mode = optional(string) # "Disabled" | "QueueMembersOnly" | "AnyAgent"

    scoring_method          = optional(string)
    skill_evaluation_method = optional(string) # "NONE" | "BEST" | "ALL"

    media_settings_call = object({
      alerting_timeout_sec      = number
      enable_auto_answer        = bool
      service_level_percentage  = optional(number)
      service_level_duration_ms = optional(number)
    })
  }))

  # Validation must be inside the variable block it applies to
  validation {
    condition = alltrue([
      for q in values(var.queues) :
      q.last_agent_routing_mode == null ||
      contains(["Disabled", "QueueMembersOnly", "AnyAgent"], q.last_agent_routing_mode)
    ])
    error_message = "last_agent_routing_mode must be one of: Disabled, QueueMembersOnly, AnyAgent."
  }
}

variable "division_id_map" {
  description = "Division name -> division ID map"
  type        = map(string)
}