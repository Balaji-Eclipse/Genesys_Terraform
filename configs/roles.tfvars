roles = {
  "GC-Automation" = {
    description = "Role created for automation tasks using Terraform and Archy"
    permissions = []
    permission_policies = [
      {
        domain      = "oauth"
        entity_name = "client"
        action_set  = ["add", "authorize", "delete", "edit", "view"]
      },
      {
        domain      = "quality"
        entity_name = "surveyForm"
        action_set  = ["add", "delete", "disable", "edit", "search", "view"]
      },
      {
        domain      = "architect"
        entity_name = "flow"
        action_set  = ["add", "delete", "edit", "publish", "search", "unlock", "view"]
      },
      {
        domain      = "architect"
        entity_name = "datatable"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "architect"
        entity_name = "flowMilestone"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "quality"
        entity_name = "evaluationForm"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "responses"
        entity_name = "library"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "responses"
        entity_name = "response"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "routing"
        entity_name = "emergencyGroup"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "routing"
        entity_name = "queue"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "routing"
        entity_name = "scheduleGroup"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "routing"
        entity_name = "wrapupCode"
        action_set  = ["add", "delete", "edit", "search", "view"]
      },
      {
        domain      = "architect"
        entity_name = "userPrompt"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "authorization"
        entity_name = "division"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "authorization"
        entity_name = "role"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "directory"
        entity_name = "group"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "integrations"
        entity_name = "action"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "integrations"
        entity_name = "embeddableFramework"
        action_set  = ["upload"]
      },
      {
        domain      = "languageUnderstanding"
        entity_name = "draft"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "languageUnderstanding"
        entity_name = "nluDomain"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "languageUnderstanding"
        entity_name = "nluDomainVersion"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "processautomation"
        entity_name = "trigger"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "responseAssets"
        entity_name = "asset"
        action_set  = ["add", "delete", "edit", "view"]
      },
      {
        domain      = "architect"
        entity_name = "flowOutcome"
        action_set  = ["add", "edit", "search", "view"]
      },
      {
        domain      = "routing"
        entity_name = "skill"
        action_set  = ["create", "delete", "manage", "update", "view"]
      },
      {
        domain      = "architect"
        entity_name = "job"
        action_set  = ["create", "view"]
      },
      {
        domain      = "conversation"
        entity_name = "externalTag"
        action_set  = ["edit"]
      },
      {
        domain      = "integrations"
        entity_name = "integration"
        action_set  = ["edit"]
      },
      {
        domain      = "scripter"
        entity_name = "publishedScript"
        action_set  = ["search", "view"]
      },
      {
        domain      = "scripter"
        entity_name = "script"
        action_set  = ["search", "view"]
      },
      {
        domain      = "agentUI"
        entity_name = "conversationSummary"
        action_set  = ["view"]
      },
      {
        domain      = "analytics"
        entity_name = "agentConversationDetail"
        action_set  = ["view"]
      },
      {
        domain      = "analytics"
        entity_name = "conversationDetail"
        action_set  = ["view"]
      },
      {
        domain      = "analytics"
        entity_name = "interactionSurveyDetails"
        action_set  = ["view"]
      },
      {
        domain      = "analytics"
        entity_name = "surveyAggregate"
        action_set  = ["view"]
      },
      {
        domain      = "architect"
        entity_name = "dependencyTracking"
        action_set  = ["view"]
      },
      {
        domain      = "architect"
        entity_name = "systemPrompt"
        action_set  = ["view"]
      },
      {
        domain      = "architect"
        entity_name = "ui"
        action_set  = ["view"]
      },
      {
        domain      = "conversation"
        entity_name = "communication"
        action_set  = ["view"]
      },
      {
        domain      = "conversation"
        entity_name = "customAttributes"
        action_set  = ["view"]
      },
      {
        domain      = "quality"
        entity_name = "survey"
        action_set  = ["view"]
      }
    ]
  }
}