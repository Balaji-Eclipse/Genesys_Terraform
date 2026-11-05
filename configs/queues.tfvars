#queues = {
# "TF_queue1" = {
#   description   = "Queue new role"
#   division_name = "Terraform"
#
#   # Terraform-owned routing config
#   acw_wrapup_prompt          = "MANDATORY_TIMEOUT"
#   acw_timeout_ms             = 20000
#   auto_answer_only           = false
#   last_agent_routing_mode    = "AnyAgent"            # ensure value matches provider enum
#   scoring_method             = "TimestampAndPriority"
#   skill_evaluation_method    = "BEST"
#
#   media_settings_call = {
#     alerting_timeout_sec      = 25
#     enable_auto_answer        = false
#     service_level_percentage  = 0.7
#     service_level_duration_ms = 20000
#   }
# }
#}
