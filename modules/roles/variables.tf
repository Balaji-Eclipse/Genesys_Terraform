variable "roles" {
  description = "Map keyed by role name"
  type = map(object({
    description = optional(string)
    permissions = optional(set(string))
    permission_policies = optional(list(object({
      domain      = string
      entity_name = string
      action_set  = set(string) # e.g., ["add","edit"] or ["*"]
      conditions = optional(object({
        conjunction = string # "AND" | "OR"
        terms = set(object({
          variable_name = string # e.g., "Conversation.queues"
          operator      = string # "EQ" | "IN" | ...
          operands = set(object({
            type     = string # "QUEUE" | "USER" | "SCALAR" | "VARIABLE"
            queue_id = optional(string)
            user_id  = optional(string)
            value    = optional(string)
          }))
        }))
      }))
    })))
  }))
}