variable "evaluation_forms" {
  description = "Map keyed by evaluation form name"
  type = map(object({
    published = optional(bool)
    question_groups = list(object({
      name                       = string
      default_answers_to_highest = optional(bool)
      default_answers_to_na      = optional(bool)
      na_enabled                 = optional(bool)
      weight                     = optional(number)
      manual_weight              = optional(bool)

      visibility_condition = optional(object({
        combining_operation = string
        predicates          = list(string)
      }))

      questions = list(object({
        text              = string
        help_text         = optional(string)
        na_enabled        = optional(bool)
        comments_required = optional(bool)
        is_kill           = optional(bool)
        is_critical       = optional(bool)

        answer_options = optional(list(object({
          text  = string
          value = number
        })))

        visibility_condition = optional(object({
          combining_operation = string
          predicates          = list(string)
        }))
      }))
    }))
  }))
}