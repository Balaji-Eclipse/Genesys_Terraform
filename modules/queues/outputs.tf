# ==========================================
# modules/queues/outputs.tf
# ==========================================
output "queue_ids" {
  description = "Map of queue name -> queue ID"
  value = {
    for name, r in genesyscloud_routing_queue.queues :
    name => r.id
  }
}