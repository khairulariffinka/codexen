```
┌─────────────────────────────────────────────────────────────────┐
│                    SPECIFICATION CHAIN                          │
│                                                                 │
│  BRS ──► SRS ──► SDS ──► Planner ──► Code                      │
│  (apa)   (macam mana)   (teknikal)   (bila)    (buat)          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  1. BRS — Business Requirement Spec                             │
│     "Apa yang client nak?"                                      │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ @client: "Saya nak sistem e-commerce"                  │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                             │                                   │
│  ┌──────────────────────────▼──────────────────────────────┐   │
│  │ @brs-manager output:                                   │   │
│  │                                                        │   │
│  │  REQ-001: User registration (MUST)                    │   │
│  │  REQ-002: Product catalog (MUST)                      │   │
│  │  REQ-003: Shopping cart (MUST)                      │   │
│  │  REQ-004: Payment gateway (MUST)                      │   │
│  │  REQ-005: WhatsApp notify (SHOULD)                    │   │
│  │  REQ-006: Mobile app (COULD)                          │   │
│  │                                                        │   │
│  │  Budget: RM50,000                                     │   │
│  │  Timeline: 3 months                                   │   │
│  │  Exclusions: Mobile app (Phase 2)                     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  2. SRS — Software Requirement Spec                             │
│     "System kena buat apa?"                                     │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ @srs-manager input: BRS                                 │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                             │                                   │
│  ┌──────────────────────────▼──────────────────────────────┐   │
│  │ @srs-manager output:                                   │   │
│  │                                                        │   │
│  │  FR-001.1: Register with email & password             │   │
│  │  FR-001.2: Email verification                          │   │
│  │  FR-001.3: Account lockout after 5 failed attempts     │   │
│  │  FR-002.1: Product listing with pagination             │   │
│  │  FR-002.2: Search by name & category                   │   │
│  │  FR-003.1: Add/remove items from cart                  │   │
│  │                                                        │   │
│  │  NFR: Page load < 2s, 99.5% uptime, PDPA compliance   │   │
│  │  UC-01: User registers → verify email → login         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  3. SDS — System Design Spec                                    │
│     "Macam mana nak buat?"                                      │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ @sds-manager input: SRS                                 │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                             │                                   │
│  ┌──────────────────────────▼──────────────────────────────┐   │
│  │ @sds-manager output:                                   │   │
│  │                                                        │   │
│  │  ERD:                                                  │   │
│  │    User ──1:N──> Order ──N:1──> Product               │   │
│  │    User ──1:1──> Cart ──N:M──> Product                │   │
│  │                                                        │   │
│  │  API:                                                  │   │
│  │    POST /api/auth/register     → FR-001.1              │   │
│  │    POST /api/auth/login        → FR-001.2              │   │
│  │    GET  /api/products          → FR-002.1              │   │
│  │    POST /api/cart/add          → FR-003.1              │   │
│  │                                                        │   │
│  │  Architecture: Laravel + React + MySQL                 │   │
│  │  Deployment: DigitalOcean VPS                          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  4. Planner — Task Breakdown                                    │
│     "Bila nak buat? Siapa buat?"                                │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ @planner input: SDS                                     │   │
│  └──────────────────────────┬──────────────────────────────┘   │
│                             │                                   │
│  ┌──────────────────────────▼──────────────────────────────┐   │
│  │ planner.md output:                                     │   │
│  │                                                        │   │
│  │  Week 1:                                               │   │
│  │    [ ] BE-001: User model + migration                 │   │
│  │    [ ] BE-002: Register API                            │   │
│  │    [ ] FE-001: Register form                           │   │
│  │                                                        │   │
│  │  Week 2:                                               │   │
│  │    [ ] BE-003: Login API                               │   │
│  │    [ ] FE-002: Login form                              │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  5. Code — Execution                                             │
│     "Buat!"                                                     │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Execute planner.md tasks → code → test → audit → commit │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ KALAU ADA PERUBAHAN (Change Request)                            │
│                                                                 │
│  CR-001: "Client nak tambah GrabPay"                           │
│       │                                                        │
│       ▼                                                        │
│  1. @brs-manager → BRS v1.1 (add REQ-007: GrabPay)            │
│  2. @srs-manager → SRS v1.1 (add FR-004: GrabPay integration) │
│  3. @sds-manager → SDS v1.1 (add GrabPay API contract)        │
│  4. @planner → Add tasks, adjust timeline                     │
│  5. Code → Test → Audit → Commit                              │
│                                                                 │
│  Semua version naik, changelog dikemaskini.                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ BILA NAK GUNAKAN SPEC CHAIN?                                    │
│                                                                 │
│  ✅ GUNAKAN:                                                    │
│     - Client project (ada signature)                           │
│     - Team development (ramai developer)                        │
│     - Complex system (banyak module)                            │
│     - Need quotation & timeline                                │
│                                                                 │
│  ❌ TAK PAYAH:                                                  │
│     - Personal project                                          │
│     - Solo dev / side project                                   │
│     - Quick prototype                                           │
│     - Fix bug / refactor code yang sedia ada                   │
│                                                                 │
│  Ringkas: Client minta quotation? → Guna.                    │
│  Sendiri nak coding petang-petang? → Terus tanya @coder.    │
└─────────────────────────────────────────────────────────────────┘
```
