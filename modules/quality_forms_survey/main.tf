resource "genesyscloud_quality_forms_survey" "items" {
  for_each = {
    for name, form in var.survey_forms :
    name => form
    if length(try(form.question_groups, [])) > 0
  }

  name      = each.key
  language  = each.value.language
  disabled  = try(each.value.disabled, null)
  header    = try(each.value.header, null)
  footer    = try(each.value.footer, null)
  published = try(each.value.published, null)

  # -- Question Groups (must have at least one per resource) --
  dynamic "question_groups" {
    for_each = each.value.question_groups
    content {
      name       = question_groups.value.name
      na_enabled = try(question_groups.value.na_enabled, null)

      dynamic "visibility_condition" {
        for_each = (
          try(question_groups.value.visibility_condition, null) == null
        ) ? [] : [question_groups.value.visibility_condition]
        content {
          combining_operation = visibility_condition.value.combining_operation
          predicates          = visibility_condition.value.predicates
        }
      }

      # -- Questions within the group --
      dynamic "questions" {
        for_each = question_groups.value.questions
        content {
          text                    = questions.value.text
          help_text               = try(questions.value.help_text, null)
          type                    = questions.value.type
          na_enabled              = try(questions.value.na_enabled, null)
          max_response_characters = try(questions.value.max_response_characters, null)
          explanation_prompt      = try(questions.value.explanation_prompt, null)

          dynamic "visibility_condition" {
            for_each = (
              try(questions.value.visibility_condition, null) == null
            ) ? [] : [questions.value.visibility_condition]
            content {
              combining_operation = visibility_condition.value.combining_operation
              predicates          = visibility_condition.value.predicates
            }
          }

          dynamic "answer_options" {
            for_each = try(questions.value.answer_options, [])
            content {
              text  = answer_options.value.text
              value = answer_options.value.value
            }
          }
        }
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}