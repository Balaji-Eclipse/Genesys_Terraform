output "survey_form_ids" {
  value = { for n, r in genesyscloud_quality_forms_survey.items : n => r.id }
}