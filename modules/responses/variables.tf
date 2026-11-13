variable "responses" {
  description = "Map of responses keyed by response name"
  type = map(object({
    library_names = set(string) # map to IDs via library_id_map
    texts = list(object({
      content      = string
      content_type = string # "text/plain" | "text/html"
    }))
    # Optional extras; add as needed later
    response_type = optional(string)       # e.g., "MessagingTemplate"|"CampaignSmsTemplate"|"Footer"
    asset_names   = optional(list(string)) # if you want to link assets by name (optional)
  }))
}

variable "library_id_map" {
  description = "Library name -> id"
  type        = map(string)
}

variable "asset_id_map" {
  description = "Asset name -> id"
  type        = map(string)
  default     = {}
}