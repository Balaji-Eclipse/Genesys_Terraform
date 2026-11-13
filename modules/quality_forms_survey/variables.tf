variable "survey_forms" {
  description = "Map keyed by survey form name"
  type = map(object({
    language  = string
    disabled  = optional(bool)
    header    = optional(string)
    footer    = optional(string)
    published = optional(bool)
    question_groups = list(object({
      name       = string
      na_enabled = optional(bool)

      visibility_condition = optional(object({
        combining_operation = string
        predicates          = list(string)
      }))

      questions = list(object({
        text                    = string
        help_text               = optional(string)
        type                    = string # "npsQuestion"|"freeTextQuestion"|"multipleChoiceQuestion"|...
        na_enabled              = optional(bool)
        max_response_characters = optional(number)
        explanation_prompt      = optional(string)

        visibility_condition = optional(object({
          combining_operation = string
          predicates          = list(string)
        }))

        answer_options = optional(list(object({
          text  = string
          value = number
        })))
      }))
    }))
  }))
}