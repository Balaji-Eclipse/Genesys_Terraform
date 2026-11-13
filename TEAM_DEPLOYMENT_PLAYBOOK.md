# Team Deployment Playbook (Updated)

This is the current recommended operating model for this repository.

## 1. Core Principles

1. One multistage pipeline handles both UAT and PROD.
2. UAT and PROD have separate Terraform state workspaces.
3. Import is onboarding-only and runs from environment baseline branches.
4. Deploy runs from release branches.
5. DEV is used for UI changes and export/source capture, not Terraform-managed state.
6. Terraform state is managed only in Terraform Cloud workspaces.

---

## 2. Branch Model

Long-lived branches:
1. main: production history branch.
2. env/uat: baseline branch representing current UAT-managed-as-is during onboarding/import.
3. env/prod: baseline branch representing current PROD-managed-as-is during onboarding/import.

Working branches:
1. feature/request-X: developer change branch.
2. release/request-X: promotion branch for UAT and PROD deployment of that request.

Notes:
1. develop is not required in this model.
2. If your team keeps develop, treat it as optional integration only, not a deployment branch.
3. Recommended release branch creation: create `release/request-X` from `main`, then merge `feature/request-X` into it by PR.
4. Avoid creating `release/request-X` directly from `feature/request-X` if your process requires a PR into release, because source and target will be identical and Azure DevOps will show no diff.

---

## 3. Pipeline Branch Rules (Current)

Based on current conditions in the pipeline:

