# triggers = {
#   "TF-On-ConversationEnd" = {
#     topic_name        = "v2.detail.events.conversation.{id}.customer.end"
#     enabled           = true
#     event_ttl_seconds = 60
#
#     target = {
#       workflow_name            = "Outbound_Department_Filter"   # exact Architect workflow name
#       type                     = "Workflow"
#       workflow_target_settings = { data_format = "TopLevelPrimitives" }
#     }
#
#     match_rules = [
#       { jsonPath = "mediaType", operator = "Equal", value = "CHAT" }
#     ]
#   }
# }