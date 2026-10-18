# my-skills

Claude Code skills for phase-based, spec-driven development.

## The loop

```
0 skill-roadmap-planner ──► ROADMAP.md + FUNC-SPEC.md + TECH-SPEC.md   ✅ approve
        │                    (all features listed; first milestone in detail)
        ▼   for each milestone
1 skill-phase-breakdown      milestone → phases (one behavior each)     ✅ approve
        │
        ▼   for each phase
2 skill-discovery            optional: you lead, it runs + documents    ✅ approve spec edits
3 skill-phase-plan           tasks + demo script                        ✅ approve
        │                    ↺ plan ahead: repeat 2–3 for every phase first
4 skill-phase-build          implement → verify → commit                stops only on problems
5 skill-phase-review         scan, your demo (+ retro on last phase)    ✅ you verify
        │
        └──► next phase · next milestone (step 1) · re-plan (step 0)
```

**Two modes per milestone**, chosen after the first plan:
- **Build now:** 2 → 3 → 4 → 5 for each phase in turn.
- **Plan ahead:** loop 2 → 3 until every phase is planned (all unknowns discovered up front), then 4 → 5 for each phase in order. Build re-checks a plan made earlier against the current code before starting it.

- **Milestone** (`M1`, `M2`…): a group of features that makes a usable release.
- **Phase** (`P01`, `P02`…): one simple behavior of one feature, demoed on its own.
- **Discovery**: for unknowns like an external REST API. You give step-by-step instructions; the skill runs them and logs every request and result until it works, then distills a recipe, facts, test fixtures, and spec updates for the code.

## Files in a target project

```
ROADMAP.md                     # vision, features, milestones → phases, learnings
FUNC-SPEC.md                   # behaviors + acceptance criteria (current truth)
TECH-SPEC.md                   # policies, stack, conventions, structure, testing, integrations
discovery/
  shop-orders-api.md           # log, recipe, facts, spec impact
  shop-orders-api/fixtures/    # sanitized sample responses for tests
phases/
  01-signup.md                 # demo, tasks, review for that phase
  02-duplicate-email.md
```

## Installing

Run `sync-skills.ps1` (Windows) or `./sync-skills.sh` (macOS/Linux) after editing. It copies each skill to `~/.claude/skills/<name>/SKILL.md` and removes retired skills from earlier pipelines.
