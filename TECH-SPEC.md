# Technical Specification

## 1. Technology Stack

### Classification

- **Project type:** Internal company project
- **CVE policy:** Zero-tolerance for unpatched Critical/High CVEs — enforced via `govulncheck` in CI on every build
- **Tech radar constraint:** Go (company-approved stack)
- **Compliance:** None specifically required

### Language & Runtime

- **Go 1.26.2** — current stable release (Apr 2026); Go 1.27 not yet released as of selection date. Re-verify latest 1.26.x patch at implementation time; Go's support policy only patches the latest two major versions.

### Inventory Storage (HEAD + Reverse Diffs)

- **PostgreSQL 17.x** — JSONB for `ResourceDocument`/diff payloads; ACID transactions satisfy the atomic HEAD+diff commit / full-rollback-on-failure behavior required by FUNC-SPEC §7.
- **Driver:** `jackc/pgx` **v5.9.2+** — must pin to this version or later to avoid CVE-2026-41889 (SQL injection under simple-protocol + dollar-quoted-literal conditions). Also confirms fix for older CVE-2024-27289/27304. Use the extended/prepared-statement protocol exclusively (never the simple protocol) as defense in depth, avoiding the vulnerable code path by design.

### AWS Discovery & Deep Collectors

- **`aws-sdk-go-v2`**, pinned to a build ≥2026-03-23 to include the fix for GHSA-xmrv-pmrh-hhx2 (DoS panic in EventStream decoder, CVSS 5.9 Medium).
- Generic discovery: AWS Config aggregator / Resource Explorer / Cloud Control API clients (FUNC-SPEC §6 Discovery Mechanism).
- Specialized deep collectors: per-service clients (ec2, iam, rds, elasticloadbalancingv2, s3, lambda), extendable via the Collector Plugin Contract.

### Kafka Admin Collector

- **`twmb/franz-go`** + its `kadm` admin sub-package — pure Go, no cgo, avoiding the librdkafka C-library CVE surface entirely. Feature-complete Admin API (topics, configs, ACLs, broker/cluster metadata, consumer groups). No known CVEs at time of review.

### Kubernetes Discovery Collector

- **`k8s.io/client-go`** (latest, matched to newest supported cluster skew) + `k8s.io/client-go/dynamic` for generic API-resource discovery, satisfying the exhaustive-listing behavior from FUNC-SPEC §6. No current Critical/High CVE found.

### Database Introspection Collector

- **PostgreSQL only** (confirmed scope). Same pinned `jackc/pgx` v5.9.2+ driver; introspection via `information_schema`/`pg_catalog` using a read-only role. Additional engines (MySQL, SQL Server, Oracle) are added later as new collectors via the Collector Plugin Contract, not a core change.

### Diff Engine

- **`evanphx/json-patch/v5`** (RFC 6902 JSON Patch generation/application). Historical CVE-2018-14632 was fixed in 0.5.2/3.0.1, several major versions before the current `/v5` module — clean at time of review.

### Query API

- Standard library **`net/http`** with Go 1.22+'s pattern-matching `ServeMux` — no third-party router dependency, minimizing dependency/CVE surface for the point-in-time reconstruction and change-report endpoints (FUNC-SPEC §7).

### Logging / Observability

- Standard library **`log/slog`** — structured logging with zero third-party dependency.

### Scheduling / Deployment

- **Kubernetes CronJob** (daily trigger) running the Go binary as a container — consistent with the company already operating Kubernetes (one of the inventoried sources), avoiding a separate scheduler dependency.

### Testing

- Standard library `testing` + `stretchr/testify` for assertions.
- `k8s.io/client-go/kubernetes/fake` for the Kubernetes collector.
- Hand-written fake AWS/Kafka/DB clients behind the Collector Plugin Contract interfaces (FUNC-SPEC §6) — avoids pulling in a general-purpose mocking framework, keeping dependency count minimal per the zero-CVE-tolerance policy.

### CI Security Gate

- **`govulncheck`** (official Go vulnerability scanner) runs on every CI build; build fails on any Critical/High finding, operationalizing the zero-tolerance CVE policy on an ongoing basis, not just at selection time.

### CVE Audit Log (at time of selection)

| Component | Status | Action Taken |
|---|---|---|
| Go | Latest stable 1.26.2 (Apr 2026); 1.27 not yet released | Track latest 1.26.x patch |
| `aws-sdk-go-v2` | Medium DoS, GHSA-xmrv-pmrh-hhx2, fixed ≥2026-03-23 build | Pinned to fixed build |
| `k8s.io/client-go` | No current Critical/High CVE found | Clean |
| `twmb/franz-go` | No CVEs found | Clean |
| `jackc/pgx` | CVE-2026-41889 (SQLi) fixed in v5.9.2; older CVE-2024-27289/27304 fixed earlier | Pinned ≥5.9.2; simple protocol avoided by design |
| `evanphx/json-patch` | CVE-2018-14632 fixed in 0.5.2/3.0.1, well before current `/v5` | Clean on `/v5` |

## 2. Approval Log

- **2026-08-28** — Project classification (internal, Go, zero-CVE-tolerance, no specific compliance framework), full technology stack, and CVE audit approved by user (mhmiwa@gmail.com).
