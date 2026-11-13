resource "genesyscloud_quality_forms_evaluation" "items" {
  for_each = {
    for name, form in var.evaluation_forms :
    name => form
    if length(try(form.question_groups, [])) > 0
  }

  name      = each.key
  published = try(each.value.published, null)

  # -- Question Groups (must have at least one per resource) --
  dynamic "question_groups" {
    for_each = each.value.question_groups
    content {
      name                       = question_groups.value.name
      default_answers_to_highest = try(question_groups.value.default_answers_to_highest, null)
      default_answers_to_na      = try(question_groups.value.default_answers_to_na, null)
      na_enabled                 = try(question_groups.value.na_enabled, null)
      weight                     = try(question_groups.value.weight, null)
      manual_weight              = try(question_groups.value.manual_weight, null)

      # Only render visibility_condition if provided
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
          text              = questions.value.text
          help_text         = try(questions.value.help_text, null)
          na_enabled        = try(questions.value.na_enabled, null)
          comments_required = try(questions.value.comments_required, null)
          is_kill           = try(questions.value.is_kill, null)
          is_critical       = try(questions.value.is_critical, null)

          dynamic "answer_options" {
            for_each = try(questions.value.answer_options, [])
            content {
              text  = answer_options.value.text
              value = answer_options.value.value
            }
          }

          dynamic "visibility_condition" {
            for_each = (
              try(questions.value.visibility_condition, null) == null
            ) ? [] : [questions.value.visibility_condition]
            content {
              combining_operation = visibility_condition.value.combining_operation
              predicates          = visibility_condition.value.predicates
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