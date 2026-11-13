# Genesys Cloud CX as Code — Team-ready (modular, split tfvars)

## What this repo contains
- Terraform modules per object: division, skills, queues, schedules, schedule groups, data tables, inbound/in-queue flows.
- Config split by object in `configs/*.tfvars` for clean team ownership.
- Flow YAMLs in `flows/` (Option A folders). Flows are published only when changed using `file_content_hash` and `substitutions`.
- Azure DevOps pipeline for UAT/Prod with remote backend (Azure Storage) for state locking.

## One-time imports (UAT)
If objects already exist in UAT, import once to avoid duplicates:
```powershell
terraform import 'module.division.genesyscloud_auth_division.division' <DIVISION-ID>
terraform import 'module.skills.genesyscloud_routing_skill.skills["TF_Skill1"]' <SKILL-ID>
terraform import 'module.queues.genesyscloud_routing_queue.queues["TF_queue1"]' <QUEUE1-ID>
terraform import 'module.queues.genesyscloud_routing_queue.queues["TF_queue2"]' <QUEUE2-ID>
terraform import 'module.schedules.genesyscloud_architect_schedules.schedules["TF_Schedule1"]' <SCHEDULE-ID>
terraform import 'module.schedule_groups.genesyscloud_architect_schedulegroups.schedule_groups["TF_SG1"]' <SG-ID>
terraform import 'module.flows_inbound.genesyscloud_flow.inbound["TF_inboundcall1"]' <FLOW-ID>
terraform import 'module.flows_inqueue.genesyscloud_flow.inqueue["TF_Inqueue1"]' <FLOW-ID>
# Optional data table imports:
# terraform import 'module.datatables.genesyscloud_architect_datatable.tables["TF_DataTable1"]' <TABLE-ID>
# terraform import 'module.datatables.genesyscloud_architect_datatable_row.rows["TF_DataTable1|row1"]' <ROW-ID>