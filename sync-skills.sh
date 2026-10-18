#!/bin/bash
#
# Syncs the skill .md files in this repo into ~/.claude/skills/<name>/SKILL.md
# so Claude Code picks up edits made here.
#
# macOS/Linux counterpart of sync-skills.ps1. Uses plain-file copies (same as
# the Windows script) so both machines behave identically. Run this script
# after editing/adding any skill file in this directory to push the changes
# to the global skills folder.
#
# Usage (from anywhere):
#   ~/sources/my-skills/sync-skills.sh

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_root="$HOME/.claude/skills"

synced=()
for file in "$repo_dir"/*.md; do
    [ -f "$file" ] || continue
    [ "$(head -n 1 "$file" | tr -d '\r')" = "---" ] || continue

    name_line="$(head -n 20 "$file" | tr -d '\r' | grep -m 1 -E '^name:[[:space:]]*.+$' || true)"
    [ -n "$name_line" ] || continue

    skill_name="$(printf '%s' "$name_line" | sed -E 's/^name:[[:space:]]*//; s/[[:space:]]+$//; s/^"//; s/"$//')"

    target_dir="$skills_root/$skill_name"
    mkdir -p "$target_dir"
    cp -f "$file" "$target_dir/SKILL.md"

    synced+=("$skill_name")
done

echo "Synced ${#synced[@]} skill(s) to $skills_root :"
for skill_name in ${synced[@]+"${synced[@]}"}; do
    echo "  - $skill_name"
done

# Skills from older pipelines (14-step, then cycle-based), replaced by the phase skills.
retired=(
    skill-func-objective-scout skill-func-behavior-mapper
    skill-tech-stack-selector skill-tech-pattern-architect
    skill-tech-solid-enforcer skill-tech-test-architect
    skill-tech-topology-mapper skill-spec-auditor
    skill-task-creator skill-task-verifier skill-task-guardian
    skill-implementation-writer skill-implementation-validator
    skill-implementation-committer
    skill-cycle-scope skill-cycle-design skill-cycle-plan
    skill-cycle-build skill-cycle-review
)

removed=()
for skill_name in "${retired[@]}"; do
    target_dir="$skills_root/$skill_name"
    if [ -e "$target_dir" ]; then
        rm -rf "$target_dir"
        removed+=("$skill_name")
    fi
done

if [ ${#removed[@]} -gt 0 ]; then
    echo "Removed ${#removed[@]} retired skill(s):"
    for skill_name in "${removed[@]}"; do
        echo "  - $skill_name"
    done
fi
