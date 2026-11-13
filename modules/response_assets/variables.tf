variable "assets" {
  description = "Map of response assets keyed by an asset key"
  type = map(object({
    filename          = string
    division_name     = optional(string)
    # Optional: if you want to pin a specific known hash; otherwise we'll compute it
    file_content_hash = optional(string)
  }))
}

variable "division_id_map" {
  description = "Division name -> ID map"
  type        = map(string)
}