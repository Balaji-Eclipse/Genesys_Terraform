output "evaluation_form_ids" {
  value = { for n, r in genesyscloud_quality_forms_evaluation.items : n => r.id }
}