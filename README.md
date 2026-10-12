# my-skills

Claude Code skills for cycle-based, spec-driven development.

## The loop

```
skill-roadmap-planner ──► ROADMAP.md (features → POC, Phase 1, Phase 2…)
        │
        ▼   for each cycle
  1 skill-cycle-scope    what the cycle delivers        ✅ approve
  2 skill-cycle-design   how (only what's needed)       ✅ approve if stack/deps/conventions change
  3 skill-cycle-plan     slices, tasks, demo scripts    ✅ approve
  4 skill-cycle-build    implement → verify → commit    stops only on problems
  5 skill-cycle-review   scan, your demo, retro         ✅ you verify
        │
        └──► next cycle (or back to roadmap-planner to re-plan)
```

| Cycle | Scope | Design | Tests |
|---|---|---|---|
| POC | the question to answer | stack only | optional |
| Phase 1 | full behaviors | POC review + full technical design | required |
| Phase 2+ | full behaviors | delta only | required |

POC code is kept. Phase 1 reviews it and plans any refactor work as tasks.

## Files in a target project

```
ROADMAP.md                # vision, features, cycles, learnings
SPEC.md                   # current truth: ## Product + ## Technical
cycles/
  00-poc/CYCLE.md         # scope, design, plan, review for that cycle
  01-phase-1/CYCLE.md
```

## Installing

Run `sync-skills.ps1` after editing. It copies each skill to `~/.claude/skills/<name>/SKILL.md` and removes the retired 14-step pipeline skills.
