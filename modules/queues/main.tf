# ==========================================
# modules/queues/main.tf
# ==========================================

locals {
  # Pass-through object; kept for future computed merges if needed
  effective_queues = {
    for qname, qvalue in var.queues :
    qname => qvalue
  }
}

resource "genesyscloud_routing_queue" "queues" {
  for_each = local.effective_queues

  # Identity
  name        = each.key
  division_id = var.division_id_map[each.value.division_name]
  description = try(each.value.description, null)

  # Terraform-managed routing behavior
  acw_wrapup_prompt       = try(each.value.acw_wrapup_prompt, null)
  acw_timeout_ms          = try(each.value.acw_timeout_ms, null)
  auto_answer_only        = try(each.value.auto_answer_only, null)
  last_agent_routing_mode = try(each.value.last_agent_routing_mode, null)
  scoring_method          = try(each.value.scoring_method, null)
  skill_evaluation_method = try(each.value.skill_evaluation_method, null)

  # Terraform-managed Call media settings
  media_settings_call {
    alerting_timeout_sec      = each.value.media_settings_call.alerting_timeout_sec
    enable_auto_answer        = each.value.media_settings_call.enable_auto_answer
    service_level_percentage  = try(each.value.media_settings_call.service_level_percentage, 0.8)
    service_level_duration_ms = try(each.value.media_settings_call.service_level_duration_ms, 20000)
  }

  # Preserve UI-managed members (agents)
  # Available in provider 1.64+ and present in your 1.69.3.
  ignore_members = true # do not manage queue members from Terraform

  lifecycle {
    prevent_destroy = false

    # Preserve UI-managed tabs & associations - Terraform won't overwrite them
    ignore_changes = [
      # Channel tabs managed in UI
      media_settings_email,
      media_settings_chat,
      media_settings_message,
      media_settings_callback,

      # Associations managed in UI
      groups,
      teams,
      skill_groups,

      # If you decide UI should own wrap-up codes, uncomment below:
      # wrapup_codes,

      # If UI manages these too, keep ignored:
      # outbound_email_address,
      # conditional_group_activation,
      # conditional_group_routing_rules,
    ]
  }
}