1. Import_UAT: allowed only from env/uat.
2. Deploy_UAT: allowed only from release/*.
3. Import_Prod: allowed only from env/prod.
4. Deploy_Prod: allowed only from release/*.

State baseline behavior:
1. UAT state is stored in the Terraform Cloud UAT workspace.
2. PROD state is stored in the Terraform Cloud PROD workspace.
3. env/uat and env/prod still define import baselines in Git, but state is not restored from branch artifacts.

This supports safe onboarding and controlled promotions.

---

## 4. Phase 1: Initial Onboarding (Import Phase)

Use this phase only while resources exist in environments but are not in Terraform state.

## 4.1 UAT onboarding import

1. Create a PR into env/uat with exact current UAT YAML/tfvars for target objects.
2. Merge PR to env/uat.
3. Run pipeline from env/uat with:
   - runImportUAT = true
   - runApplyUAT = false
   - runImportProd = false
   - runApplyProd = false
4. Review import outcome and state.
5. Run plan-only/controlled UAT apply from release branch after promotion as needed.

## 4.2 PROD onboarding import

1. Create a PR into env/prod with exact current PROD YAML/tfvars for target objects.
2. Merge PR to env/prod.
3. Run pipeline from env/prod with:
   - runImportProd = true
   - runApplyProd = false
   - runImportUAT = false
   - runApplyUAT = false
4. Review import outcome and state.

Important:
1. During onboarding, UAT and PROD YAML for the same flow may differ.
2. Keep each env branch true to that environment's current reality for import safety.

---

## 5. Phase 2: Normal Delivery (Post-Onboarding)

Once objects are managed in Terraform state, import is not part of normal delivery.

## 5.1 Standard request flow

1. Developer works in feature/request-X.
2. Developer exports from DEV and updates repo YAML/tfvars.
3. Create release/request-X from main.
4. PR feature/request-X into release/request-X and merge after checks/approval.
5. Run UAT deploy from release/request-X:
   - runApplyUAT = true
   - runApplyProd = false
6. After successful UAT deploy, update `wiki/Terraform-Managed-Objects.md` on the `docs/wiki` branch:
   - Add or update the object row with `Environments = UAT`.
   - Commit directly or raise a PR to `docs/wiki` per your team's review policy.
   - This tells Genesys UI users: do not modify this object in the UAT environment.
7. Complete UAT testing/signoff.
8. Run PROD deploy from same release/request-X (same commit or approved tag strategy):
   - runApplyUAT = false
   - runApplyProd = true
9. After successful PROD deploy, update `wiki/Terraform-Managed-Objects.md` on the `docs/wiki` branch:
   - Update the object row to `Environments = UAT, PROD`.
   - Commit directly or raise a PR to `docs/wiki` per your team's review policy.
   - This tells Genesys UI users: do not modify this object in any environment.
10. After successful PROD deploy, merge release/request-X into main.

Alternative (only if release PR is not mandated by team policy):
1. Create `release/request-X` from `feature/request-X` and deploy directly from that release branch.
2. This is technically valid for pipeline branch rules, but gives less promotion audit trail than the recommended PR-based promotion.

## 5.2 If UAT and PROD dates differ

1. Use two separate runs.
2. First run: UAT only.
3. Later run: PROD only from same release branch lineage.

---

## 6. Working with Multiple Developers

If different requests are in the same sprint:

1. Use separate release branches per request.
2. Do not mix unrelated requests with different PROD dates in one release branch.
3. Promote each request independently to avoid accidental early PROD deployment.

If two developers change the same flow:

1. Second developer must rebase/merge on top of first deployed flow version before promotion.
2. Resolve YAML conflicts so final file contains both intended changes.
3. Retest in UAT before PROD.

---

## 7. Import Rules

1. Import is state onboarding only.
2. Import does not publish or deploy changes by itself.
3. Keep import selections ticket-scoped:
   - scripts/genesys/specs/import_selection_uat.json
   - scripts/genesys/specs/import_selection_prod.json
4. After import, continue with normal release-branch deployment flow.

---

## 8. Governance and Safety Controls

1. Protect main, env/uat, env/prod, and release/* branches.
2. Require PR reviews for baseline and release changes.
3. Keep allow_destroy false by default.
4. Require environment approvals for PROD deploy.
5. Allow only one production apply at a time per workspace.

---

## 9. Quick Run Parameter Matrix

Terraform Cloud workspace mode (only supported mode):
1. useTerraformCloudWorkspaces is always enabled in pipeline execution.
2. Org name and workspace names are hardcoded in pipeline.
3. Token options in variable groups:
   - shared token for both envs: TFC_TOKEN
   - separate env tokens: TFC_TOKEN_UAT and TFC_TOKEN_PROD
4. Fallback order used by pipeline:
   - UAT: TFC_TOKEN_UAT -> TFC_TOKEN
   - PROD: TFC_TOKEN_PROD -> TFC_TOKEN

UAT import run (on env/uat):
1. runImportUAT = true
2. runApplyUAT = false
3. runImportProd = false
4. runApplyProd = false

PROD import run (on env/prod):
1. runImportProd = true
2. runApplyProd = false
3. runImportUAT = false
4. runApplyUAT = false

UAT deploy run (on release/*):
1. runApplyUAT = true
2. runApplyProd = false
3. runImportUAT = false (true only if exceptional onboarding in same run model)
4. runImportProd = false

PROD deploy run (on release/*):
1. runApplyUAT = false
2. runApplyProd = true
3. runImportUAT = false
4. runImportProd = false (true only in exceptional cases)

---

## 10. Target End State

After onboarding stabilizes:

1. env/uat and env/prod are used rarely (drift onboarding/exceptions).
2. Daily delivery runs through feature -> release -> main.
3. Import becomes exception-only, not routine.

---

## 11. Division Management

Divisions are referenced by name in tfvars (e.g. `division_name = "Terraform"`). `Main.tf` builds a single `local.division_id_map` passed to every module. Two ownership modes exist – mutually exclusive per division name.

### 11.1 External (UI-managed) division

The division already exists in Genesys Cloud and is not created by Terraform.

1. Leave `configs/divisions.tfvars` commented out for this division.
2. Add its name to the `toset([...])` in `data "genesyscloud_auth_division" "external"` in `Main.tf`.
3. Terraform resolves the ID at plan time. No import needed – Terraform never owns the resource.

### 11.2 Terraform-managed division

Terraform creates and owns the division.

1. Add it to `configs/divisions.tfvars` (uncommented).
2. Remove it from the `toset([...])` external lookup – duplicating a name in both causes a plan failure because the data source evaluates before the resource is created.
3. If the division already exists in Genesys Cloud, run `terraform import` before the first apply.

### 11.3 Adding a new external division reference

If any new tfvars entry uses a `division_name` not yet in the map, add the name to the external toset in `Main.tf`:

```hcl
data "genesyscloud_auth_division" "external" {
  for_each = toset(["Terraform", "AnotherDivision"])
  name     = each.key
}
```

---

## 12. Flow Dependencies (Inbound ↔ InQueue)

Inbound and InQueue flows may reference each other by name in their YAML (e.g., `overrideInQueueFlow`, or custom connectors calling back). Terraform cannot automatically detect these cross-flow references in YAML files, so you must explicitly declare publication order via `depends_on`.

Without a dependency, Terraform may publish both flows in parallel. The referencing flow publishes before the referenced flow exists in Genesys Cloud, causing Genesys to silently drop the reference (e.g., `overrideInQueueFlow` maps to nothing).

### 12.1 Adding flow dependencies in Main.tf

In `Main.tf`, both `module.flows_inbound` and `module.flows_inqueue` have commented-out depends_on options:

**Option 1: Inbound → InQueue (inbound references inqueue)**

Uncomment the depends_on in `flows_inbound` to include `module.flows_inqueue`. InQueue flows publish first:

```hcl
module "flows_inbound" {
  ...
  depends_on = [module.queues, module.schedule_groups, module.user_prompts, module.flows_inqueue]
}
```

**Option 2: InQueue → Inbound (inqueue references inbound)**

Uncomment the depends_on in `flows_inqueue` to include `module.flows_inbound`. Inbound flows publish first:

```hcl
module "flows_inqueue" {
  ...
  depends_on = [module.flows_inbound]
}
```

**Option 3: No cross-references**

Leave both blocks with their default `depends_on` lists (no cross-module references).

### 12.2 How to decide

1. **Review your YAML files** – search for references by flow name in YAML blocks like `overrideInQueueFlow`, `connectTo`, `transferToFlow`, etc.
2. **Determine direction** – if flow A references flow B, add B to A's depends_on.
3. **Update Main.tf** – uncomment the appropriate line(s) and commit the change.
4. **Re-apply** – force a republish if needed (e.g., `terraform taint module.flows_inbound.genesyscloud_flow.flows["FlowName"]`).

This ensures both flows exist in Genesys Cloud before either references the other.

---

## 13. Concurrent Developer Deployments – Rules and Best Practices

### 13.1 The core problem

Terraform manages **desired state**. The state file holds what Terraform believes exists in the environment. When you deploy, Terraform compares the state to your code and plans to create, update, or delete to make them match.

If Developer 2 deploys a branch that does not include objects already deployed by Developer 1, Terraform plans to **delete** those objects. Even if `prevent_destroy` blocks the actual delete, the pipeline fails and is blocked.

This is not a bug. It is how Terraform works. The team must manage it through branch hygiene.

Key baseline facts:
- `main` reflects **PROD truth only** – what has been approved and deployed to PROD.
- UAT state in Terraform Cloud can be **ahead of main** during active sprints.
- PROD state should only ever contain **approved and released objects**.

---

### 13.2 Foundational rules

1. **Before any UAT deploy:** your release branch must contain all objects currently in UAT state, plus your new changes.
2. **Before any PROD deploy:** your release branch must contain only objects approved for PROD, and must represent the full desired PROD state after your change.
3. **Sync PR** = merging an already-deployed release branch into your release branch before your own deploy. This is not a feature PR. It keeps your branch aligned with the deployed environment state.
4. **After a successful PROD deploy:** merge your release branch into `main` to keep the PROD baseline current.
5. **Never force `main` into a UAT deploy branch** when UAT is ahead of PROD – this causes UAT deletes.

---

### 13.3 Scenario: Different flows, same UAT and PROD date

Dev1 works on flow B. Dev2 works on flow C. Both deploy to UAT on the same day, and both go to PROD on the same day.

**If Dev1 deploys to UAT first:**
1. Dev2 creates a sync PR: `release/request-1` → `release/request-2`.
2. `release/request-2` now has `A + B + C`.
3. Dev2 deploys to UAT. UAT state gets `A + B + C`. No deletes.
4. Both get PROD approval.
5. Dev1 deploys `release/request-1` to PROD. PROD gets `A + B`.
6. Dev2 creates a sync PR for PROD: `release/request-1` → `release/request-2` (if not already done).
7. Dev2 deploys `release/request-2` to PROD. PROD gets `A + B + C`.
8. Both merge their release branches to `main`.

**If both deploy to UAT at the same time:**
- Coordinate who goes first – treat it as serialized. Use the same sync PR pattern above.
- Do not run two UAT deploys in parallel. Terraform state locks, and one will fail.

---

### 13.4 Scenario: Different flows, same UAT date but different PROD dates

Dev1 deploys B to UAT. Dev2 deploys C to UAT (after sync). Dev2 gets PROD approval first. Dev1 does not yet have PROD approval.

**Dev2 PROD deploy:**
1. `release/request-2` (UAT branch) has `A + B + C` after UAT sync.
2. PROD currently only has `A`.
3. Do NOT deploy `release/request-2` to PROD – it would carry `B` into PROD without approval.
4. Create a separate PROD branch: `release/request-2-prod` from `main` (which has `A`).
5. Cherry-pick only the commits introducing `C` from `release/request-2` into `release/request-2-prod`.
6. Deploy `release/request-2-prod` to PROD. PROD gets `A + C`.
7. Merge `release/request-2-prod` into `main`.

**Later when Dev1 gets PROD approval:**
1. Dev1 deploys `release/request-1` to PROD. PROD gets `A + B + C`.
2. Dev1 merges `release/request-1` into `main`. `main` now has `A + B + C`.

**UAT and PROD configs diverge temporarily** during this window. That is acceptable and expected.

---

### 13.5 Scenario: Both developers working on the same flow

Dev1 and Dev2 both modify flow `B` (e.g., one adds a menu option, the other changes routing). Same sprint.

**Rules:**
1. One developer owns the YAML for the sprint. The other provides their changes as input.
2. The owning developer merges both changes into the YAML before creating the release branch.
3. Only one release branch per flow per sprint. Do not have two release branches both modifying the same YAML file – this creates merge conflicts and unpredictable deployed state.
4. If both independently modify the same YAML, the second developer must merge the first developer's changes into their YAML, verify the combined change is correct, retest in UAT, then proceed.

**If conflict already exists:**
1. Stop. Do not deploy either branch independently.
2. Create a combined release branch.
3. Manually merge YAML changes from both feature branches.
4. Test combined state in UAT.
5. Deploy combined branch as a single release.

---

### 13.6 Scenario: Bug fix needed after UAT deploy, before PROD

Dev1 deploys `B` to UAT. UAT testing finds a bug. Dev1 must fix it before PROD.

1. Fix the YAML or tfvars on the same release branch `release/request-1`.
2. Re-deploy to UAT from the same branch.
3. If Dev2 already synced from `release/request-1` before the fix, Dev2 must create another sync PR to pick up the fix.
4. Re-run UAT verification.
5. Then proceed to PROD from the fixed branch.

**Important:** If Dev2 synced the broken version of `B` into their UAT branch, Dev2's UAT will also reflect the bug until they sync again with the fixed `release/request-1`.

---

### 13.7 Scenario: Bug fix after PROD deploy

Dev1's change `B` is already in PROD. A bug is found in PROD.

1. Create a hotfix branch from `main` (which now includes `B` after the PROD merge).
2. Fix the YAML/tfvars on the hotfix branch.
3. Deploy hotfix to UAT first (sync PR if others have already deployed to UAT after Dev1).
4. After UAT sign-off, deploy hotfix to PROD.
5. Merge hotfix branch into `main`.

**Do not reuse the original `release/request-1` branch** for hotfixes if other developers have already synced from it. The branch may no longer represent a clean known state.

---

### 13.8 Scenario: Dev1 goes to UAT but not PROD. Dev2 goes to both UAT and PROD in same sprint.

UAT state has `A + B + C`. PROD only has `A`. Dev2 is approved for PROD with `C` only.

- Dev2 must create a PROD-specific branch from `main`.
- Cherry-pick only `C` into it.
- Deploy to PROD – PROD gets `A + C`.
- `B` does not enter PROD.
- When Dev1 eventually gets PROD approval, Dev1 deploys from their branch (which should be synced with `main` which now has `A + C`), so PROD ends up with `A + B + C`.

---

### 13.9 Scenario: Emergency fix while sprint releases are in flight

A critical PROD issue requires an immediate fix while Dev1 and Dev2 are mid-sprint with UAT-only deploys.

1. Create a `hotfix/issue-name` branch from `main` immediately.
2. Make only the minimal targeted fix on that branch.
3. Deploy hotfix to UAT – sync PR from latest deployed UAT branch first so UAT state is not disrupted.
4. Get emergency approval and deploy to PROD.
5. Merge `hotfix/issue-name` into `main`.
6. Dev1 and Dev2 must each create a sync PR from `main` (or the hotfix branch) into their release branches before their next UAT or PROD deploy.

---

### 13.10 What NOT to do

| Don't | Why |
|-------|-----|
| Deploy to UAT without syncing with the latest deployed UAT branch | Terraform plans deletes for objects in UAT state but missing from your branch |
| Sync from `main` for UAT deploy when UAT is ahead of PROD | `main` reflects PROD only; UAT-only objects will be deleted |
| Deploy a UAT-synced branch to PROD if it carries unapproved objects | Unapproved objects silently enter PROD |
| Have two developers independently modify the same YAML and deploy separately | Merge conflicts and unpredictable desired state |
| Run two UAT or PROD deploys in parallel | Terraform state locks; one run will fail |
| Use the original release branch as a hotfix vehicle after others have synced from it | Branch state is no longer a clean baseline |
| Skip merging your release branch to `main` after PROD deploy | `main` drifts from PROD truth and future syncs become unreliable |
| Rely on `prevent_destroy` as a safety net | It blocks the run entirely; the deploy fails rather than proceeding safely |

---

### 13.11 Quick decision checklist before any deploy

**Before UAT deploy:**
- [ ] Has any other release branch been deployed to UAT after my last sync? → If yes, create a sync PR first.
- [ ] Does my branch now contain all objects currently in UAT state? → Verify by reviewing deployed release branches.
- [ ] Am I modifying any YAML that another developer also modified? → Coordinate and merge YAMLs before deploying.
- [ ] Is no other UAT deploy running at the same time? → Confirm pipeline has no active UAT run.

**Before PROD deploy:**
- [ ] Does my branch contain only objects approved for PROD? → If no, create a PROD-specific branch from `main` with cherry-picked commits.
- [ ] Is everything in my branch already in `main` or explicitly PROD-approved? → Verify with approvers.
- [ ] Has `main` been updated with other PROD deploys since I last synced? → If yes, sync from `main` into your PROD branch first.
- [ ] After successful PROD deploy, did I merge my release branch into `main`? → Do this immediately after PROD success.

---

### 13.12 Summary matrix

| Scenario | UAT action | PROD action |
|----------|------------|-------------|
| Different flows, same date | Sync PR from latest UAT branch, then deploy | Sync PR from `main`, then deploy in sequence |
| Different flows, different PROD dates | Sync PR from latest UAT branch, then deploy | Create PROD-specific branch from `main`, cherry-pick only approved commits |
| Same flow, both devs modifying | Combine YAML changes in one branch, one UAT deploy | Same combined branch to PROD |
| Bug found after UAT deploy | Fix on same release branch, redeploy to UAT | Others who synced the bug must re-sync after fix |
| Bug found after PROD deploy | Create hotfix from `main`, sync with UAT, deploy to UAT first | Deploy hotfix to PROD, merge to `main` |
| Emergency fix mid-sprint | Hotfix branch from `main`, sync with UAT state | Emergency PROD deploy, merge to `main`, others re-sync |
| Parallel deploys (race condition) | Serialise – one at a time, second waits and syncs after first completes | Same |
